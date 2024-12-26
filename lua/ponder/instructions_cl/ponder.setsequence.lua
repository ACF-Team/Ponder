local SetSequence = Ponder.API.NewInstruction("SetSequence")
SetSequence.Name       = ""
SetSequence.Sequence   = "idle"
SetSequence.Time       = 0
SetSequence.Speed      = 1
SetSequence.Loop       = false
SetSequence.LocalPos   = true

function SetSequence:First(playback)
    local env = playback.Environment
    local object = env:GetNamedModel(self.Name)

    self.SequenceDuration = object:SequenceDuration(object:LookupSequence(self.Sequence))
    self.Length = self.Loop and 0 or self.SequenceDuration
    object:SetSequence(self.Sequence)
    local start = CurTime()
    hook.Add("Think", object, function()
        if not IsValid(object) then return end

        local t = ((CurTime() - start) * self.Speed) / self.SequenceDuration
        object:SetCycle(t)
    end)
end

function SetSequence:Update(playback)

end