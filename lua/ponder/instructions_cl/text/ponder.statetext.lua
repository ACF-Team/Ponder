local StateText = Ponder.API.NewInstruction("StateText")
StateText.Name                     = ""
StateText.Dimension                = "3D"
StateText.Position                 = vector_origin
StateText.Icons                    = {}
StateText.Time                     = 0
StateText.Length                   = 0.5
StateText.Horizontal               = TEXT_ALIGN_LEFT
StateText.Vertical                 = TEXT_ALIGN_TOP
StateText.TextAlignment            = TEXT_ALIGN_LEFT
StateText.PositionRelativeToScreen = false
StateText.RenderOnTopOfRenderers   = true
StateText.LocalizeText             = true -- Running language.GetPhrase every frame MAY NOT BE A GOOD IDEA?

function StateText:First(playback)
    local env = playback.Environment
    local txt = env:NewText(self.Name)

    txt.Dimension = self.Dimension
    txt.Position = self.Position

    if self.ParentTo then
        local parent = env:GetNamedModel(self.ParentTo)
        txt.Parent = parent
    end

    txt.PositionRelativeToScreen = self.PositionRelativeToScreen
    txt.Horizontal               = self.Horizontal
    txt.Vertical                 = self.Vertical
    txt.TextAlignment            = self.TextAlignment
    txt.RenderOnTopOfRenderers   = self.RenderOnTopOfRenderers

    self:Update(playback)
end

function StateText:Update(playback)
    local env = playback.Environment
    local txt = env:GetNamedText(self.Name)

    local progress = math.ease.OutQuad(playback:GetInstructionProgress(self))

    local text = tostring(self.TextFunction(progress))
    self.Markup = "<font=DermaLarge>" .. (self.LocalizeText and language.GetPhrase(text) or text) .. "</font>"

    txt:SetMarkup(noMarkup and self.Markup or language.GetPhrase(self.Markup))
end

function StateText:Last(playback)
    local env = playback.Environment
    env:RemoveTextByName(self.Name)
end