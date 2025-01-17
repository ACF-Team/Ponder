local FadeCameraIn = Ponder.API.NewInstruction("FadeCameraIn")
FadeCameraIn.Length   = 0.5
FadeCameraIn.Easing   = math.ease.InOutQuad
function FadeCameraIn:First(playback)
    playback.Environment.Opacity = 0
end

function FadeCameraIn:Update(playback)
    local env = playback.Environment
    local progress = self.Easing and self.Easing(playback:GetInstructionProgress(self)) or playback:GetInstructionProgress(self)

    env.Opacity = progress
end