local TransformModel = Ponder.API.NewInstruction("TransformModel")
TransformModel.Length = 1
TransformModel.LocalToParent = true

function TransformModel:First(playback)
    local env = playback.Environment
    local mdl = env:GetNamedModel(self.Target)
    if not IsValid(mdl) then return end

    mdl.PONDER_LAST_POS = mdl:GetPos()
    mdl.PONDER_LAST_ANG = mdl:GetAngles()

    mdl.PONDER_TARG_POS = self.Position
    mdl.PONDER_TARG_ANG = self.Rotation
end

function TransformModel:Render(playback)
    local env = playback.Environment
    local progress = self.Easing and self.Easing(playback:GetInstructionProgress(self)) or playback:GetInstructionProgress(self)
    local object = env:GetNamedModel(self.Target)

    if object.PONDER_TARG_POS then object:SetPos(LerpVector(progress, object.PONDER_LAST_POS, object.PONDER_TARG_POS)) end
    if object.PONDER_TARG_ANG then
        local ang = LerpAngle(progress, object.PONDER_LAST_ANG, object.PONDER_TARG_ANG)
        object:SetAngles((self.LocalToParent and IsValid(object:GetParent())) and object:GetParent():LocalToWorldAngles(ang) or ang)
    end
end