local HideText = Ponder.API.NewInstruction("HideText")
HideText.Name = ""
HideText.Length = 0.5

function HideText:First(playback)
    local env = playback.Environment
    local txt = env:GetNamedText(self.Name)
    if not txt then return end
end

function HideText:Update(playback)
    local env = playback.Environment
    local object = env:GetNamedText(self.Name)
    if not object then return end

    local progress = math.ease.OutQuad(playback:GetInstructionProgress(self))
    object.Alpha = (1 - progress) * 255
end

function HideText:Last(playback)
    local env = playback.Environment
    env:RemoveTextByName(self.Name)
end
