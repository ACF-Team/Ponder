-- TODO: Separate all of these into individual files. 
-- ToolFromTo would be replaced by this kind of macro:
--[[
    ShowToolgun
    MoveToolgunTo
    Delay
    ClickToolgun
    MoveToolgunTo
    Delay
    ClickToolgun
    HideToolgun
]]


local toolsound = "Airboat.FireGunRevDown"
local toolgun96 = Material("ponder/ui/toolgun_cursor96.png")

------------------------------------------------------------------
-- ShowToolgun
------------------------------------------------------------------

local ShowToolgun = Ponder.API.NewInstruction("ShowToolgun")
ShowToolgun.Length = 0.5

function ShowToolgun:First(playback)
    local env = playback.Environment

    env.ToolgunState = {
        Position = Vector(0, 0, 0),
        ToolName = self.Tool or "",
        Alpha = 0,
        IsShowing = true
    }
end

function ShowToolgun:Update(playback)
    local env = playback.Environment
    local state = env.ToolgunState
    state.Alpha = Lerp(playback:GetInstructionProgress(self), 0, 1)
end

------------------------------------------------------------------
-- HideToolgun
------------------------------------------------------------------

local HideToolgun = Ponder.API.NewInstruction("HideToolgun")
HideToolgun.Length = 0.5

function HideToolgun:First()

end

function HideToolgun:Update(playback)
    local env = playback.Environment
    local state = env.ToolgunState
    state.Alpha = Lerp(playback:GetInstructionProgress(self), 1, 0)
end

function HideToolgun:Last(playback)
    playback.Environment.ToolgunState = nil
end

------------------------------------------------------------------
-- MoveToolgunTo
------------------------------------------------------------------

local MoveToolgunTo = Ponder.API.NewInstruction("MoveToolgunTo")
MoveToolgunTo.Length = 0.5
MoveToolgunTo.Position = Vector(0, 0, 0)

local function GetToolgunPos(playback, target, pos)
    if isstring(target) then
        return playback.Environment:GetNamedModel(target):LocalToWorld(pos)
    elseif target == nil then
        return pos
    end
end

function MoveToolgunTo:First(playback)
    local env = playback.Environment

    if self.Length == 0 then
        env.ToolgunState.Position = GetToolgunPos(playback, self.Target, self.Position)
        return
    end

    env.ToolgunState.LerpingPosition = true
    env.ToolgunState.StartPos  = env.ToolgunState.Position
    env.ToolgunState.Target    = self.Target
    env.ToolgunState.TargetPos = self.Position
end

function MoveToolgunTo:Update(playback)
    local env = playback.Environment
    local state = env.ToolgunState

    if state.LerpingPosition then
        local progress = playback:GetInstructionProgress(self)
        progress = self.Easing and self.Easing(progress) or progress
        state.Position = LerpVector(progress, state.StartPos, GetToolgunPos(playback, state.Target, state.TargetPos))
    end
end

function MoveToolgunTo:Last(playback)
    local env = playback.Environment
    local state = env.ToolgunState

    state.LerpingPosition = false
end

------------------------------------------------------------------
-- ClickToolgun
------------------------------------------------------------------

local ClickToolgun = Ponder.API.NewInstruction("ClickToolgun")
ClickToolgun.Length = 0.5
ClickToolgun.Position = Vector(0, 0, 0)

function ClickToolgun:First(playback)
    playback.Environment.ToolgunState.RenderingBeam = true
    playback.Environment.ToolgunState.BeamStart = playback.Environment.ToolgunState.Position
    playback.Environment.ToolgunState.BeamEnd = GetToolgunPos(playback, self.Target, self.Position)
    surface.PlaySound(toolsound)
end

function HideToolgun:Update(playback)
    local env = playback.Environment
    local state = env.ToolgunState
    state.Alpha = Lerp(playback:GetInstructionProgress(self), 1, 0)
end

function HideToolgun:Last(playback)
    playback.Environment.ToolgunState.RenderingBeam = false
end

------------------------------------------------------------------
-- Renderer
------------------------------------------------------------------

local toolgunRenderer = Ponder.API.NewRenderer("Toolgun")

function toolgunRenderer:Initialize(env)
    env.ToolgunState = nil
end

function toolgunRenderer:Render3D(env)
    if not env.ToolgunState then return end
    env.ToolgunState.ToolFromToPos2D = env.ToolgunState.Position:ToScreen()
end

function toolgunRenderer:Render2D(env)
    if not env.ToolgunState then return end
    local state = env.ToolgunState
    local alpha = state.Alpha * 255

    local x, y = state.ToolFromToPos2D.x + 32, state.ToolFromToPos2D.y + 32
    surface.SetMaterial(toolgun96)
    surface.SetDrawColor(255, 255, 255, alpha)
    surface.DrawTexturedRectRotated(x, y, 96, 96, 0)

    draw.SimpleTextOutlined(state.ToolName, "DermaLarge", x, y + 32, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, alpha))
end