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
    env:NewModel(self.Model, self.Name)
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