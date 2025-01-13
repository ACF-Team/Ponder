local PlaySound = Ponder.API.NewInstruction("PlaySound")

PlaySound.Volume = 1
PlaySound.Pitch = 100

-- SoundDuration seems to be buggy with "mp3 files that don't have constant bitrate", so if
-- you run into issues with the OnResumed part, provide the sound duration here
PlaySound.SoundDuration = nil

function PlaySound:First(playback)
    if playback.Seeking and self.Length == 0 then return end
    if not self.Sound then return end

    local ply = LocalPlayer()
    if not ply.Ponder3DSounds then
        ply.Ponder3DSounds = {}
    end

    local mdlSound = playback.Environment:CreateSound(LocalPlayer(), self.Sound)
    self.ActiveSound = mdlSound
    mdlSound:PlayEx(self.Volume, self.Pitch)
end

function PlaySound:Last()
    if self.Length and self.Length > 0 and self.ActiveSound:IsPlaying() then
        self.ActiveSound:Stop()
    end
end

function PlaySound:OnPaused()
    self.ActiveSound:ChangeVolume(0)
end

function PlaySound:OnResumed(playback)
    local length = self.Length
    local duration = self.SoundDuration or SoundDuration(self.Sound)
    local time = playback.Time

    if length == 0 and (time - playback:GetInstructionStartTime(self)) > duration then return end

    self.ActiveSound:ChangeVolume(self.Volume)
end