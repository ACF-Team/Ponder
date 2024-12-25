Ponder.Instruction = Ponder.SimpleClass()

function Ponder.Instruction:__new(chapter, time)
    self.Chapter = chapter or error("No storyboard; Instruction cannot be headless")
    self.Time = time or 0
end

function Ponder.Instruction:ToString()
    return "Ponder Instruction [" .. self.Chapter.Storyboard:GenerateUUID() .. "]"
end

function Ponder.Instruction:First(playback)  end
function Ponder.Instruction:Last(playback)   end
function Ponder.Instruction:Render(playback) end