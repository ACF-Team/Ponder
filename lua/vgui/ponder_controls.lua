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
            if not onclick then return end
            onclick(self)
        end

        return button
    end

    local identify  = self:AddButton("ponder/ui/icon64/magnifier.png", "Identify", function(btn)
        self.UI.Playback:ToggleIdentify()
        btn:SetImage(self.UI.Playback.Identifying and "ponder/ui/icon64/magnifier_enabled.png" or "ponder/ui/icon64/magnifier.png")
        btn:SetTooltip(self.UI.Playback.Identifying and "Stop Identifying" or "Identify")
    end)
    local pauseplay = self:AddButton("ponder/ui/icon64/stop.png", "Pause", function(btn)
        self.UI.Playback:TogglePause()
        btn:SetImage(self.UI.Playback.Paused and "ponder/ui/icon64/play.png" or "ponder/ui/icon64/stop.png")
        btn:SetTooltip(self.UI.Playback.Paused and "Play" or "Pause")
    end)
    local replay    = self:AddButton("ponder/ui/icon64/replay.png", "Reload from File", function()
        -- Reload storyboard
        self.UI:LoadStoryboard(self.UI.Storyboard:GenerateUUID())
        pauseplay:SetImage("ponder/ui/icon64/stop.png")
    end)
    local time      = self:AddButton("ponder/ui/icon64/fast.png", "Set Speed", function(btn)
        if IsValid(self.SpeedController) then
            self.SpeedController:Remove()
            return
        end
        local speed = self:Add "Ponder.SpeedPanel"
        local pX, pY = btn:LocalToScreen(0, 0)
        pY = (pY + (btn:GetTall() / 2)) - (speed:GetTall() / 2)
        pX, pY = self:ScreenToLocal(pX, pY)
        speed:LinkTo(self.UI)
        speed:SetPos(pX - speed:GetWide() - 0, pY)

        self.SpeedController = speed
    end)
    -- Shut up linter I'm not ready yet
    identify = identify
    pauseplay = pauseplay
    replay = replay
    time = time

    self.PlayPauseButton = pauseplay
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