local PANEL     = {}

DEFINE_BASECLASS("Panel")

function PANEL:Init()
    self:Dock(FILL)

    local toplabel = self:Add("DLabel")
    toplabel:Dock(TOP)
    toplabel:SetFont("Ponder.Subtitle")
    toplabel:SetText(language.GetPhrase("ponder"))
    toplabel:SetSize(0, 48)
    toplabel:SetContentAlignment(5)
    toplabel:SetColor(Color(255, 255, 255))
    toplabel:DockMargin(0, 64, 0, 0)

    local toplabel = self:Add("DLabel")
    toplabel:Dock(TOP)
    toplabel:SetFont("Ponder.Title")
    toplabel:SetText(language.GetPhrase("ponder.category_select"))
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

function PANEL:Load(addon, category)
    local scroller = self.Scroller
    self.TopLabel:SetText(string.format(language.GetPhrase("ponder.pondering_about_category"), addon, category))

    for _, v in ipairs(Ponder.API.GetCategoryStoryboardList(addon, category)) do
        local panel = scroller:Add("DButton")
        panel:Dock(TOP)
        panel:SetSize(0, 96)
        panel:DockMargin(8, 8, 8, 8)
        panel:SetText("")

        local mdl = panel:Add("ModelImage")
        mdl:SetModel(v.Icon)
        mdl:SetMouseInputEnabled(false)
        local y = (panel:GetTall() / 2) - (mdl:GetTall() / 2)
        mdl:SetPos(y, y)

        local name = panel:Add("DLabel")
        name:SetFont("Ponder.BigText")
        name:SetText(v.Name)
        name:Dock(LEFT)
        name:DockMargin(y + 48 + 32, 0, 0, 0)
        name:SizeToContents()
        name:SetColor(self:GetSkin().Colours.Label.Dark)
        name:SetContentAlignment(5)

        local desc = panel:Add("DLabel")
        desc:SetFont("Ponder.Title")
        desc:SetText(v.Description or language.GetPhrase("ponder.no_desc"))
        desc:Dock(RIGHT)
        desc:DockMargin(8, 0, 32, 0)
        desc:SizeToContents()
        desc:SetColor(self:GetSkin().Colours.Label.Dark)
        desc:SetContentAlignment(5)

        function panel:DoClick()
            Ponder.UIWindow:AddBackAction(string.format(language.GetPhrase("ponder.back_to_category"), addon, category), function(ui)
                ui:LoadAddonCategoriesIndex(addon, category)
            end)
            Ponder.UIWindow:LoadStoryboard(v:GenerateUUID())
        end
    end
end

function PANEL:OnRemove()

end

derma.DefineControl("Ponder.AddonCategoryIndex", "Ponder's addon category index", PANEL, "Panel")