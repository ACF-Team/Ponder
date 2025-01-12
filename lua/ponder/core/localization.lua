if SERVER then return end

Ponder.Localization = {
    SupportedLanguages = {},
    __LangIDToLanguageName = {
        ["bg"]    = "Bulgarian",
        ["cs"]    = "Czech",
        ["da"]    = "Danish",
        ["de"]    = "German",
        ["el"]    = "Greek",
        ["en"]    = "English",
        ["en-PT"] = "Pirate English",
        ["es-ES"] = "Spanish",
        ["et"]    = "Estonian",
        ["fi"]    = "Finnish",
        ["fr"]    = "French",
        ["he"]    = "Hebrew",
        ["hr"]    = "Croatian",
        ["hu"]    = "Hungarian",
        ["it"]    = "Italian",
        ["ja"]    = "Japanese",
        ["ko"]    = "Korean",
        ["lt"]    = "Lithuanian",
        ["nl"]    = "Dutch",
        ["no"]    = "Norwegian",
        ["pl"]    = "Polish",
        ["pt-BR"] = "Portuguese (Brazil)",
        ["pt-PT"] = "Portuguese (Portugal)",
        ["ru"]    = "Russian",
        ["sk"]    = "Slovak",
        ["sv-SE"] = "Swedish",
        ["th"]    = "Thai",
        ["tr"]    = "Turkish",
        ["uk"]    = "Ukrainian",
        ["vi"]    = "Vietnamese",
        ["zh-CN"] = "Chinese Simplified",
        ["zh-TW"] = "Chinese Traditional"
    }
}

Ponder.Localization.TranslationQuality = {
    -- Default value.
    Unsupported = -1,
    -- Human translated, good quality
    Good = 0,
    -- Human translated, shaky quality
    Shaky = 50,
    -- Machine translated placeholder, shaky/poor quality, should be replaced with human translation
    MachineTranslated = 100,
}

local TranslationQuality = Ponder.Localization.TranslationQuality
local __LangIDToLanguageName = Ponder.Localization.__LangIDToLanguageName

function Ponder.Localization.LangIDToLanguageName(langID)
    return __LangIDToLanguageName[langID]
end

function Ponder.Localization.GetCurrentLangName()
    local id = Ponder.Localization.GetCurrentLangID()
    return __LangIDToLanguageName[id]
end

function Ponder.Localization.MarkLanguageAsSupported(lang, translationQuality)
    Ponder.Localization.SupportedLanguages[lang] = {
        TranslationQuality = translationQuality
    }
end

function Ponder.Localization.GetLanguageTranslationQuality(lang)
    local langObj = Ponder.Localization.SupportedLanguages[lang]
    if not langObj then return TranslationQuality.Unsupported end

    return langObj.TranslationQuality
end

function Ponder.Localization.GetCurrentLangID()
    local ret = GetConVar("gmod_language"):GetString()
    return ret == "" and "en" or (ret or "en") -- Is this even needed??
end

function Ponder.Localization.GetCurrentLanguageTranslationQuality()
    local langObj = Ponder.Localization.SupportedLanguages[GetConVar("gmod_language"):GetString()]
    if not langObj then return TranslationQuality.Unsupported end

    return langObj.TranslationQuality
end

Ponder.Localization.MarkLanguageAsSupported("en",    TranslationQuality.Good)
Ponder.Localization.MarkLanguageAsSupported("en-PT", TranslationQuality.Good)
Ponder.Localization.MarkLanguageAsSupported("es-ES", TranslationQuality.Good)
Ponder.Localization.MarkLanguageAsSupported("hr",    TranslationQuality.Good)
Ponder.Localization.MarkLanguageAsSupported("cs",    TranslationQuality.Good)
Ponder.Localization.MarkLanguageAsSupported("pl",    TranslationQuality.Good)
Ponder.Localization.MarkLanguageAsSupported("sk",    TranslationQuality.Good)
Ponder.Localization.MarkLanguageAsSupported("ru",    TranslationQuality.Good)