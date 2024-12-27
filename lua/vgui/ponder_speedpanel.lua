local SPEEDPANEL = {}

function SPEEDPANEL:Init()
    self.Buttons = {}

    self:AddSpeed("0.25", .25)
    self:AddSpeed("0.5", .5)
    self:AddSpeed("0.75", .75)
    self:AddSpeed("1", 1)
    self:AddSpeed("1.25", 1.25)
    self:AddSpeed("1.5", 1.5)
    self:AddSpeed("1.75", 1.75)
    self:AddSpeed("2", 2)
    self:AddSpeed("4", 4)

    self:SetSize(96, 26 * #self.Buttons)
end

function SPEEDPANEL:Paint() end

function SPEEDPANEL:AddSpeed(speedText, speedMult)
    local b = self:Add("DButton")
    b:SetText(speedText .. "x")
    b:SetSize(128, 20)
    b:DockMargin(2, 2, 2, 2)
    b:Dock(TOP)

    b.SpeedMod = speedMult

    local spInst = self
    function b:DoClick()
        spInst.UI.Playback.Speed = speedMult
        for _, v in ipairs(spInst.Buttons) do
            v.Active = false
        end
        self.Active = true
    end
    function b:Paint(w, h)
        local skin = self:GetSkin()

        if self.Depressed or self:IsSelected() or self:GetToggle() then
            return skin.tex.Button_Down(0, 0, w, h)
        end

        if self:GetDisabled() then
            return skin.tex.Button_Dead(0, 0, w, h)
        end

        if self.Hovered then
            return skin.tex.Button_Hovered(0, 0, w, h)
        end

        if self.Active then
            local s = (math.sin(CurTime() * 7) + 1) / 2
            local r, g, b = 190 + (65 * s), 200 + (55 * s), 255
            skin.tex.Button(0, 0, w, h, Color(r, g, b))
        else
            skin.tex.Button(0, 0, w, h)
        end
    end
    self.Buttons[#self.Buttons + 1] = b
end

function SPEEDPANEL:LinkTo(ui)
    self.UI = ui
    for _, v in ipairs(self.Buttons) do
        v.Active = v.SpeedMod == ui.Playback.Speed
    end
end

derma.DefineControl("Ponder.SpeedPanel", "Ponder speed panel", SPEEDPANEL, "DPanel")