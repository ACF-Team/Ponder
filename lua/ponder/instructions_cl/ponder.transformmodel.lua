local TransformModel = Ponder.API.NewInstruction("TransformModel")
TransformModel.Length = 1
TransformModel.LocalToParent = true

function TransformModel:First(playback)
    local env = playback.Environment
    local mdl = env:GetNamedModel(self.Target)
    if not IsValid(mdl) then return end

    local parent = mdl:GetParent()
    if IsValid(parent) then
        mdl.PONDER_LAST_POS = parent:WorldToLocal(mdl:GetPos())
        mdl.PONDER_LAST_ANG = parent:WorldToLocalAngles(mdl:GetAngles())
    else
        mdl.PONDER_LAST_POS = mdl:GetPos()
        mdl.PONDER_LAST_ANG = mdl:GetAngles()
    end

    if not mdl.Scale then mdl.Scale = Vector(1, 1, 1) end
    mdl.PONDER_LAST_SCA = mdl.Scale

    mdl.PONDER_TARG_POS = self.Position
    mdl.PONDER_TARG_ANG = self.Rotation
    mdl.PONDER_TARG_SCA = self.Scale
end

function TransformModel:Update(playback)
    local env = playback.Environment
    local progress = self.Easing and self.Easing(playback:GetInstructionProgress(self)) or playback:GetInstructionProgress(self)
    local object = env:GetNamedModel(self.Target)

    local parent = object:GetParent()
    local isUsingParent = self.LocalToParent and IsValid(parent)

    if object.PONDER_TARG_POS then
        local pos = LerpVector(progress, object.PONDER_LAST_POS, object.PONDER_TARG_POS)
        object:SetPos(isUsingParent and parent:LocalToWorld(pos) or pos)
    end

    if object.PONDER_TARG_ANG then
        local ang = LerpAngle(progress, object.PONDER_LAST_ANG, object.PONDER_TARG_ANG)
        object:SetAngles(isUsingParent and parent:LocalToWorldAngles(ang) or ang)
    end

    if object.PONDER_TARG_SCA then
        mdl.Scale = LerpVector(progress, object.PONDER_LAST_SCA, object.PONDER_TARG_SCA)
        local mat = Matrix()
        mat:Scale(mdl.Scale)
        mdl:EnableMatrix("RenderMultiply", mat)
    end
end