Ponder.Storyboard = Ponder.SimpleClass()

function Ponder.Storyboard:__new()
    self.Chapters = {}
    self.Length = 0
end

function Ponder.Storyboard:SetupFirstChapter(chapter)
    chapter:AddInstruction("PlaceModel", {Length = 0, Model = "models/hunter/blocks/cube150x150x025.mdl", Name = "GRID", Position = Vector(0, 0, -5.9)})
    chapter:AddInstruction("MoveCameraLookAt", {Time = 0, Length = 0, Target = vector_origin, Angle = 55, Distance = 1300, Height = 600})
end

function Ponder.Storyboard:Chapter()
    local chapter = Ponder.Chapter(self)
    self.Chapters[#self.Chapters + 1] = chapter

    if #self.Chapters == 1 then
        self:SetupFirstChapter(chapter)
    end

    return chapter
end

function Ponder.Storyboard:Recalculate()
    self.Length = 0

    for _, v in ipairs(self.Chapters) do
        v:Recalculate()
        v.StartTime = self.Length
        self.Length = self.Length + v.Length
    end

    return self
end

function Ponder.Storyboard:GenerateUUID()
    return table.concat({string.lower(string.Replace(self.AddonName, " ", "-")), string.lower(string.Replace(self.CategoryName, " ", "-")), string.lower(string.Replace(self.Name, " ", "-"))}, ".")
end

function Ponder.Storyboard:WithSpawnIcon(icon)
    self.Icon = icon
end

function Ponder.Storyboard:Preload()
    for _, chapter in ipairs(self.Chapters) do
        for _, instruction in ipairs(chapter.Instructions) do
            if instruction.Preload then
                instruction:Preload()
            end
        end
    end
end

function Ponder.Storyboard:ToString()
    return "Ponder Storyboard [" .. self:GenerateUUID() .. "]"
end