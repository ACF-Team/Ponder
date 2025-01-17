local ChangeText = Ponder.API.NewInstruction("ChangeText")
ChangeText.Name                     = ""
ChangeText.Markup                   = nil
ChangeText.LocalizeText             = true
function ChangeText:First(playback)
    local env = playback.Environment
    local txt = env:GetNamedText(self.Name)

    local noMarkup = not self.Markup
    if noMarkup then
        local txt = tostring(self.Text)
        self.Markup = "<font=DermaLarge>" .. (self.LocalizeText and language.GetPhrase(txt) or txt) .. "</font>"
    end

    txt:SetMarkup(noMarkup and self.Markup or language.GetPhrase(self.Markup))
end
