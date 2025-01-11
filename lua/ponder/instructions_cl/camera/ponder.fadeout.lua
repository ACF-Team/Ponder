local FadeCameraOut = Ponder.API.NewInstruction("FadeCameraOut")
FadeCameraOut.Length   = 0.5
FadeCameraOut.Easing   = math.ease.InOutQuad
function FadeCameraOut:First(playback)
    playback.Environment.Opacity = 1
end

function FadeCameraOut:Update(playback)
    local env = playback.Environment
    local progress = self.Easing and self.Easing(playback:GetInstructionProgress(self)) or playback:GetInstructionProgress(self)

    env.Opacity = 1 - progress
end