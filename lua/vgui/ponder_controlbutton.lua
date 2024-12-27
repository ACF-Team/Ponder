local CONTROL_BUTTON = {}
function CONTROL_BUTTON:Init()
    self:SetText("")
    self:SetTooltipPanelOverride("Ponder.ControlTooltip")
end

local padding = 0
local paddingIfHover = -4
local paddingIfDepressed = 4

function CONTROL_BUTTON:SetImage(path)
    self.Material = Material(path, "mips smooth")
end

function CONTROL_BUTTON:Paint(w, h)
    local finalPadding = self.Depressed and paddingIfDepressed or self.Hovered and paddingIfHover or padding

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(self.Material)
    surface.DrawTexturedRectRotated(w / 2, h / 2, 48 - finalPadding, 48 - finalPadding, 0)
end

function CONTROL_BUTTON:OnMousePressed(mousecode)
    DButton.OnMousePressed(self, mousecode)
    self.Depressed = true
end

function CONTROL_BUTTON:OnMouseReleased(mousecode)
    DButton.OnMouseReleased(self, mousecode)
    self.Depressed = false
end


derma.DefineControl("Ponder.ControlButton", "Control button", CONTROL_BUTTON, "DButton")