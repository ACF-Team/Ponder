local PANEL     = {}
DEFINE_BASECLASS("DButton")

local Oxygen_Language = Material("ponder/ui/icon64/oxygen_language.png", "mips smooth")
local GRADIENT        = Material("gui/gradient")
local COLOR_Text      = Color(245, 245, 245)

function PANEL:Init()
    self.Title = ""
    self.Desc  = ""
    self.StartTime = CurTime() + 0.1
    self:SetSize(500, 40)
    self:SetText("")
end

function PANEL:Paint(_, h)
    local animTime = math.Clamp((CurTime() - self.StartTime) / 1, 0, 1)
    if animTime == 0 then return end

    local padding2 = h / 3
    DisableClipping(true)

    local hM = (self.Hovered and not self:GetDisabled()) and 1 or 0
    local hr, hg, hb = 66 * hM, 76 * hM, 90 * hM
    surface.SetDrawColor(hr, hg, hb, 255)
    surface.SetMaterial(GRADIENT)

    local size = 32

    local animGradient = math.ease.OutCirc(animTime)
    local animXGrad = (1 - math.ease.OutQuart(animTime)) * 64

    local ySize = 40

    surface.DrawTexturedRect(padding2 - animXGrad, padding2 - 12, 500 * animGradient, ySize, 0)
    surface.DrawTexturedRectRotated(padding2 - animXGrad - (size / 2), (padding2 - 12) + (ySize / 2), size, ySize, 180)

    COLOR_Text:SetUnpacked(245, 245, 245, animGradient * 255)
    draw.SimpleText(self.Title, "Ponder.TitleText", 44 + padding2 - animXGrad, padding2 - 8, COLOR_Text)
    draw.SimpleText(self.Desc,  "Ponder.DescText", 44 + padding2 - animXGrad, padding2 + 8, COLOR_Text)

    surface.SetDrawColor(255, 255, 255, animGradient * 255)
    surface.SetMaterial(Oxygen_Language)
    surface.DrawTexturedRect(padding2 - animXGrad, padding2 - 6, 32, 32)

    DisableClipping(false)
end

function PANEL:OnRemove()

end

function PANEL:SetContactInfo(contactName, contactURL)
    self.ContactName = contactName
    self.ContactURL  = contactURL
end

function PANEL:InitializeOverallPonderNotice()
    self.StartTime = CurTime()

    local quality = Ponder.Localization:GetCurrentLanguageTranslationQuality()
    local TranslationQuality = Ponder.Localization.TranslationQuality
    self.Quality = quality
    self.ContactURL = "https://github.com/ACF-Team/Ponder"

    if quality == TranslationQuality.Unsupported then
        self.Title, self.Desc =
            "Ponder does not support the " .. Ponder.Localization.GetCurrentLangName() .. " language.",
            "Contact us if you wish to translate Ponder to this language. Clicking this notice will redirect you to our GitHub."
    elseif quality == TranslationQuality.Shaky then
        self.Title, self.Desc =
            "Ponder supports the " .. Ponder.Localization.GetCurrentLangName() .. " language, but the translation may be shaky.",
            "Contact us if you wish to correct this translation. Clicking this notice will redirect you to our GitHub."
    elseif quality == TranslationQuality.MachineTranslated then
        self.Title, self.Desc =
            "Ponder is using machine-learning translation for the " .. Ponder.Localization.GetCurrentLangName() .. " language.",
            "Contact us if you wish to human translate Ponder into this language. Clicking this notice will redirect you to our GitHub."
    end

    function self:DoClick()
        gui.OpenURL(self.ContactURL)
    end
    self:SetCursor("hand")

    function self:Think()
        self:MoveToFront()
    end
end

function PANEL:SetTranslationQuality(quality)
    self.Quality = quality
    local TranslationQuality = Ponder.Localization.TranslationQuality

    local contactPart = self.ContactName and (self.ContactName .. " ") or "the creator of the storyboard "
    local clickWorks  = self.ContactURL and " (Click for Contact URL)" or "."

    if quality == TranslationQuality.Unsupported then
        self.Title, self.Desc =
            "This storyboard does not support the " .. Ponder.Localization.GetCurrentLangName() .. " language.",
            "Contact " .. contactPart .. "if you wish to translate this storyboard" .. clickWorks
    elseif quality == TranslationQuality.Shaky then
        self.Title, self.Desc =
            "This storyboard supports the " .. Ponder.Localization.GetCurrentLangName() .. " language, but the translation may be shaky.",
            "Contact " .. contactPart .. "if you wish to correct this storyboard's translation" .. clickWorks
    elseif quality == TranslationQuality.MachineTranslated then
        self.Title, self.Desc =
            "This storyboard used machine learning to support the " .. Ponder.Localization.GetCurrentLangName() .. " language.",
            "Contact " .. contactPart .. "if you wish to translate the storyboard more accurately" .. clickWorks
    end

    if self.ContactURL then
        function self:DoClick()
            gui.OpenURL(self.ContactURL)
        end
        self:SetCursor("hand")
    else
        self:SetDisabled(true)
        self:SetCursor("no")
    end
end

derma.DefineControl("Ponder.LanguageNotice", "Ponder's language quality notice message", PANEL, "DButton")