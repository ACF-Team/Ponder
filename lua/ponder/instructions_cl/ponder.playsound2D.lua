local PlaySound2D = Ponder.API.NewInstruction("PlaySound2D")

function PlaySound2D:First()
    surface.PlaySound(self.Sound)
end