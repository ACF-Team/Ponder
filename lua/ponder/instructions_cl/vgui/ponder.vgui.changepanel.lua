local ChangePanel = Ponder.API.NewInstruction("ChangePanel")
ChangePanel.Length = 0

function ChangePanel:First(playback)
    local env   = playback.Environment
    local panel = env:GetNamedObject("VGUIPanel", self.Name)

    Ponder.VGUI_Support.RunMethods(env, panel, self.Calls, self.Properties)
end