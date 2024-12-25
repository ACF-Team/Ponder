local instruction = Ponder.API.NewInstruction("PlaceModel")
instruction.Name       = ""
instruction.Model      = ""
instruction.Position   = Vector(0, 0, 0)
instruction.Angles     = Angle(0, 0, 0)
instruction.ComeFrom   = Vector(0, 0, 32)
instruction.RotateFrom = Angle(0, 0, 0)
instruction.Time       = 0
instruction.Length     = .5
instruction.LocalPos   = true

function instruction:Preload()
    util.PrecacheModel(self.Model)
end

function instruction:First(playback)
    local env = playback.Environment
    local mdl = env:NewModel(self.Model, self.Name)
    if self.ParentTo then
        local parent = env:GetNamedModel(self.ParentTo)
        if IsValid(parent) then
            mdl:SetParent(parent)
        else
            Ponder.Print("Can't parent; parent target not found")
        end
    end
end

function instruction:Render(playback)
    local env = playback.Environment
    local progress = math.ease.OutQuad(playback:GetInstructionProgress(self))
    local object = env:GetNamedModel(self.Name)

    if self.LocalPos then
        local p, a = LocalToWorld(
            LerpVector(progress, self.ComeFrom, vector_origin),
            LerpAngle(progress, self.RotateFrom, angle_zero),
            self.Position,
            self.Angles
        )
        object:SetPos(p)
        object:SetAngles(a)
    else
        object:SetPos(self.Position + LerpVector(progress, self.ComeFrom, vector_origin))
        object:SetAngles(self.Angles + LerpAngle(progress, self.RotateFrom, angle_zero))
    end
end

local TransformModel = Ponder.API.NewInstruction("TransformModel")
TransformModel.Length = 1

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
    if object.PONDER_TARG_ANG then object:SetAngles(LerpAngle(progress, object.PONDER_LAST_ANG, object.PONDER_TARG_ANG)) end
end