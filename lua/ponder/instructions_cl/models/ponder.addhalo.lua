local AddHalo = Ponder.API.NewInstruction("AddHalo")
AddHalo.Color    = color_white
AddHalo.BlurX    = 2
AddHalo.BlurY    = 2
AddHalo.Passes   = 1
AddHalo.Additive = true
AddHalo.IgnoreZ  = false

function AddHalo:First(playback)
    local env = playback.Environment
    local mdl = env:GetNamedModel(self.Target)
    if not IsValid(mdl) then return end

    mdl.PONDER_LAST_HALO_COLOR = mdl.PONDER_TARG_HALO_COLOR or self.Color
    mdl.PONDER_TARG_HALO_COLOR = self.Color
    mdl.PONDER_LAST_HALO_PASSES = mdl.PONDER_TARG_HALO_PASSES or 1
    mdl.PONDER_TARG_HALO_PASSES = self.Passes

    local haloData = {
        Color = mdl.PONDER_LAST_HALO_COLOR,
        BlurX = self.BlurX or 2,
        BlurY = self.BlurY or 2,
        DrawPasses = mdl.PONDER_LAST_HALO_PASSES,
        Additive = self.Additive,
        IgnoreZ = self.IgnoreZ
    }

    env.ModelHalos[mdl] = haloData
    mdl.PONDER_HALO_DATA = haloData
end

function AddHalo:Update(playback)
    local env = playback.Environment
    local progress = self.Easing and self.Easing(playback:GetInstructionProgress(self)) or playback:GetInstructionProgress(self)
    local object = env:GetNamedModel(self.Target)
    if not IsValid(object) then return end

    local haloData = object.PONDER_HALO_DATA
    if not haloData then return end

    if object.PONDER_TARG_HALO_COLOR then
        haloData.Color = object.PONDER_LAST_HALO_COLOR:Lerp(object.PONDER_TARG_HALO_COLOR, progress)
    end

    if object.PONDER_TARG_HALO_PASSES then
        haloData.DrawPasses = math.Round(Lerp(progress, object.PONDER_LAST_HALO_PASSES, object.PONDER_TARG_HALO_PASSES))
    end
end