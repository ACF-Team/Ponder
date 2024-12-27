local TOOLTIP = {}
AccessorFunc(TOOLTIP, "_text", "Text", FORCE_STRING)
AccessorFunc(TOOLTIP, "_font", "Font", FORCE_STRING)

function TOOLTIP:Init()
    self.Birth = RealTime()

    self:SetText("")
    self:SetFont("DermaDefault")
    self:SetDrawOnTop(true)
end

function TOOLTIP:Lifetime()
    return RealTime() - self.Birth
end

function TOOLTIP:GetTextSize()
    surface.SetFont(self:GetFont())
    return surface.GetTextSize(self:GetText())
end

function TOOLTIP:Close()
    self:Remove()
end

function TOOLTIP:Think()
    local sW, sH = self:GetTextSize()
    self:SetTall(sH + 12)
    self:SetWide((sW * self:GetAlphaMult(0.7)) + 12)

    --local pX, pY = input.GetCursorPos()
    --self:SetPos(pX - (self:GetWide() / 2), pY - 8 - sH - 6)
    local target = self.Target
    local tpx, tpy = target:LocalToScreen(0, 0)
    tpx = tpx + (target:GetWide() / 2)
    self:SetPos(tpx - (self:GetWide() / 2), tpy - 8 - sH - 6)
end

function TOOLTIP:GetAlphaMult(min)
    return math.ease.InOutQuad(math.Clamp(math.Remap(self:Lifetime(), 0, 0.1, min or 0, 1), 0, 1))
end

function TOOLTIP:Paint(w, h)
    surface.SetDrawColor(245, 245, 245, 220 * self:GetAlphaMult())
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(25, 25, 25, 255 * self:GetAlphaMult())
    surface.DrawOutlinedRect(0, 0, w, h)

    draw.SimpleText(self:GetText(), self:GetFont(), w / 2, h / 2, Color(25, 25, 25, 255 * self:GetAlphaMult()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function TOOLTIP:OpenForPanel(pnl)
    self.Target = pnl
end

derma.DefineControl("Ponder.ControlTooltip", "Control tooltip", TOOLTIP, "DPanel")