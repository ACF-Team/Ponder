local RemoveModel = Ponder.API.NewInstruction("RemoveModel")
RemoveModel.Name       = ""
RemoveModel.GoTo       = Vector(0, 0, 32)
RemoveModel.RotateTo   = Angle(0, 0, 0)
RemoveModel.Length    = .5
RemoveModel.LocalTransform = true

function RemoveModel:First(playback)
    local env = playback.Environment

    if self.Length == 0 then return env:RemoveModelByName(self.Name) end

    local mdl = env:GetNamedModel(self.Name)
    if not mdl then Ponder.Print("No model " .. self.Name) return end
    self.Position = mdl:GetPos()
    self.Angles = mdl:GetAngles()
end

function RemoveModel:Update(playback)
    if self.Length == 0 then return end

    local env = playback.Environment
    local progress = math.ease.OutQuad(playback:GetInstructionProgress(self))
    local object = env:GetNamedModel(self.Name)

    if self.LocalTransform then
        local p, a = LocalToWorld(
            LerpVector(progress, vector_origin, self.GoTo),
            LerpAngle(progress, angle_zero, self.RotateTo),
            self.Position,
            self.Angles
        )

        object:SetPos(p)
        object:SetAngles(a)
    else
        object:SetPos(self.Position + LerpVector(progress, vector_origin, self.GoTo))
        object:SetAngles(self.Angles + LerpAngle(progress, angle_zero, self.RotateTo))
    end

    object.PONDER_AlphaOverride = 1 - progress
end

function RemoveModel:Last(playback)
    local env = playback.Environment
    if self.Length ~= 0 then
        env:RemoveModelByName(self.Name)
    end
end