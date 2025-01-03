local PANEL     = {}
local matBlurScreen = Material( "pp/blurscreen" )

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

local padding = 64

local back = Material("ponder/ui/icon128/back.png", "mips smooth")

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    self.Actions = {}

    local close = self:Add "DButton"
    close:SetSize(64, 64)
    close:SetPos(ScrW() - 64 - padding, padding)
    function close.DoClick()
        if #self.Actions <= 0 then
            self:Remove()
        else
            local action = self.Actions[#self.Actions]
            self.Actions[#self.Actions] = nil
            action.callback(self)
        end
        self:UpdateTooltip()
    end
    function self:AddBackAction(text, action)
        self.Actions[#self.Actions + 1] = {
            callback = action,
            text = text
        }
        self:UpdateTooltip()
    end
    function self:UpdateTooltip()
        local action = self.Actions[#self.Actions]
        if not action then
            close:SetTooltip("Back to Game")
        else
            close:SetTooltip(action.text)
        end
    end
    self:UpdateTooltip()
    close:SetText("")
    function close:Paint(w, h)
        local w2, h2 = w / 2, h / 2
        surface.SetMaterial(back)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRectRotated(w2, h2, w, h, 0)
    end
    close:SetTooltipPanelOverride("Ponder.ControlTooltip")
    close:SetTooltipDelay(0)
    self.Birth = CurTime()
    self.Close = close
end

function PANEL:Paint()
    local Fraction = math.ease.OutQuart(math.Clamp((CurTime() - self.Birth) * 4, 0, 1))
    local x, y = self:LocalToScreen(0, 0)
    local wasEnabled = DisableClipping(true)

    if not MENU_DLL then
        surface.SetMaterial(matBlurScreen)
        surface.SetDrawColor(255, 255, 255, 255)

        for i = 0.33, 1, 0.33 do
            matBlurScreen:SetFloat("$blur", Fraction * 5 * i)
            matBlurScreen:Recompute()
            if render then render.UpdateScreenEffectTexture() end
            surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
        end
    end

    surface.SetDrawColor(10, 10, 10, 190 * Fraction)
    surface.DrawRect(x * -1, y * -1, ScrW(), ScrH())

    DisableClipping(wasEnabled)
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

function PANEL:LoadIndex()
    self:LoadMainPanel("Ponder.Index")
end

function PANEL:LoadAddonIndex(addon)
    local panel = self:LoadMainPanel("Ponder.AddonIndex")
    panel:Load(addon)
end

function PANEL:LoadAddonCategoriesIndex(addon, category)
    local panel = self:LoadMainPanel("Ponder.AddonCategoryIndex")
    panel:Load(addon, category)
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