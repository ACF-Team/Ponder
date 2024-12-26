local MoveCameraLookAt = Ponder.API.NewInstruction("MoveCameraLookAt")
MoveCameraLookAt.Target   = vector_origin
MoveCameraLookAt.Distance = 1500
MoveCameraLookAt.Angle    = 55
MoveCameraLookAt.Height   = 1000
MoveCameraLookAt.Length   = 0.5
MoveCameraLookAt.Easing   = math.ease.InOutQuad
function MoveCameraLookAt:First(playback)
    playback.LAST_CAMPOS, playback.LAST_LOOKAT = playback.Environment.CameraPosition, playback.Environment.LastLookat
    local pos = playback.Environment:LookParamsToPosAng(self.Distance, self.Angle, self.Height, self.Target)
    playback.TARG_CAMPOS, playback.TARG_LOOKAT = pos, self.Target
end

function MoveCameraLookAt:Render(playback)
    local env = playback.Environment
    local progress = self.Easing and self.Easing(playback:GetInstructionProgress(self)) or playback:GetInstructionProgress(self)

    env:SetCameraPosition(LerpVector(progress, playback.LAST_CAMPOS, playback.TARG_CAMPOS))
    env:SetLookAt(LerpVector(progress, playback.LAST_LOOKAT, playback.TARG_LOOKAT))
end