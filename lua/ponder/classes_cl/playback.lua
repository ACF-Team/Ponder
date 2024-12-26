Ponder.Playback = Ponder.SimpleClass()
Ponder.Playback.TICKS_PER_SECOND = 60

function Ponder.Playback:__new(storyboard, environment)
    self.Storyboard     = storyboard or error("No storyboard for Playback")
    self.Environment    = environment or error("No environment for Playback")
    self.Time           = 0
    self.Speed          = 1
    self.Complete       = false
    self.Paused         = true
    self.Length         = self.Storyboard:Recalculate().Length

    self.CompletedInstructionIndices = {}
    self.RunningInstructionIndices = {}
    self:SetChapter(1)
end

function Ponder.Playback:ToString()
    return "Ponder Playback, playing " .. self.Storyboard:GenerateUUID() .. ""
end

function Ponder.Playback:Play()
    if self.Complete then
        self.Complete = false
        self.Time = 0
    end
    self.LastUpdate = CurTime()
    self.Paused = false
end

function Ponder.Playback:Pause()
    self.Paused = true
end

function Ponder.Playback:GetInstructionProgress(instruction)
    local curChapTime = self:GetChapter().StartTime
    return math.Clamp(math.Remap(self.Time, curChapTime + instruction.Time, curChapTime + instruction.Time + instruction.Length, 0, 1), 0, 1)
end

function Ponder.Playback:SetChapter(chapterIndex)
    local oldC = self.Chapter or 1

    self.Chapter = chapterIndex
    local chapter = self.Storyboard.Chapters[chapterIndex]
    if not chapter then self.Chapter = oldC return false end

    chapter:Recalculate()
    return true
end

function Ponder.Playback:Update()
    if self.Paused then return end

    local now = CurTime()
    local delta = now - self.LastUpdate
    self.Time = math.Clamp(self.Time + (delta * self.Speed), 0, self.Length)
    self.LastUpdate = now
    self.Frame = self:CurFrame()

    -- Check if we reached the end of the chapter
    local curChapter = self:GetChapter()
    if not curChapter then return end

    if self.Time >= curChapter:GetEndTime() then
        -- Call all finalizers on running instructions
        for instrIndex in pairs(self.RunningInstructionIndices) do
            local instruction = self:GetChapter().Instructions[instrIndex]

            instruction:Update(self)
            instruction:Last(self)
        end

        table.Empty(self.RunningInstructionIndices)
        table.Empty(self.CompletedInstructionIndices)

        if not self:SetChapter(self.Chapter + 1) then
            self.Paused = true
            self.Complete = true
            return
        else
            curChapter = self:GetChapter()
        end
    end

    -- Find deltas
    local additions, removals = {}, {}
    local starttime = curChapter.StartTime
    for instrIndex in pairs(self.RunningInstructionIndices) do
        local instruction = curChapter.Instructions[instrIndex]
        local globalEndTime = starttime + instruction.Time + (instruction.Length or 0)
        if self.Time >= globalEndTime then
            instruction:Update(self)
            instruction:Last(self)
            removals[#removals + 1] = instrIndex
        end
    end

    for instrIndex, instruction in ipairs(curChapter.Instructions) do
        local globalStartTime = starttime + instruction.Time
        if self.Time >= globalStartTime and not self.RunningInstructionIndices[instrIndex] and not self.CompletedInstructionIndices[instrIndex] then
            instruction:First(self)
            additions[#additions + 1] = instrIndex
        end
    end

    for _, removal in ipairs(removals) do self.RunningInstructionIndices[removal] = nil; self.CompletedInstructionIndices[removal] = true end
    for _, addition in ipairs(additions) do self.RunningInstructionIndices[addition] = true end

    for instrIndex in pairs(self.RunningInstructionIndices) do
        curChapter.Instructions[instrIndex]:Update(self)
    end
end

function Ponder.Playback:Render3D()
    for instrIndex in pairs(self.RunningInstructionIndices) do
        curChapter.Instructions[instrIndex]:Render3D(self)
    end
end
function Ponder.Playback:Render2()
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

function Ponder.Playback:CurFrame() return math.floor(self.Time * Ponder.Playback.TICKS_PER_SECOND) end