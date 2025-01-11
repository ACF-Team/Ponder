local RemovePanel = Ponder.API.NewInstruction("RemovePanel")
RemovePanel.Length = 0.5

function RemovePanel:Update(playback)
    local progress = playback:GetInstructionProgress(self)
    progress = self.Easing and self.Easing(progress) or progress

    local panel = playback.Environment:GetNamedObject("VGUIPanel", self.Name)
    panel:SetAlpha((1 - progress) * 255)
end

function RemovePanel:Last(playback)
    playback.Environment:RemoveNamedObjectByName("VGUIPanel", self.Name)
end