Ponder.Storyboard = Ponder.SimpleClass()

local TRANSLATION_QUALITY_OK = Ponder.Localization.TranslationQuality.OK
local TRANSLATION_QUALITY_UNSUPPORTED = Ponder.Localization.TranslationQuality.Unsupported
local Oxygen_Language = Material("ponder/ui/icon64/oxygen_language.png", "mips smooth")

function Ponder.Storyboard:__new()
    self.Chapters = {}
    self.Length = 0
    self.IndexOrder = -1
    self.BaseEntityModelPath = "models/hunter/blocks/cube150x150x025.mdl"
    self.SupportedLanguages = {}

    self:MarkLanguageAsSupported("en", true, TRANSLATION_QUALITY_OK)
end

function Ponder.Storyboard:MarkLanguageAsSupported(langID, isSupported, translationQuality)
    self.SupportedLanguages[langID] = {
        Supported = isSupported == nil and true or isSupported,
        Quality = translationQuality == nil and TRANSLATION_QUALITY_OK or translationQuality
    }
end

function Ponder.Storyboard:GetCurrentLanguageQuality()
    local langID  = Ponder.Localization.GetCurrentLangID()
    local langObj = self.SupportedLanguages[langID]

    return langObj and (langObj.TranslationQuality or TRANSLATION_QUALITY_UNSUPPORTED) or TRANSLATION_QUALITY_UNSUPPORTED
end

function Ponder.Storyboard:SetupFirstChapter(chapter)
    if self.BaseEntityModelPath then
        chapter:AddInstruction("PlaceModel", {Length = 0, Model = self.BaseEntityModelPath, Name = "GRID", Position = Vector(0, 0, -5.9)})
    end

    chapter:AddInstruction("MoveCameraLookAt", {Time = 0, Length = 0, Target = vector_origin, Angle = 55, Distance = 1300, Height = 600})
end

function Ponder.Storyboard:WithMenuName(name)
    self.MenuName = name
end

function Ponder.Storyboard:WithPlaybackName(name)
    self.PlaybackName = name
end

function Ponder.Storyboard:WithName(name)
    self.MenuName = name
    self.PlaybackName = name
end

function Ponder.Storyboard:WithIndexOrder(order)
    self.IndexOrder = order
end

function Ponder.Storyboard:WithDescription(description)
    self.Description = description
end

function Ponder.Storyboard:Chapter(name)
    local chapter = Ponder.Chapter(self)
    chapter.Name = name
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

function Ponder.Storyboard:WithModelIcon(icon)
    self.ModelIcon = icon
end

function Ponder.Storyboard:WithBaseEntity(mdlpath)
    self.BaseEntityModelPath = mdlpath
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