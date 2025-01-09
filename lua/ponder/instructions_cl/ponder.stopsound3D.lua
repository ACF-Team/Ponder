local StopSound3D = Ponder.API.NewInstruction("StopSound3D")

function StopSound3D:First(playback)
    if playback.Seeking then return end
    if not self.Target or not self.Sound then return end

    local env = playback.Environment
    local mdl = env:GetNamedModel(self.Target)
    if not IsValid(mdl) or not mdl.Sound then return end

    mdl.Sound:Stop()
end