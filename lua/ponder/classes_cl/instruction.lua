Ponder.Instruction = Ponder.SimpleClass()
Ponder.Instruction.Time = 0
Ponder.Instruction.Length = 0

function Ponder.Instruction:__new(chapter, time)
    self.Chapter = chapter or error("No storyboard; Instruction cannot be headless")
    self.Time = time or 0
end

function Ponder.Instruction:ToString()
    return "Ponder Instruction [" .. self.Chapter.Storyboard:GenerateUUID() .. "]"
end

-- playback = playback so the linter shuts up...

function Ponder.Instruction:First(playback)     playback = playback end
function Ponder.Instruction:Last(playback)      playback = playback end
function Ponder.Instruction:Update(playback)    playback = playback end
function Ponder.Instruction:Render3D(playback)  playback = playback end
function Ponder.Instruction:Render2D(playback)  playback = playback end

function Ponder.Instruction:OnPaused(playback)  playback = playback end
function Ponder.Instruction:OnResumed(playback) playback = playback end

function Ponder.Instruction:DelayByLength() self.Chapter:AddDelay(self.Length) return self end