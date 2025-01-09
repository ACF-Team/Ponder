local PlaySound3D = Ponder.API.NewInstruction("PlaySound3D")

function PlaySound3D:First(playback)
    if playback.Seeking then return end
    if not self.Target or not self.Sound then return end

    local env = playback.Environment
    local mdl = env:GetNamedModel(self.Target)
    if not IsValid(mdl) then return end

    local mdlSound = CreateSound(LocalPlayer(), self.Sound)
    mdl.Sound = mdlSound
    mdlSound:Play()
end