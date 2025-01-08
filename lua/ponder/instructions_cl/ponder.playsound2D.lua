local PlaySound2D = Ponder.API.NewInstruction("PlaySound2D")

function PlaySound2D:First(playback)
    if playback.Seeking then return end
    surface.PlaySound(self.Sound)
end