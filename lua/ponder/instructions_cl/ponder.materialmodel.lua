local MaterialModel = Ponder.API.NewInstruction("MaterialModel")

function MaterialModel:First(playback)
    local env = playback.Environment
    local mdl = env:GetNamedModel(self.Target)
    if not IsValid(mdl) then return end

    mdl:SetMaterial(self.Material or "")
end