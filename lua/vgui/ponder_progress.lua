local PROGRESSPANEL     = {}

local barInsidePadding = 8
local barInsidePadding2 = barInsidePadding * 2

function PROGRESSPANEL:Init()
    self:SetMouseInputEnabled(true)
end

local pointy   = Material("icon32/hand_point_180.png", "mips smooth")
local bar      = Material("ponder/ui/progress/bar.png", "mips smooth")
local stretchy = Material("ponder/ui/progress/stretchy.png", "mips smooth")
local grabby   = Material("ponder/ui/progress/grabby.png", "mips smooth")
local left     = Material("ponder/ui/progress/left.png", "mips smooth")
local right    = Material("ponder/ui/progress/right.png", "mips smooth")

function PROGRESSPANEL:Paint(w, _)
    local progress = self:GetFraction()
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(left); surface.DrawTexturedRect(0, 0, 3, 24)
    surface.SetMaterial(stretchy); surface.DrawTexturedRect(3, 0, w - 6, 24)
    surface.SetMaterial(right); surface.DrawTexturedRect(w - 3, 0, 3, 24)

    local storyboardLength = self.UI.Storyboard.Length

    local upperTall = 24

    local storyboardLength = self.UI.Storyboard.Length
    local chapter_bar_outline_size = 3

    for i = 1, #self.UI.Storyboard.Chapters do
        local chap = self.UI.Storyboard.Chapters[i]
        local ratio = chap.StartTime / storyboardLength
        surface.SetDrawColor(71, 71, 79, 150)
        surface.DrawRect(barInsidePadding + ((w - barInsidePadding2) * ratio) - (chapter_bar_outline_size / 2), barInsidePadding / 2, chapter_bar_outline_size, upperTall - barInsidePadding)
    end
    surface.SetDrawColor(255, 255, 255, 255)

    draw.NoTexture(); surface.SetDrawColor(30, 30, 30, 60); surface.DrawRect(1 + barInsidePadding, 6, w - barInsidePadding2 - 1, 12)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(bar); surface.DrawTexturedRect(2 + barInsidePadding, 7, (w - barInsidePadding2 - 2) * progress, 10)
    surface.SetMaterial(grabby); surface.DrawTexturedRect(3 + barInsidePadding + ((w - barInsidePadding2 - 6) * progress) - 7, 0, 14, 24)

    if self.HoveredChapter then
        local storyboard = self.UI.Storyboard
        local chapter = storyboard.Chapters[self.HoveredChapter]
        local startX = barInsidePadding + ((chapter.StartTime / storyboard.Length) * (w - barInsidePadding2))

        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawRect(startX - 0, 24, 1, 60)
        surface.SetDrawColor(255, 255, 255, 55)
        surface.DrawRect(startX - 1, 24, 3, 60)
        surface.SetDrawColor(255, 255, 255, 255)
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
        if self.UI.Playback.Complete then
            self.UI.Playback:Play()
        end

        self.UI.Playback:SeekChapter(self.HoveredChapter)
    end
end

derma.DefineControl("Ponder.Progress", "Ponder progress bar", PROGRESSPANEL, "DProgress")