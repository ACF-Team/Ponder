Ponder.Localization = {
    HumanTranslated = {}
}

function Ponder.Localization.MarkLanguageAsHumanTranslated(lang, isHumanTranslated)
    Ponder.Localization.HumanTranslated[lang] = isHumanTranslated
end

function Ponder.Localization.IsLanguageHumanTranslated(lang)
    return Ponder.Localization.HumanTranslated[lang]
end

function Ponder.Localization.IsCurrentLanguageHumanTranslated()
    return Ponder.Localization.HumanTranslated[GetConVar("gmod_language"):GetString()]
end

Ponder.Localization.MarkLanguageAsHumanTranslated("en", true)
Ponder.Localization.MarkLanguageAsHumanTranslated("es-ES", true)