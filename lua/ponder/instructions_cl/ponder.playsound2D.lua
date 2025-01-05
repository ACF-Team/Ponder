local PlaySound2D = Ponder.API.NewInstruction("PlaySound2D")

function PlaySound2D:First(playback)
    surface.PlaySound(self.Sound)
end