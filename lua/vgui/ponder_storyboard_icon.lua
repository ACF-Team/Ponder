local PANEL     = {}
DEFINE_BASECLASS("Panel")

local padding = 8

function PANEL:Init()
    self.Icon = vgui.Create("ModelImage", self)
    self.Icon:SetMouseInputEnabled(false)
    self.Icon:SetKeyboardInputEnabled(false)
    self.Icon:SetPos(-5000, padding)
    self:SetSize(ScrW() - 192, 76)
    self.Icon:SetVisible(false)
end

local COLOR_Title = Color(170, 170, 170)
local COLOR_Subtitle = Color(245, 245, 245)
local GRADIENT = Material("gui/gradient")

function PANEL:SetStoryboard(storyboard)
    self.Storyboard = storyboard
    self.Icon:SetModel(storyboard.ModelIcon)
    self.StartTime = CurTime()
end

function PANEL:Paint()
    DisableClipping(true)

    surface.SetDrawColor(0, 0, 0, 255)
    surface.SetMaterial(GRADIENT)

    local size = 32

    local animTime = math.Clamp((CurTime() - self.StartTime) / 1, 0, 1)
    local animGradient = math.ease.OutCirc(animTime)
    local animXGrad = (1 - math.ease.OutQuart(animTime)) * 64

    surface.DrawTexturedRect(padding - animXGrad, padding - 12, 500 * animGradient, 48 + 32, 0)
    surface.DrawTexturedRectRotated(padding - animXGrad - (size / 2), (padding - 12) + 40, size, 80, 180)

    draw.SimpleText(language.GetPhrase("ponder.pondering_about_storyboard"), "Ponder.Title", 76 + padding - animXGrad, padding, COLOR_Title)
    draw.SimpleText(language.GetPhrase(self.Storyboard.PlaybackName or self.Storyboard.MenuName), "Ponder.Subtitle", 76 + padding - animXGrad, padding + 16 + 6, COLOR_Subtitle)

    self.Icon:SetPos(padding - animXGrad, padding)
    local pX, pY = self:LocalToScreen(0, 0)
    self.Icon:PaintAt(pX + (padding - animXGrad), pY + padding)
    DisableClipping(false)
end

function PANEL:OnRemove()

end

derma.DefineControl("Ponder.StoryboardIcon", "Ponder's storyboard icon", PANEL, "Panel")

PANEL     = {}
DEFINE_BASECLASS("Panel")

local Oxygen_Language = Material("ponder/ui/icon64/oxygen_language.png", "mips smooth")

function PANEL:Init()
    self.Title = ""
    self.Desc  = ""
    self.StartTime = CurTime()
end

local padding2 = 0
function PANEL:Paint()
    DisableClipping(true)

    surface.SetDrawColor(0, 0, 0, 255)
    surface.SetMaterial(GRADIENT)

    local size = 32

    local animTime = math.Clamp((CurTime() - self.StartTime) / 1, 0, 1)
    local animGradient = math.ease.OutCirc(animTime)
    local animXGrad = (1 - math.ease.OutQuart(animTime)) * 64

    local ySize = 40

    surface.DrawTexturedRect(padding2 - animXGrad, padding2 - 12, 500 * animGradient, ySize, 0)
    surface.DrawTexturedRectRotated(padding2 - animXGrad - (size / 2), (padding2 - 12) + (ySize / 2), size, ySize, 180)

    draw.SimpleText(self.Title, "Ponder.Text", 44 + padding2 - animXGrad, padding2 - 8, COLOR_Subtitle)
    draw.SimpleText(self.Desc,  "Ponder.Text", 44 + padding2 - animXGrad, padding2 + 8, COLOR_Subtitle)

    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(Oxygen_Language)
    surface.DrawTexturedRect(padding2 - animXGrad, padding2 - 6, 32, 32)

    DisableClipping(false)
end

function PANEL:OnRemove()

end

function PANEL:SetTranslationQuality(quality)
    local TranslationQuality = Ponder.Localization.TranslationQuality

    if quality == TranslationQuality.Unsupported then
        self.Title, self.Desc =
            "This storyboard does not support the " .. Ponder.Localization.GetCurrentLangName() .. " language.",
            "Contact the creator of the storyboard if you wish to translate this storyboard."
    elseif quality == TranslationQuality.Shaky then
        self.Title, self.Desc =
            "This storyboard supports the " .. Ponder.Localization.GetCurrentLangName() .. " language, but the translation may be shaky.",
            "Contact the creator of the storyboard if you wish to correct this storyboard's translation."
    elseif quality == TranslationQuality.MachineTranslated then
        self.Title, self.Desc =
            "This storyboard used machine learning to support the " .. Ponder.Localization.GetCurrentLangName() .. " language.",
            "Contact the creator of the storyboard if you wish to translate the storyboard more accurately."
    end
end

derma.DefineControl("Ponder.LanguageNotice", "Ponder's language quality notice message", PANEL, "Panel")