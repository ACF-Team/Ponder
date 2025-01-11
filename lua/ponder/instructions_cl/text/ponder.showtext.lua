local ShowText = Ponder.API.NewInstruction("ShowText")
ShowText.Name                     = ""
ShowText.Markup                   = nil
ShowText.Dimension                = "3D"
ShowText.Position                 = vector_origin
ShowText.Icons                    = {}
ShowText.Time                     = 0
ShowText.Length                   = 0.5
ShowText.Horizontal               = TEXT_ALIGN_LEFT
ShowText.Vertical                 = TEXT_ALIGN_TOP
ShowText.TextAlignment            = TEXT_ALIGN_LEFT
ShowText.PositionRelativeToScreen = false

function ShowText:First(playback)
    local env = playback.Environment
    local txt = env:NewText(self.Name)

    if not self.Markup then
        self.Markup = "<font=DermaLarge>" .. tostring(self.Text) .. "</font>"
    end

    txt.Dimension = self.Dimension
    txt.Position = self.Position

    if self.ParentTo then
        local parent = env:GetNamedModel(self.ParentTo)
        txt.Parent = parent
    end

    txt.PositionRelativeToScreen = self.PositionRelativeToScreen
    txt.Horizontal    = self.Horizontal
    txt.Vertical      = self.Vertical
    txt.TextAlignment = self.TextAlignment

    txt:SetMarkup(self.Markup)
end

function ShowText:Update(playback)
    local env = playback.Environment
    local object = env:GetNamedText(self.Name)
    if not object then return end

    local progress = math.ease.OutQuad(playback:GetInstructionProgress(self))
    object.Alpha = progress * 255
end