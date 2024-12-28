local HideToolgun = Ponder.API.NewInstruction("HideToolgun")
HideToolgun.Length = 0.5

function HideToolgun:First()

end

function HideToolgun:Update(playback)
    local env = playback.Environment
    local state = env.ToolgunState
    if not state then return end

    state.Alpha = Lerp(playback:GetInstructionProgress(self), 1, 0)
end

function HideToolgun:Last(playback)
    playback.Environment.ToolgunState = nil
end