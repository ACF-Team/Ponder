local PlaySound = Ponder.API.NewInstruction("PlaySound")

function PlaySound:First(playback)
    if playback.Seeking and self.Length == 0 then return end
    if not self.Sound then return end

    local ply = LocalPlayer()
    if not ply.Ponder3DSounds then
        ply.Ponder3DSounds = {}
    end

    local mdlSound = CreateSound(LocalPlayer(), self.Sound)
    self.ActiveSound = mdlSound
    mdlSound:Play()
end

function PlaySound:Last()
    if self.Length ~= 0 and self.ActiveSound:IsPlaying() then
        self.ActiveSound:Stop()
    end
end

function PlaySound:OnPaused()
    self.ActiveSound:ChangeVolume(0)
end

function PlaySound:OnResumed()
    self.ActiveSound:ChangeVolume(1)
end