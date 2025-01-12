local PlaceModel = Ponder.API.NewInstruction("PlaceModel")
PlaceModel.Name       = ""
PlaceModel.Model      = ""
PlaceModel.Position   = Vector(0, 0, 0)
PlaceModel.Angles     = Angle(0, 0, 0)
PlaceModel.ComeFrom   = Vector(0, 0, 32)
PlaceModel.RotateFrom = Angle(0, 0, 0)
PlaceModel.Time       = 0
PlaceModel.Length     = .5
PlaceModel.LocalTransform = true

function PlaceModel:Preload()
    util.PrecacheModel(self.Model)
end

function PlaceModel:First(playback)
    local env = playback.Environment
    local mdl = env:NewModel(self.Model, self.Name)

    if self.IdentifyAs then
        mdl.IdentifyAs = language.GetPhrase(self.IdentifyAs)
    end

    if self.IdentifyMarkup then
        mdl.IdentifyMarkup = language.GetPhrase(self.IdentifyMarkup)
    end

    if self.ParentTo then
        local parent = env:GetNamedModel(self.ParentTo)
        if IsValid(parent) then
            mdl:SetParent(parent)
        else
            Ponder.Print("Can't parent; parent target not found")
        end
    end

    if self.Length == 0 then -- Does not move
        self.ComeFrom = vector_origin
        self.RotateFrom = angle_zero
    end

    if self.LocalTransform then
        local p, a = LocalToWorld(self.ComeFrom, self.RotateFrom, self.Position, self.Angles)
        mdl:SetPos(p)
        mdl:SetAngles(a)
    else
        mdl:SetPos(self.Position + self.ComeFrom)
        mdl:SetAngles(self.Angles + self.RotateFrom)
    end

    if self.Scale then
        local mat = Matrix()
        mat:Scale(self.Scale)
        mdl:EnableMatrix("RenderMultiply", mat)
        mdl.Scale = self.Scale
    end
end

function PlaceModel:Update(playback)
    local env = playback.Environment
    local progress = math.ease.OutQuad(playback:GetInstructionProgress(self))
    local object = env:GetNamedModel(self.Name)

    if self.LocalTransform then
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
    object.PONDER_AlphaOverride = progress
end