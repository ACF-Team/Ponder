local ChangeText = Ponder.API.NewInstruction("ChangeText")
ChangeText.Name                     = ""
ChangeText.Markup                   = nil

function ChangeText:First(playback)
    local env = playback.Environment
    local txt = env:GetNamedText(self.Name)

    if not self.Markup then
        self.Markup = "<font=DermaLarge>" .. tostring(self.Text) .. "</font>"
    end

    txt:SetMarkup(self.Markup)
end
