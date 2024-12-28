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
