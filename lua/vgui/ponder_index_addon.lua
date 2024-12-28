local PANEL     = {}

DEFINE_BASECLASS "Panel"

function PANEL:Init()
    self:Dock(FILL)

    local toplabel = self:Add "DLabel"
    toplabel:Dock(TOP)
    toplabel:SetFont("Ponder.Subtitle")
    toplabel:SetText("Ponder")
    toplabel:SetSize(0, 48)
    toplabel:SetContentAlignment(5)
    toplabel:SetColor(Color(255, 255, 255))
    toplabel:DockMargin(0, 64, 0, 0)

    local toplabel = self:Add "DLabel"
    toplabel:Dock(TOP)
    toplabel:SetFont("Ponder.Title")
    toplabel:SetText("Select a category.")
    toplabel:SetSize(0, 32)
    toplabel:SetContentAlignment(5)
    toplabel:SetColor(Color(255, 255, 255))
    self.TopLabel = toplabel

    local scroller = self:Add("DScrollPanel")
    scroller:Dock(FILL)
    local scrw = ScrW()
    scroller:DockMargin(scrw / 5, 32, scrw / 5, 32)
    self.Scroller = scroller
end

function PANEL:Load(addon)
    local scroller = self.Scroller
    self.TopLabel:SetText("Pondering about '" .. addon .. "'...")
    for _, v in ipairs(Ponder.API.GetAddonCategoriesList(addon)) do
        local panel = scroller:Add "DButton"
        panel:Dock(TOP)
        panel:SetSize(0, 96)
        panel:DockMargin(8, 8, 8, 8)
        panel:SetText("")

        local mdl = panel:Add "ModelImage"
        mdl:SetModel(v.Model)
        mdl:SetMouseInputEnabled(false)
        local y = (panel:GetTall() / 2) - (mdl:GetTall() / 2)
        mdl:SetPos(y, y)

        local name = panel:Add "DLabel"
        name:SetFont("Ponder.BigText")
        name:SetText(v.CategoryName)
        name:Dock(LEFT)
        name:DockMargin(y + 48 + 32, 0, 0, 0)
        name:SizeToContents()
        name:SetColor(Color(35, 35, 35))
        name:SetContentAlignment(5)

        local desc = panel:Add "DLabel"
        desc:SetFont("Ponder.Title")
        desc:SetText(v.Description or "No description provided.")
        desc:Dock(RIGHT)
        desc:DockMargin(8, 0, 32, 0)
        desc:SizeToContents()
        desc:SetColor(Color(35, 35, 35))
        desc:SetContentAlignment(5)

        function panel:DoClick()
            Ponder.UIWindow:AddBackAction("Back to '" .. addon .. "'", function(ui)
                ui:LoadAddonIndex(addon)
            end)
            Ponder.UIWindow:LoadAddonCategoriesIndex(addon, v.CategoryName)
        end
    end
end

function PANEL:OnRemove()

end

derma.DefineControl("Ponder.AddonIndex", "Ponder's addon index", PANEL, "Panel")