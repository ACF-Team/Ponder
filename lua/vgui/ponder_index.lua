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
    toplabel:SetText(language.GetPhrase("ponder.pondering_about"))
    toplabel:SetSize(0, 32)
    toplabel:SetContentAlignment(5)
    toplabel:SetColor(Color(255, 255, 255))

    local scroller = self:Add("DScrollPanel")
    scroller:Dock(FILL)
    local scrw = ScrW()
    scroller:DockMargin(scrw / 5, 32, scrw / 5, 32)

    for _, v in ipairs(Ponder.API.GetAddonsList()) do
        local panel = scroller:Add("DButton")
        panel:Dock(TOP)
        panel:SetSize(0, 96)
        panel:DockMargin(8, 8, 8, 8)
        panel:SetText("")

        local mdl = panel:Add("ModelImage")
        mdl:SetModel(v.Model)
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
            Ponder.UIWindow:AddBackAction(language.GetPhrase("ponder.back_to_index"), function(ui)
                ui:LoadIndex()
            end)
            Ponder.UIWindow:LoadAddonIndex(v.Name)
        end
    end
end

function PANEL:OnRemove()

end

derma.DefineControl("Ponder.Index", "Ponder's addon index", PANEL, "Panel")