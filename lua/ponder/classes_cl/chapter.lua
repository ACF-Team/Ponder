Ponder.Chapter = Ponder.SimpleClass()

function Ponder.Chapter:__new(storyboard)
    self.Storyboard = storyboard or error("No storyboard; chapter cannot be headless")
    self.Instructions = {}
    self.Time = 0
    self.Length = 0
end

function Ponder.Chapter:AddInstruction(instruction_type, instruction_params)
    -- THIS SHOULD BE REMOVED AFTER THE NEXT ACF-3 DEV BRANCH -> MASTER MERGE
    -- This is just so absolutely nothing breaks when I update Ponder on the
    -- workshop while ACF is using an outdated instruction name.
    if instruction_type == "MultiParent" then instruction_type = "Tools.MultiParent" end

    local instr = Ponder.API.RegisteredInstructions[instruction_type]
    if not instr then return Ponder.Print("No instruction " .. instruction_type) end

    if Ponder.IsTypeOf(instr, Ponder.InstructionMacro) then
        return instr:Run(self, instruction_params)
    end

    local instructionObj = instr(self)
    for k, v in pairs(instruction_params) do
        instructionObj[k] = v
    end

    self.Instructions[#self.Instructions + 1] = instructionObj
    instructionObj.Time = instructionObj.Time + self.Time

    if instructionObj.AddToTimeOffset and self.Storyboard.AutomaticTimeOffset then
        self.Time = self.Time + instructionObj.Length
    end

    if instructionObj.OnBuild then
        instructionObj:OnBuild()
    end

    return instructionObj
end

-- Delay macro
function Ponder.Chapter:AddDelay(delay)
    return self:AddInstruction("Delay", {Length = delay})
end

-- Recommend macro
function Ponder.Chapter:RecommendStoryboard(uuid)
    return self:AddInstruction("RecommendStoryboard", {Storyboard = uuid})
end

function Ponder.Chapter:Recalculate()
    --table.SortByMember(self.Instructions, "Time", true)
    local l = 0
    for _, v in ipairs(self.Instructions) do
        local testTime = v.Time + (v.Length or 0)
        if testTime > l then
            l = testTime
        end
    end

    self.Length = l
    return self
end

function Ponder.Chapter:GetStartTime() return self.StartTime end
function Ponder.Chapter:GetEndTime() return self.StartTime + self.Length end

function Ponder.Chapter:ToString()
    return "Ponder Chapter [" .. self.Storyboard:GenerateUUID() .. "]"
end