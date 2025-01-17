local VGUIPanel = Ponder.API.NewNamedObjectType("VGUIPanel")
function VGUIPanel.Initialize(env, _, vgui_type, vgui_parent)
    local parent = vgui_parent and env:GetNamedObject("VGUIPanel", vgui_parent) or nil

    local panel = vgui.Create(vgui_type, parent)
    panel:SetParent(parent)

    function panel:Ponder_OnHalt()
        self.__Ponder_RestoreEnabled = self:IsEnabled()
        self.__Ponder_RestoreVisible = self:IsVisible()
        self:SetEnabled(false)
        self:SetVisible(false)
    end

    function panel:Ponder_OnContinue()
        self:SetEnabled(self.__Ponder_RestoreEnabled == nil and true or self.__Ponder_RestoreEnabled)
        self:SetVisible(self.__Ponder_RestoreVisible == nil and true or self.__Ponder_RestoreVisible)
    end

    Ponder.VGUI_Support.ConfigureParentPaint(panel, parent)
    return panel
end