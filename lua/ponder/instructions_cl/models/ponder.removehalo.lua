local RemoveHalo = Ponder.API.NewInstruction("RemoveHalo")

function RemoveHalo:First(playback)
    local env = playback.Environment
    local object = env:GetNamedModel(self.Target)
    if not IsValid(object) then return end

    local halos = env.ModelHalos
    local haloData = object.PONDER_HALO_DATA
    if not halos[object] or not haloData then return end

    object.PONDER_LAST_HALO_PASSES = object.PONDER_TARG_HALO_PASSES
    object.PONDER_TARG_HALO_PASSES = 1
    env.HalosToRemove[object] = haloData
end

function RemoveHalo:Update(playback)
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

function RemoveHalo:Last(playback)
    local env = playback.Environment
    local object = env:GetNamedModel(self.Target)
    if not IsValid(object) then return end

    object.PONDER_HALO_DATA = nil
end