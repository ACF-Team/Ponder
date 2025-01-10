local toolsound = "Airboat.FireGunRevDown"
local ClickToolgun = Ponder.API.NewInstruction("ClickToolgun")

local function GetToolgunPos(playback, target, pos)
    if isstring(target) then
        return playback.Environment:GetNamedModel(target):LocalToWorld(vector_origin)
    elseif target == nil then
        return pos
    end
end

ClickToolgun.Length = 0.5

function ClickToolgun:First(playback)
    local env = playback.Environment
    local state = env.ToolgunState
    if not state then return end

    local toolgunPos = playback.Environment.ToolgunState.Position
    self.Position = self.Position or toolgunPos

    state.RenderingBeam = true
    state.RenderingMarker = true
    state.BeamStart = toolgunPos
    state.BeamEnd = GetToolgunPos(playback, self.Target, self.Position)
    state.BeamLength = (state.BeamStart - state.BeamEnd):Length()

    if playback.Seeking then return end
    surface.PlaySound(toolsound)
end

function ClickToolgun:Update(playback)
    local env = playback.Environment
    local state = env.ToolgunState
    if not state then return end

    local curProgress = playback:GetInstructionProgress(self)

    state.MarkerAlpha = Lerp(curProgress, 1, 0) * 255

    if state.BeamAlpha and state.BeamAlpha < 1 then
        state.RenderingBeam = false
    else
        state.BeamNorm = (state.BeamStart - state.BeamEnd) * curProgress * 4
        state.BeamNormLength = state.BeamNorm:Length()
        state.BeamAlpha = Lerp(curProgress * 4, 1, 0) * 255
    end
end

function ClickToolgun:Last(playback)
    local env = playback.Environment
    local state = env.ToolgunState
    if not state then return end

    state.RenderingBeam = false
    state.RenderingMarker = false
end