local ShowToolgun = Ponder.API.NewInstruction("ShowToolgun")
ShowToolgun.Length = 0.5

function ShowToolgun:First(playback)
    local env = playback.Environment

    env.ToolgunState = {
        Position = self.Position or Vector(0, 0, 0),
        ToolName = self.Tool or "",
        Alpha = 0,
        IsShowing = true
    }
end

function ShowToolgun:Update(playback)
    local env = playback.Environment
    local state = env.ToolgunState
    if not state then return end

    state.Alpha = Lerp(playback:GetInstructionProgress(self), 0, 1)
end
