local SetSequence = Ponder.API.NewInstruction("SetSequence")
SetSequence.Name       = ""
SetSequence.Sequence   = "idle"
SetSequence.Time       = 0
SetSequence.Speed      = 1
SetSequence.Loop       = false

function SetSequence:First(playback)
    local env = playback.Environment
    local object = env:GetNamedModel(self.Name)
    if not IsValid(object) then return end

    self.SequenceDuration = object:SequenceDuration(object:LookupSequence(self.Sequence))
    self.Length = self.Loop and 0 or self.SequenceDuration
    object:SetSequence(self.Sequence)
    local start = playback:GetInstructionStartTime(self)
    hook.Add("Think", object, function()
        if not IsValid(object) then return end

        local t = ((playback.Time - start) * self.Speed) / self.SequenceDuration
        object:SetCycle(t)
    end)
end

function SetSequence:Update()

end