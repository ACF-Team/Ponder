local VGUIPanel = Ponder.API.NewNamedObjectType("VGUIPanel")
function VGUIPanel.Initialize(env, _, vgui_type, vgui_parent)
    local parent = vgui_parent and env:GetNamedObject("VGUIPanel", vgui_parent) or nil

    local panel = vgui.Create(vgui_type, parent)
    panel:SetParent(parent)
    Ponder.VGUI_Support.ConfigureParentPaint(panel, parent)
    return panel
end