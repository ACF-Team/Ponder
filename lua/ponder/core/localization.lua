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
    Supported = 0,
    -- Human translated, shaky quality
    Shaky = 50,
    -- Machine translated placeholder, shaky/poor quality, should be replaced with human translation
    MachineTranslated = 100,
}

local TranslationQuality = Ponder.Localization.TranslationQuality
local __LangIDToLanguageName = Ponder.Localization.__LangIDToLanguageName
local LanguageCvar = GetConVar("gmod_language")

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
    if not lang then return Ponder.Localization.GetCurrentLanguageTranslationQuality() end

    local langObj = Ponder.Localization.SupportedLanguages[lang]
    if not langObj then return TranslationQuality.Unsupported end

    return langObj.TranslationQuality
end

function Ponder.Localization.GetCurrentLangID()
    local ret = LanguageCvar:GetString()
    return ret == "" and "en" or (ret or "en") -- Is this even needed??
end

function Ponder.Localization.GetCurrentLanguageTranslationQuality()
    local langObj = Ponder.Localization.SupportedLanguages[LanguageCvar:GetString()]
    if not langObj then return TranslationQuality.Unsupported end

    return langObj.TranslationQuality
end

Ponder.Localization.MarkLanguageAsSupported("en",    TranslationQuality.Supported)
Ponder.Localization.MarkLanguageAsSupported("fr",    TranslationQuality.Supported)
Ponder.Localization.MarkLanguageAsSupported("en-PT", TranslationQuality.Supported)
Ponder.Localization.MarkLanguageAsSupported("es-ES", TranslationQuality.Supported)
Ponder.Localization.MarkLanguageAsSupported("hr",    TranslationQuality.Supported)
Ponder.Localization.MarkLanguageAsSupported("cs",    TranslationQuality.Supported)
Ponder.Localization.MarkLanguageAsSupported("pl",    TranslationQuality.Supported)
Ponder.Localization.MarkLanguageAsSupported("sk",    TranslationQuality.Supported)
Ponder.Localization.MarkLanguageAsSupported("ru",    TranslationQuality.Supported)