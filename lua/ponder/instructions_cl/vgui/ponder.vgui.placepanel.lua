local PlacePanel = Ponder.API.NewInstruction("PlacePanel")
PlacePanel.Length = 0.5

function PlacePanel:First(playback)
    local env   = playback.Environment
    local panel = env:NewNamedObject("VGUIPanel", self.Name, self.Type, self.Parent)

    Ponder.VGUI_Support.RunMethods(env, panel, self.Calls, self.Properties)
end

function PlacePanel:Update(playback)
    local progress = playback:GetInstructionProgress(self)
    progress = self.Easing and self.Easing(progress) or progress
    local panel = playback.Environment:GetNamedObject("VGUIPanel", self.Name)
    panel:SetAlpha(progress * 255)
end

--[[ 
Example:
    Chapter1:AddInstruction("PlacePanel", {
        Name = "test123",
        Type = "DPanel",
        Calls = {
            {Method = "SetSize", Args = {512, 512}},
            {Method = "Center"},
        }
    })
]]