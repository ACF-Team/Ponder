local ShowText = Ponder.API.NewInstruction("ShowText")
ShowText.Name       = ""
ShowText.Markup     = nil
ShowText.Dimension  = "3D"
ShowText.Position   = vector_origin
ShowText.Icons      = {}
ShowText.Time = 0
ShowText.Length     = 0.5

function ShowText:First(playback)
    local env = playback.Environment
    local txt = env:NewText(self.Name)

    if not self.Markup then
        self.Markup = "<font=DermaLarge>" .. tostring(self.Text) .. "</font>"
    end

    txt.Dimension = self.Dimension
    txt.Position = self.Position

    txt:SetMarkup(self.Markup)
end

function ShowText:Render(playback)
    local env = playback.Environment
    local object = env:GetNamedText(self.Name)
    if not object then return end

    local progress = math.ease.OutQuad(playback:GetInstructionProgress(self))
    object.Alpha = progress * 255
end

local HideText = Ponder.API.NewInstruction("HideText")
HideText.Name = ""
HideText.Length = 0.5

function HideText:First(playback)
    local env = playback.Environment
    local txt = env:GetNamedText(self.Name)
    if not txt then return end
end

function HideText:Render(playback)
    local env = playback.Environment
    local object = env:GetNamedText(self.Name)
    if not object then return end

    local progress = math.ease.OutQuad(playback:GetInstructionProgress(self))
    object.Alpha = (1 - progress) * 255
end

function HideText:Last(playback)
    local env = playback.Environment
    env:RemoveTextByName(self.Name)
end