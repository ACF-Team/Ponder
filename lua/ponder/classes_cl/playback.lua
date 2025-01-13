Ponder.InstructionPlaybackState = {
    Pending   = 0,
    Running   = 1,
    Completed = 2
}

local INSTRUCTION_PLAYBACK_PENDING = Ponder.InstructionPlaybackState.Pending
local INSTRUCTION_PLAYBACK_RUNNING = Ponder.InstructionPlaybackState.Running
local INSTRUCTION_PLAYBACK_COMPLETED = Ponder.InstructionPlaybackState.Completed

Ponder.Playback = Ponder.SimpleClass()

function Ponder.Playback:__new(storyboard, environment)
    self.Storyboard     = storyboard or error("No storyboard for Playback")
    self.Environment    = environment or error("No environment for Playback")
    self.Time           = 0
    self.Speed          = 1
    self.Complete       = false
    self.Paused         = true
    self.Length         = self.Storyboard:Recalculate().Length
    self.Identifying    = false
    self.Fullbright     = false

    self.InstructionIndices          = {}
    self.PendingInstructionIndices   = {}
    self.RunningInstructionIndices   = {}
    self.CompletedInstructionIndices = {}

    self:SetChapter(1)

    for _, v in pairs(Ponder.API.RegisteredRenderers) do v:Initialize(self.Environment) end
end

----------------------------------------------------------------------------------------------------------------
-- Instruction index methods
----------------------------------------------------------------------------------------------------------------

function Ponder.Playback:ClearInstructionIndices()
    table.Empty(self.InstructionIndices)
    table.Empty(self.PendingInstructionIndices)
    table.Empty(self.RunningInstructionIndices)
    table.Empty(self.CompletedInstructionIndices)
    Ponder.DebugPrint("Playback:ClearInstructionIndices()")
end

function Ponder.Playback:InitializeInstructionIndices()
    for k, v in ipairs(self:GetChapter().Instructions) do
        self.InstructionIndices[k] = {
            Instruction = v,
            Index = k,
            State = INSTRUCTION_PLAYBACK_PENDING
        }
        self.PendingInstructionIndices[k] = true
    end

    Ponder.DebugPrint("Playback:InitializeInstructionIndices()")
end

function Ponder.Playback:GetInstructionFromIndex(instrIndex)
    return self.InstructionIndices[instrIndex].Instruction
end

function Ponder.Playback:GetInstructionIndexState(instrIndex)
    return self.InstructionIndices[instrIndex].State
end

function Ponder.Playback:SetInstructionIndexState(instrIndex, state)
    self.InstructionIndices[instrIndex].State = state
end

function Ponder.Playback:IsInstructionIndexPending(instrIndex)
    return self.InstructionIndices[instrIndex].State == INSTRUCTION_PLAYBACK_PENDING
end

function Ponder.Playback:IsInstructionIndexRunning(instrIndex)
    return self.InstructionIndices[instrIndex].State == INSTRUCTION_PLAYBACK_RUNNING
end

function Ponder.Playback:HasInstructionIndexCompleted(instrIndex)
    return self.InstructionIndices[instrIndex].State == INSTRUCTION_PLAYBACK_COMPLETED
end

function Ponder.Playback:StartInstructionIndex(instrIndex)
    local instr = self.InstructionIndices[instrIndex]
    instr.Instruction:First(self)
    instr.State = INSTRUCTION_PLAYBACK_RUNNING

    self.PendingInstructionIndices[instrIndex] = nil
    self.RunningInstructionIndices[instrIndex] = true

    Ponder.DebugPrint("Starting instruction index @ " .. instrIndex .. "[" .. instr.Instruction.__INSTRUCTION_NAME .. "]")
end

function Ponder.Playback:UpdateInstructionIndex(instrIndex)
    local instr = self.InstructionIndices[instrIndex]
    if not self:IsInstructionIndexRunning(instrIndex) then return Ponder.DebugPrint("Wtf? Instruction index not running but Update got called??") end

    instr.Instruction:Update(self)
end

function Ponder.Playback:FinalizeInstructionIndex(instrIndex)
    local instr = self.InstructionIndices[instrIndex]

    if instr.State == INSTRUCTION_PLAYBACK_PENDING then
        Ponder.DebugPrint("Finalize called on instruction that was pending, resolving...")
        instr.Instruction:First(self)
        instr.Instruction:Update(self)
    end

    instr.Instruction:Last(self)
    instr.State = INSTRUCTION_PLAYBACK_COMPLETED

    self.RunningInstructionIndices[instrIndex] = nil
    self.CompletedInstructionIndices[instrIndex] = true

    Ponder.DebugPrint("Finalizing instruction index @ " .. instrIndex .. "[" .. instr.Instruction.__INSTRUCTION_NAME .. "]")
end

function Ponder.Playback:IsInstructionIndexLengthless(instrIndex)
    return self.InstructionIndices[instrIndex].Length == 0
end

function Ponder.Playback:RunLengthlessInstructionIndex(instrIndex)
    self:StartInstructionIndex(instrIndex)
    self:UpdateInstructionIndex(instrIndex)
    self:FinalizeInstructionIndex(instrIndex)

    self.PendingInstructionIndices[instrIndex] = nil
    self.RunningInstructionIndices[instrIndex] = true
end

function Ponder.Playback:GetInstructionIndexStartTime(instrIndex)
    return self:GetChapter().StartTime + self:GetInstructionFromIndex(instrIndex).Time
end

function Ponder.Playback:GetInstructionIndexEndTime(instrIndex)
    local instr = self:GetInstructionFromIndex(instrIndex)
    return self:GetChapter().StartTime + instr.Time + (instr.Length or 0)
end

function Ponder.Playback:ShouldInstructionIndexStart(instrIndex, curtime)
    return curtime >= self:GetInstructionIndexStartTime(instrIndex)
end

function Ponder.Playback:ShouldInstructionIndexEnd(instrIndex, curtime)
    return curtime >= self:GetInstructionIndexEndTime(instrIndex)
end

----------------------------------------------------------------------------------------------------------------

function Ponder.Playback:ToString()
    return "Ponder Playback, playing " .. self.Storyboard:GenerateUUID() .. ""
end

function Ponder.Playback:ToggleFullbright()
    self.Fullbright = not self.Fullbright
    self.Environment.Fullbright = self.Fullbright
end

function Ponder.Playback:Play()
    if self.Complete then
        self.Complete = false
        self.Time = 0
        self:SeekChapter(1)
    end

    self.LastUpdate = CurTime()
    self.Paused = false

    if self.OnPlay then
        self:OnPlay()
    end

    for instrIndex in pairs(self.RunningInstructionIndices) do
        self:GetInstructionFromIndex(instrIndex):OnResumed(self)
    end
end

function Ponder.Playback:Pause()
    self.Paused = true

    if self.OnPause then
        self:OnPause()
    end

    for instrIndex in pairs(self.RunningInstructionIndices) do
        self:GetInstructionFromIndex(instrIndex):OnPaused(self)
    end
end

function Ponder.Playback:TogglePause()
    if self.Paused then self:Play() else self:Pause() end
end
function Ponder.Playback:ToggleIdentify()
    self.Identifying = not self.Identifying
    self.Environment.Identifying = self.Identifying
end

function Ponder.Playback:GetInstructionProgress(instruction)
    local curChapTime = self:GetChapter().StartTime
    return math.Clamp(math.Remap(self.Time, curChapTime + instruction.Time, curChapTime + instruction.Time + instruction.Length, 0, 1), 0, 1)
end

function Ponder.Playback:GetInstructionStartTime(instruction)
    return instruction.Chapter.StartTime + instruction.Time
end

function Ponder.Playback:SetChapter(chapterIndex)
    local oldC = self.Chapter or 1

    self.Chapter = chapterIndex
    local chapter = self.Storyboard.Chapters[chapterIndex]
    if not chapter then self.Chapter = oldC return false end

    chapter:Recalculate()
    self:InitializeInstructionIndices()
    Ponder.DebugPrint("Starting Chapter [" .. chapterIndex .. "]")

    return true
end

function Ponder.Playback:FinalizeChapter()
    -- Call all finalizers on running instructions
    for instrIndex in pairs(self.InstructionIndices) do
        if not self:HasInstructionIndexCompleted(instrIndex) then
            self:FinalizeInstructionIndex(instrIndex)
        end
    end

    self:ClearInstructionIndices()
end

function Ponder.Playback:Update()
    if self.Paused then self.DeltaTime = 0 return end

    local now        = CurTime()
    local delta      = now - self.LastUpdate
    local curChapter = self:GetChapter()

    self.DeltaTime   = delta * self.Speed
    self.Time        = math.Clamp(self.Time + (delta * self.Speed), 0, self.Length)
    self.LastUpdate  = now

    -- Check if we reached the end of the chapter
    if not curChapter then return end

    if self.Time >= curChapter:GetEndTime() then
        self:FinalizeChapter()

        if not self:SetChapter(self.Chapter + 1) then
            self.Paused = true
            self.Complete = true

            if self.OnComplete then
                self:OnComplete()
            end

            return
        else
            curChapter = self:GetChapter()
        end
    end

    local time = self.Time
    for instrIndex in ipairs(curChapter.Instructions) do
        local state = self:GetInstructionIndexState(instrIndex)
        if state == INSTRUCTION_PLAYBACK_PENDING then
            -- Determine if this instruction is coming up.
            if self:ShouldInstructionIndexStart(instrIndex, time) then
                if self:IsInstructionIndexLengthless(instrIndex) then
                    self:RunLengthlessInstructionIndex(instrIndex)
                else
                    self:StartInstructionIndex(instrIndex)
                    self:UpdateInstructionIndex(instrIndex)
                end
            end
        elseif state == INSTRUCTION_PLAYBACK_RUNNING then
            self:UpdateInstructionIndex(instrIndex)
            if self:ShouldInstructionIndexEnd(instrIndex, self.Time) then
                self:FinalizeInstructionIndex(instrIndex)
            end
        end
    end
end

function Ponder.Playback:Render3D()
    local curChapter = self:GetChapter()
    if not curChapter then return end

    for instrIndex in pairs(self.RunningInstructionIndices) do
        curChapter.Instructions[instrIndex]:Render3D(self)
    end
end

function Ponder.Playback:Render2D()
    local curChapter = self:GetChapter()
    if not curChapter then return end

    for instrIndex in pairs(self.RunningInstructionIndices) do
        curChapter.Instructions[instrIndex]:Render2D(self)
    end
end

function Ponder.Playback:GetProgress()
    return self.Time / self.Length
end

function Ponder.Playback:GetSeconds()
    return self.Time
end

function Ponder.Playback:GetChapterProgress()
    local chapter = self:GetChapter()
    if not chapter then return 0 end
    return math.Remap(self.Time, chapter.StartTime, chapter.StartTime + chapter.Length, 0, 1)
end

function Ponder.Playback:GetChapterSeconds()
    local chapter = self:GetChapter()
    if not chapter then return 0 end
    return math.Remap(self.Time, chapter.StartTime, chapter.StartTime + chapter.Length, 0, chapter.Length)
end

function Ponder.Playback:GetChapterLength()
    local chapter = self:GetChapter()
    return chapter and chapter.Length or 0
end

function Ponder.Playback:GetChapter() return self.Storyboard.Chapters[self.Chapter] end

function Ponder.Playback:DoAllInstructions(chapterIndex)
    self:SetChapter(chapterIndex)
    local chapter = self.Storyboard.Chapters[chapterIndex]
    self.Time = chapter.StartTime + chapter.Length

    for _, instruction in ipairs(chapter.Instructions) do
        instruction:First(self)
        instruction:Update(self)
        instruction:Last(self)
    end

    Ponder.DebugPrint("Playback:DoAllInstructions(" .. chapterIndex .. ")")
end

function Ponder.Playback:SeekChapter(chapterIndex)
    self.Seeking = true
    self:FinalizeChapter()
    self.Environment:Free()

    for _, v in pairs(Ponder.API.RegisteredRenderers) do v:Initialize(self.Environment) end

    for i = 1, chapterIndex - 1 do
        self:DoAllInstructions(i)
    end

    self:SetChapter(chapterIndex)
    local seekChapter = self.Storyboard.Chapters[chapterIndex]
    self.Time = seekChapter.StartTime

    for _, instruction in ipairs(seekChapter.Instructions) do
        if instruction.Time == 0 then
            instruction:First(self)
        end
    end

    self:ClearInstructionIndices()
    self:InitializeInstructionIndices()
    self.Seeking = false
end