local toolsound = "Airboat.FireGunRevDown"
local ClickToolgun = Ponder.API.NewInstruction("ClickToolgun")

ClickToolgun.Length = 0.5
ClickToolgun.Position = Vector(0, 0, 0)

function ClickToolgun:First(playback)
    playback.Environment.ToolgunState.RenderingBeam = true
    playback.Environment.ToolgunState.BeamStart = playback.Environment.ToolgunState.Position
    playback.Environment.ToolgunState.BeamEnd = GetToolgunPos(playback, self.Target, self.Position)
    surface.PlaySound(toolsound)
end

function ClickToolgun:Update(playback)
    local env = playback.Environment
    local state = env.ToolgunState
    state.BeamAlpha = Lerp(playback:GetInstructionProgress(self), 1, 0)
end

function ClickToolgun:Last(playback)
    playback.Environment.ToolgunState.RenderingBeam = false
end