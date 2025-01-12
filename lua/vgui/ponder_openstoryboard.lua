local PANEL = {}

function PANEL:Init()
    self:SetText("")
    self.Icon = vgui.Create("ModelImage", self)
    self.Icon:SetMouseInputEnabled(false)
    self.Icon:SetKeyboardInputEnabled(false)

    self.Text = vgui.Create("DLabel", self)
    self.Text:SetFont("Ponder.Title")
end

function PANEL:SetPos(x, y)
    self.PosX = x
    self.PosY = y
    self:InvalidateLayout()
end

local p = 0
function PANEL:PerformLayout(_, h)
    self.Icon:SetPos(p + 8, p)

    self.Icon:SetSize(h - (p * 2), h - (p * 2))
    self.Text:SetTall(h)
    self.Text:SetContentAlignment(5)

    DButton.SetPos(self, self.PosX - (self:GetWide() / 2), self.PosY - (self:GetTall() / 2))
end

function PANEL:SetStoryboard(storyboardUUID)
    self.Storyboard = storyboardUUID
    self.StoryboardObject = Ponder.API.GetStoryboard(storyboardUUID)

    self.Text:SetText(self.StoryboardObject and language.GetPhrase(self.StoryboardObject.MenuName) or "No storyboard!!! Fix this!!!")
    self.Text:SetX(64 + 16)
    self.Text:SetColor(self:GetSkin().Colours.Label.Dark)
    self:InvalidateLayout(true)
    self.Text:SizeToContents()

    self.Icon:SetModel(self.StoryboardObject.ModelIcon)
    self:SizeToChildren(true, false)
    self:SetWide(self:GetWide() + 16)
end

function PANEL:Think()
    self:MoveToFront()
end

function PANEL:DoClick()
    Ponder.Open(self.Storyboard)
end

derma.DefineControl("Ponder.OpenStoryboard", "In-storyboard opener panel", PANEL, "DButton")