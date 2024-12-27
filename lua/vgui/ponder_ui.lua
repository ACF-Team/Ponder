local PANEL     = {}

DEFINE_BASECLASS "Panel"

surface.CreateFont("Ponder.Title", {
    font = "Tahoma",
    extended = false,
    size = 24,
    weight = 100,
    antialias = true
})

surface.CreateFont("Ponder.Subtitle", {
    font = "Tahoma",
    extended = false,
    size = 38,
    weight = 100,
    antialias = true
})

local padding = 48

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    local close = self:Add "DButton"
    close:SetSize(64, 64)
    close:SetPos(ScrW() - 64 - padding, padding)
    function close.DoClick()
        self:Remove()
    end
    close:SetText("")
    function close:Paint(w, h)
        local xc, yc = w / 2, h / 2

        local mult = self.Hovered and 1.5 or self.Depressed and 0.5 or 1
        surface.SetDrawColor(150 * mult, 50 * mult, 50 * mult, 170)
        surface.DrawOutlinedRect(0, 0, w, h, 2)
        local xsize = 12
        surface.DrawLine(xc - xsize, yc - xsize, xc + xsize, yc + xsize)
        surface.DrawLine(xc + xsize, yc - xsize, xc - xsize, yc + xsize)
    end
    self.Close = close
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 170)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:LoadMainPanel(type)
    local p = self:Add(type)
    p:Dock(FILL)
    if IsValid(self.MainPanel) then
        self.MainPanel:Remove()
    end
    self.MainPanel = p
    return p
end

function PANEL:LoadStoryboard(uuid)
    local storyboardVis = self:LoadMainPanel("Ponder.Storyboard")
    storyboardVis:LoadStoryboard(uuid)
end

function PANEL:Think()
    self.Close:MoveToFront()
end

function PANEL:OnRemove()

end

derma.DefineControl("Ponder.UI", "Ponder's root UI element", PANEL, "Panel")