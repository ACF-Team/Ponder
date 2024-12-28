local toolsound = "Airboat.FireGunRevDown"
local ClickToolgun = Ponder.API.NewInstruction("ClickToolgun")

local function GetToolgunPos(playback, target, pos)
    if isstring(target) then
        return playback.Environment:GetNamedModel(target):LocalToWorld(pos)
    elseif target == nil then
        return pos
    end
end

ClickToolgun.Length = 0.5
ClickToolgun.Position = Vector(0, 0, 0)

function ClickToolgun:First(playback)
    local env = playback.Environment
    local state = env.ToolgunState
    if not state then return end

    state.RenderingBeam = true
    state.BeamStart = playback.Environment.ToolgunState.Position
    state.BeamEnd = GetToolgunPos(playback, self.Target, self.Position)
    surface.PlaySound(toolsound)
end

function ClickToolgun:Update(playback)
    local env = playback.Environment
    local state = env.ToolgunState
    if not state then return end

    state.BeamAlpha = Lerp(playback:GetInstructionProgress(self), 1, 0)
end

function ClickToolgun:Last(playback)
    local env = playback.Environment
    local state = env.ToolgunState
    if not state then return end

    state.RenderingBeam = false
end