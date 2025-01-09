local PANEL     = {}

DEFINE_BASECLASS("DPanel")

function PANEL:Init()
    local padding = 0.2
    self.chapterProgress = self:Add("Ponder.Progress")
    self.chapterProgress:Dock(BOTTOM)
    self.chapterProgress:SetSize(0, 64)
    self.chapterProgress:SetFraction(0.75)
    self.chapterProgress:DockMargin(ScrW() * padding, 0, ScrW() * padding, 0)
    self:DockPadding(4, 4, 4, 4)

    self.Buttons = self:Add("DPanel")
    self.Buttons:Dock(BOTTOM)
    self.Buttons:SetSize(0, 64)

    -- I hate this
    function self.Buttons:PerformLayout(w, h)
        local children = self:GetChildren()
        local padding = 0.2
        for i = 1, #children do
            local child = children[i]
            local csW, csH = child:GetSize()

            local px = (math.Remap(i, 1, #children, padding, 1 - padding) * w) - (csW / 2)
            local py = (h / 2) + (csH / -2)

            child:SetPos(px, py)
        end
    end

    self.Buttons.Paint = function() end
    function self:AddButton(img, tooltip, onclick)
        local button = self.Buttons:Add("Ponder.ControlButton")

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

    self:AddButton("ponder/ui/icon64/brightness_off.png", language.GetPhrase("ponder.buttons.fullbright_on"), function(btn)
        self.UI.Playback:ToggleFullbright()
        btn:SetImage(self.UI.Playback.Fullbright and "ponder/ui/icon64/brightness_on.png" or "ponder/ui/icon64/brightness_off.png")
        btn:SetTooltip(self.UI.Playback.Fullbright and language.GetPhrase("ponder.buttons.fullbright_off") or language.GetPhrase("ponder.buttons.fullbright_on"))
    end)
    self:AddButton("ponder/ui/icon64/magnifier.png", language.GetPhrase("ponder.buttons.identify_on"), function(btn)
        self.UI.Playback:ToggleIdentify()
        btn:SetImage(self.UI.Playback.Identifying and "ponder/ui/icon64/magnifier_enabled.png" or "ponder/ui/icon64/magnifier.png")
        btn:SetTooltip(self.UI.Playback.Identifying and language.GetPhrase("ponder.buttons.identify_off") or language.GetPhrase("ponder.buttons.identify_on"))
    end)
    self.PlayPauseButton = self:AddButton("ponder/ui/icon64/stop.png", language.GetPhrase("ponder.buttons.pause"), function()
        self.UI.Playback:TogglePause()
    end)
    self:AddButton("ponder/ui/icon64/replay.png", language.GetPhrase("ponder.buttons.reload"), function()
        -- Reload storyboard
        self.UI:LoadStoryboard(self.UI.Storyboard:GenerateUUID())
        self.PlayPauseButton:SetImage("ponder/ui/icon64/stop.png")
    end)
    self:AddButton("ponder/ui/icon64/fast.png", language.GetPhrase("ponder.buttons.speed"), function(btn)
        if IsValid(self.SpeedController) then
            self.SpeedController:Remove()
            return
        end
        local speed = self:Add("Ponder.SpeedPanel")
        local pX, pY = btn:LocalToScreen(0, 0)
        pY = (pY + (btn:GetTall() / 2)) - (speed:GetTall() / 2)
        pX, pY = self:ScreenToLocal(pX, pY)
        speed:LinkTo(self.UI)
        speed:SetPos(pX - speed:GetWide() - 0, pY)

        self.SpeedController = speed
    end)
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