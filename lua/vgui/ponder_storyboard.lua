local PANEL     = {}

DEFINE_BASECLASS("Panel")

function PANEL:Init()
    self:Dock(FILL)

    local controls = self:Add("Ponder.Controls")
    controls:LinkTo(self)
    controls:SetSize(ScrW(), 384)
    controls:SetPos(0, ScrH() - 384 - 64)

    self.StoryboardIcon = self:Add("Ponder.StoryboardIcon")
    self.StoryboardIcon:SetPos(48, 48)

    self.Controls = controls

    if Ponder.Debug then
        self.Console = self:Add("RichText")
        self.Console:SetPos(128, 128)
        self.Console:SetSize(384, 512)
        hook.Add("Ponder.Print", self.Console, function(_, txt)
            self.Console:AppendText(txt .. "\n")
        end)
    end
end

function PANEL:LoadStoryboard(uuid)
    local TranslationQuality = Ponder.Localization.TranslationQuality

    if self.Environment then
        self.Environment:Free()
    end

    self.Storyboard = Ponder.API.GetStoryboard(uuid)
    self.StoryboardIcon:SetStoryboard(self.Storyboard)

    if self.StoryboardLangWarning then
        self.StoryboardLangWarning:Remove()
    end
    local langStatus = self.Storyboard:GetCurrentLanguageQuality()

    if langStatus ~= TranslationQuality.OK then
        self.StoryboardLangWarning = self:Add("Ponder.LanguageNotice")
        self.StoryboardLangWarning:SetPos(64, 140)

        self.StoryboardLangWarning:SetTranslationQuality(langStatus)
    end

    if self.Environment then
        self.Environment:Free()
    end

    self.Storyboard:Preload()

    self.Environment = Ponder.Environment()

    self.Playback = Ponder.Playback(self.Storyboard, self.Environment)

    function self.Environment.Render3D()
        self.Playback:Render3D()
    end

    function self.Environment.Render2D()
        self.Playback:Render2D()
    end

    self.Playback:Play()

    local function togglePause()
        self.Controls.PlayPauseButton:SetImage(self.Playback.Paused and "ponder/ui/icon64/play.png" or "ponder/ui/icon64/stop.png")
        self.Controls.PlayPauseButton:SetTooltip(self.Playback.Paused and language.GetPhrase("ponder.buttons.play") or language.GetPhrase("ponder.buttons.pause"))
    end

    self.Playback.OnPlay = togglePause
    self.Playback.OnPause = togglePause

    self.Playback.OnComplete = function()
        self.Playback:Pause()
    end

    self.StartTime = CurTime()
end

function PANEL:Think()
    if not self.Playback then return end
    self.Playback:Update()
end

function PANEL:Paint()
    if not self.Environment then return end
    self.Environment:Render()
end

function PANEL:OnRemove()
    -- Free all assets
    self.Environment:Free()
end

derma.DefineControl("Ponder.Storyboard", "Ponder's storyboard visualizer", PANEL, "Panel")

PANEL = {}

function PANEL:Init()
    self:SetText("")
    self.Icon = vgui.Create("ModelImage", self)
    self.Icon:SetMouseInputEnabled(false)
    self.Icon:SetKeyboardInputEnabled(false)

    self.Text = vgui.Create("DLabel", self)
    self.Text:SetFont("Ponder.Title")
end

function PANEL:SetPos(x, y)
    self.PosX = x
    self.PosY = y
    self:InvalidateLayout()
end

local p = 0
function PANEL:PerformLayout(w, h)
    self.Icon:SetPos(p + 8, p)

    self.Icon:SetSize(h - (p * 2), h - (p * 2))
    self.Text:SetTall(h)
    self.Text:SetContentAlignment(5)

    DButton.SetPos(self, self.PosX - (self:GetWide() / 2), self.PosY - (self:GetTall() / 2))
end

function PANEL:SetStoryboard(storyboardUUID)
    self.Storyboard = storyboardUUID
    self.StoryboardObject = Ponder.API.GetStoryboard(storyboardUUID)

    self.Text:SetText(self.StoryboardObject and language.GetPhrase(self.StoryboardObject.MenuName) or "No storyboard!!! Fix this!!!")
    self.Text:SetX(64 + 16)
    self.Text:SetColor(self:GetSkin().Colours.Label.Dark)
    self:InvalidateLayout(true)
    self.Text:SizeToContents()

    self.Icon:SetModel(self.StoryboardObject.ModelIcon)
    self:SizeToChildren(true, false)
    self:SetWide(self:GetWide() + 16)
end

function PANEL:DoClick()
    Ponder.Open(self.Storyboard)
end

derma.DefineControl("Ponder.OpenStoryboard", "In-storyboard opener panel", PANEL, "DButton")

--[[
if PONDER_TEMP_BUTTON then PONDER_TEMP_BUTTON:Remove() end
PONDER_TEMP_BUTTON = vgui.Create("Ponder.OpenStoryboard")
PONDER_TEMP_BUTTON:SetSize(256, 64)
PONDER_TEMP_BUTTON:SetPos(32, 32)
PONDER_TEMP_BUTTON:MakePopup()
PONDER_TEMP_BUTTON:SetStoryboard("ponder.tests.taking-a-shower")
]]