local PROGRESSPANEL     = {}

local COLOR_Back = Color(20, 20, 20, 255)
local COLOR_Tick = Color(129, 129, 129)
local COLOR_Progress = Color(105, 255, 155)

function PROGRESSPANEL:Paint(w, h)
    local padding = 1
    local padding2 = padding * 2

    draw.RoundedBox(8, padding, padding, w - padding2, h - padding2, COLOR_Back)
    padding = 6
    padding2 = padding * 2

    draw.RoundedBox(8, padding, padding, (w - padding2) * self:GetFraction(), h - padding2, COLOR_Progress)
    local storyboardLength = self.UI.Storyboard.Length
    for i = 1, #self.UI.Storyboard.Chapters - 1 do
        local chap = self.UI.Storyboard.Chapters[i + 1]
        local ratio = chap.StartTime / storyboardLength
        draw.RoundedBox(8, padding + ((w - padding2) * ratio) - 4, padding / 2, 9, h - padding, COLOR_Back)
        draw.RoundedBox(8, padding + ((w - padding2) * ratio) - 1, padding / 2, 3, h - padding, COLOR_Tick)
    end
end

function PROGRESSPANEL:Think()
    if not self.UI then return end
    if not self.UI.Storyboard then return end

    self:SetFraction(self.UI.Playback:GetProgress())
end

function PROGRESSPANEL:LinkTo(ui)
    self.UI = ui
end

derma.DefineControl("Ponder.Progress", "Ponder progress bar", PROGRESSPANEL, "DProgress")

local PANEL     = {}

DEFINE_BASECLASS "DPanel"

function PANEL:Init()
    self.chapterProgress = self:Add "Ponder.Progress"
    self.chapterProgress:Dock(BOTTOM)
    self.chapterProgress:SetSize(0, 24)
    self.chapterProgress:SetFraction(0.75)
    self:DockPadding(4, 4, 4, 4)
end

function PANEL:Paint(w, h)
    if not Ponder.Debug then return end
    local y = 4
    draw.SimpleText("Debugging Strings", "DebugFixed", 8, 8 + (y * 16), color_white); y = y + 2

    draw.SimpleText("    Paused:                " .. tostring(self.UI.Playback.Paused), "DebugFixed", 8, 8 + (y * 16), color_white); y = y + 1
    draw.SimpleText("    Complete:              " .. tostring(self.UI.Playback.Complete), "DebugFixed", 8, 8 + (y * 16), color_white); y = y + 1
    draw.SimpleText("    Playback Speed:        " .. self.UI.Playback.Speed .. "x", "DebugFixed", 8, 8 + (y * 16), color_white); y = y + 1
    draw.SimpleText("    Playback Time:         " .. self.UI.Playback:GetSeconds() .. " seconds", "DebugFixed", 8, 8 + (y * 16), color_white); y = y + 1
    draw.SimpleText("    Storyboard Length:     " .. self.UI.Storyboard.Length .. " seconds", "DebugFixed", 8, 8 + (y * 16), color_white); y = y + 1
    draw.SimpleText("    Current Chapter:       " .. self.UI.Playback.Chapter .. "/" .. #self.UI.Storyboard.Chapters, "DebugFixed", 8, 8 + (y * 16), color_white); y = y + 1
    draw.SimpleText("        Chapter Time:      " .. self.UI.Playback:GetChapterSeconds() .. " seconds", "DebugFixed", 8, 8 + (y * 16), color_white); y = y + 1
    draw.SimpleText("        Chapter Length:    " .. self.UI.Playback:GetChapter().Length .. " seconds", "DebugFixed", 8, 8 + (y * 16), color_white); y = y + 1
end

function PANEL:LinkTo(ui)
    self.UI = ui
    self.chapterProgress:LinkTo(ui)
end

derma.DefineControl("Ponder.Controls", "Ponder storyboard controller", PANEL, "DPanel")