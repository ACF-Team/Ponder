local PlaySound3D = Ponder.API.NewInstruction("PlaySound3D")

function PlaySound3D:First(playback)
    if playback.Seeking then return end
    if not self.Target or not self.Sound then return end

    local env = playback.Environment
    local mdl = env:GetNamedModel(self.Target)
    if not IsValid(mdl) then return end

    local ply = LocalPlayer()
    if not ply.Ponder3DSounds then
        ply.Ponder3DSounds = {}
    end

    local mdlSound = CreateSound(LocalPlayer(), self.Sound)
    self.ActiveSound = mdlSound
    mdlSound:Play()
end

function PlaySound3D:Last(playback)
    local env = playback.Environment
    local mdl = env:GetNamedModel(self.Target)
    if not IsValid(mdl) then return end

    if self.Length ~= 0 and self.ActiveSound:IsPlaying() then
        self.ActiveSound:Stop()
    end
end