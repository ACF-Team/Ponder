local PROGRESSPANEL     = {}

local barInsidePadding = 6
local barInsidePadding2 = barInsidePadding * 2

function PROGRESSPANEL:Init()
    self:SetMouseInputEnabled(true)
end

local pointy = Material "icon32/hand_point_180.png"

function PROGRESSPANEL:Paint(w, _)
    local progress = self:GetFraction()

    local upperTall = 20
    surface.SetDrawColor(10, 15, 20, 160)
    surface.DrawRect(0, 0, w, upperTall)

    surface.SetDrawColor(10, 15, 20, 255)
    surface.DrawOutlinedRect(0, 0, w, upperTall)
    surface.SetDrawColor(139, 143, 148)
    surface.DrawOutlinedRect(1, 1, w - 2, upperTall - 2, 2)

    surface.SetDrawColor(123, 171, 230)
    surface.DrawRect(barInsidePadding, barInsidePadding, (w - barInsidePadding2) * progress, upperTall - barInsidePadding2)

    local storyboardLength = self.UI.Storyboard.Length
    local chapter_bar_outline_size = 7
    local chapter_bar_size = 3
    for i = 1, #self.UI.Storyboard.Chapters - 1 do
        local chap = self.UI.Storyboard.Chapters[i + 1]
        local ratio = chap.StartTime / storyboardLength
        surface.SetDrawColor(41, 41, 43, 150)
        surface.DrawRect(barInsidePadding + ((w - barInsidePadding2) * ratio) - (chapter_bar_outline_size / 2), barInsidePadding / 2, chapter_bar_outline_size, upperTall - barInsidePadding, COLOR_Tick)
        surface.SetDrawColor(139, 143, 148, 150)
        surface.DrawRect(barInsidePadding + ((w - barInsidePadding2) * ratio) - (chapter_bar_size / 2), barInsidePadding / 2, chapter_bar_size, upperTall - barInsidePadding, COLOR_Tick)
    end

    if self.HoveredChapter then
        local storyboard = self.UI.Storyboard
        local chapter = storyboard.Chapters[self.HoveredChapter]
        local startX = barInsidePadding + ((chapter.StartTime / storyboard.Length) * (w - barInsidePadding2))

        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawRect(startX - 1, 28, 3, 60)
        -- determine if we're going backwards or forwards
        surface.SetMaterial(pointy)
        local s = math.sin(CurTime() * 8) * 8
        if self.UI.Playback:GetSeconds() > chapter.StartTime then -- going backwards
            surface.DrawTexturedRectUV(startX + 16 + s, 32, 32, 32, 0, 0, 1, 1)
        else -- going forwards
            surface.DrawTexturedRectUV(startX - 16 + s - 32, 32, 32, 32, 1, 0, 0, 1)
        end
    end
end

function PROGRESSPANEL:Think()
    if not self.UI then return end
    if not self.UI.Storyboard then return end

    self:SetFraction(self.UI.Playback:GetProgress())

    if self:IsHovered() then
        -- Calculate where they are
        local storyboard = self.UI.Storyboard
        local mpx, _ = self:ScreenToLocal(input.GetCursorPos())
        local timeline_second = ((mpx - barInsidePadding) / (self:GetWide() - barInsidePadding2)) * storyboard.Length
        local found_chapter = nil
        for chapIndex, chapter in ipairs(storyboard.Chapters) do
            if timeline_second >= chapter.StartTime and timeline_second <= (chapter.StartTime + chapter.Length) then
                found_chapter = chapIndex
                break
            end
        end
        self.HoveredChapter = found_chapter
    else
        self.HoveredChapter = nil
    end
end

function PROGRESSPANEL:LinkTo(ui)
    self.UI = ui
end

function PROGRESSPANEL:OnMouseReleased()
    if self.HoveredChapter then
        self.UI.Playback:SeekChapter(self.HoveredChapter)
    end
end

derma.DefineControl("Ponder.Progress", "Ponder progress bar", PROGRESSPANEL, "DProgress")

local TOOLTIP = {}
AccessorFunc(TOOLTIP, "_text", "Text", FORCE_STRING)
AccessorFunc(TOOLTIP, "_font", "Font", FORCE_STRING)

function TOOLTIP:Init()
    self.Birth = RealTime()

    self:SetText("")
    self:SetFont("DermaDefault")
    self:SetDrawOnTop(true)
end

function TOOLTIP:Lifetime()
    return RealTime() - self.Birth
end

function TOOLTIP:GetTextSize()
    surface.SetFont(self:GetFont())
    return surface.GetTextSize(self:GetText())
end

function TOOLTIP:Close()
    self:Remove()
end

function TOOLTIP:Think()
    local sW, sH = self:GetTextSize()
    self:SetTall(sH + 12)
    self:SetWide((sW * self:GetAlphaMult(0.7)) + 12)

    --local pX, pY = input.GetCursorPos()
    --self:SetPos(pX - (self:GetWide() / 2), pY - 8 - sH - 6)
    local target = self.Target
    local tpx, tpy = target:LocalToScreen(0, 0)
    tpx = tpx + (target:GetWide() / 2)
    self:SetPos(tpx - (self:GetWide() / 2), tpy - 8 - sH - 6)
end

function TOOLTIP:GetAlphaMult(min)
    return math.ease.InOutQuad(math.Clamp(math.Remap(self:Lifetime(), 0, 0.1, min or 0, 1), 0, 1))
end

function TOOLTIP:Paint(w, h)
    surface.SetDrawColor(245, 245, 245, 220 * self:GetAlphaMult())
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(25, 25, 25, 255 * self:GetAlphaMult())
    surface.DrawOutlinedRect(0, 0, w, h)

    draw.SimpleText(self:GetText(), self:GetFont(), w / 2, h / 2, Color(25, 25, 25, 255 * self:GetAlphaMult()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function TOOLTIP:OpenForPanel(pnl)
    self.Target = pnl
end

derma.DefineControl("Ponder.ControlTooltip", "Control tooltip", TOOLTIP, "DPanel")


local CONTROL_BUTTON = {}
function CONTROL_BUTTON:Init()
    self:SetText("")
    self:SetTooltipPanelOverride("Ponder.ControlTooltip")
end

local padding = 0
local paddingIfHover = -4
local paddingIfDepressed = 4

function CONTROL_BUTTON:SetImage(path)
    self.Material = Material(path, "mips smooth")
end

function CONTROL_BUTTON:Paint(w, h)
    surface.SetDrawColor(10, 15, 20, 160)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(10, 15, 20, 255)
    surface.DrawOutlinedRect(0, 0, w, h)
    surface.SetDrawColor(139, 143, 148)
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2, 2)

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(self.Material)
    local finalPadding = self.Depressed and paddingIfDepressed or self.Hovered and paddingIfHover or padding
    surface.DrawTexturedRectRotated(w / 2, h / 2, 48 - finalPadding, 48 - finalPadding, 0)
end

function CONTROL_BUTTON:OnMousePressed(mousecode)
    DButton.OnMousePressed(self, mousecode)
    self.Depressed = true
end

function CONTROL_BUTTON:OnMouseReleased(mousecode)
    DButton.OnMouseReleased(self, mousecode)
    self.Depressed = false
end


derma.DefineControl("Ponder.ControlButton", "Control button", CONTROL_BUTTON, "DButton")

local PANEL     = {}

DEFINE_BASECLASS "DPanel"

function PANEL:Init()
    self.chapterProgress = self:Add "Ponder.Progress"
    self.chapterProgress:Dock(BOTTOM)
    self.chapterProgress:SetSize(0, 64)
    self.chapterProgress:SetFraction(0.75)
    self.chapterProgress:DockMargin(ScrW() / 3.5, 0, ScrW() / 3.5, 0)
    self:DockPadding(4, 4, 4, 4)

    self.Buttons = self:Add "DPanel"
    self.Buttons:Dock(BOTTOM)
    self.Buttons:SetSize(0, 64)

    -- I hate this
    function self.Buttons:PerformLayout(w, _)
        local children = self:GetChildren()
        local w2 = w / (#children + 2)
        for i = 1, #children do
            local child = children[i]
            child:SetPos((w2 * (i + 1)) - (58 / 2), (64 - 58) / 2)
        end
    end

    self.Buttons.Paint = function() end
    function self:AddButton(img, tooltip, onclick)
        local button = self.Buttons:Add "Ponder.ControlButton"

        button:SetSize(58, 58)
        button:Center()
        button:SetImage(img)
        button:SetTooltip(tooltip)
        function button:DoClick()
            onclick(self)
        end

        return button
    end

    local identify  = self:AddButton("icon16/magnifier.png", "Identify")
    local pauseplay = self:AddButton("ponder/ui/icon64/stop.png", "Play/Pause", function(btn)
        self.UI.Playback:TogglePause()
        btn:SetImage(self.UI.Playback.Paused and "ponder/ui/icon64/play.png" or "ponder/ui/icon64/stop.png")
    end)
    local replay    = self:AddButton("icon16/control_equalizer.png", "Replay")
    local time      = self:AddButton("icon16/clock_play.png", "Set Speed")

    -- Shut up linter I'm not ready yet
    identify = identify
    pauseplay = pauseplay
    replay = replay
    time = time
end

function PANEL:Paint()
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
    draw.SimpleText("        Chapter Length:    " .. self.UI.Playback:GetChapterLength() .. " seconds", "DebugFixed", 8, 8 + (y * 16), color_white); y = y + 1
end

function PANEL:LinkTo(ui)
    self.UI = ui
    self.chapterProgress:LinkTo(ui)
end

derma.DefineControl("Ponder.Controls", "Ponder storyboard controller", PANEL, "DPanel")