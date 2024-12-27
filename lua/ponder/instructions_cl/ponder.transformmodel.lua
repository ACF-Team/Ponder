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

    mdl.PONDER_TARG_POS = self.Position
    mdl.PONDER_TARG_ANG = self.Rotation
end

function TransformModel:Update(playback)
    local env = playback.Environment
    local progress = self.Easing and self.Easing(playback:GetInstructionProgress(self)) or playback:GetInstructionProgress(self)
    local object = env:GetNamedModel(self.Target)

    if object.PONDER_TARG_POS then object:SetPos(LerpVector(progress, object.PONDER_LAST_POS, object.PONDER_TARG_POS)) end
    if object.PONDER_TARG_ANG then
        local ang = LerpAngle(progress, object.PONDER_LAST_ANG, object.PONDER_TARG_ANG)
        object:SetAngles((self.LocalToParent and IsValid(object:GetParent())) and object:GetParent():LocalToWorldAngles(ang) or ang)
    end
end

local function LerpColor(t, a, b)
    return Color(
        Lerp(t, a.r, b.r),
        Lerp(t, a.g, b.g),
        Lerp(t, a.b, b.b),
        Lerp(t, a.a, b.a)
    )
end

local ColorModel = Ponder.API.NewInstruction("ColorModel")

function ColorModel:First(playback)
    local env = playback.Environment
    local mdl = env:GetNamedModel(self.Target)
    if not IsValid(mdl) then return end

    mdl.PONDER_LAST_COLOR = mdl.PONDER_TARG_COLOR or mdl:GetColor()
    mdl.PONDER_TARG_COLOR = self.Color
end

function ColorModel:Update(playback)
    local env = playback.Environment
    local progress = self.Easing and self.Easing(playback:GetInstructionProgress(self)) or playback:GetInstructionProgress(self)
    local object = env:GetNamedModel(self.Target)

    if object.PONDER_TARG_COLOR then
        local c = LerpColor(progress, object.PONDER_LAST_COLOR, object.PONDER_TARG_COLOR)
        object:SetColor(c)
        object:SetRenderMode(RENDERMODE_TRANSCOLOR)
    end
end
