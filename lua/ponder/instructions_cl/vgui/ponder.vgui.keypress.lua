-- Shows a keycap that appears, is pressed down, held, then released and fades out.
-- AddInstruction returns the instruction, so later steps can follow the key: wait PressedAt until it is down,
-- and call ReleaseAt with the chapter's time to let go. Use several with different Positions for a combination.
local KeyPress = Ponder.API.NewInstruction("KeyPress")
KeyPress.Name      = ""
KeyPress.Key       = "" -- The text on the key, like "Shift" or "Left Click"
KeyPress.Position  = Vector(0.5, 0.27, 0) -- The key's center, as fractions of the screen
KeyPress.Hold      = 0.6 -- Seconds the key stays down
KeyPress.PressedAt = 0.3 -- Seconds from the start until the key is fully down

local Step  = 0.15 -- Each of fading in, pressing, releasing and fading out
local Depth = 6
local Font  = "DermaLarge"

function KeyPress:OnBuild()
    self.Length = self.PressedAt + self.Hold + Step * 2
end

-- Let go at this time on the chapter's clock, like chapter.Time
function KeyPress:ReleaseAt(time)
    self.Hold = math.max(time - self.Time - self.PressedAt, 0)
    self:OnBuild()
end

function KeyPress:First(playback)
    local panel = playback.Environment:NewNamedObject("VGUIPanel", self.Name, "DPanel")

    surface.SetFont(Font)
    local textW, textH = surface.GetTextSize(self.Key)
    local w, h = math.max(textW + 40, 64), textH + 20 + Depth

    panel:SetMouseInputEnabled(false)
    panel:SetSize(w, h)
    panel:SetPos(ScrW() * self.Position.x - w / 2, ScrH() * self.Position.y - h / 2)
    panel:SetAlpha(0)
    panel.Pressed = 0

    local key = self.Key
    function panel:Paint(pw, ph)
        local drop = self.Pressed * Depth
        draw.RoundedBox(8, 0, Depth, pw, ph - Depth, Color(20, 20, 20, 255))
        draw.RoundedBox(8, 0, drop, pw, ph - Depth, self.Pressed > 0.5 and Color(255, 210, 90) or Color(235, 235, 235))
        draw.SimpleText(key, Font, pw / 2, drop + (ph - Depth) / 2, Color(30, 30, 30), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function KeyPress:Update(playback)
    local time = playback:GetInstructionProgress(self) * self.Length
    local panel = playback.Environment:GetNamedObject("VGUIPanel", self.Name)
    local released = self.PressedAt + self.Hold

    panel:SetAlpha(math.Clamp(math.min(time, self.Length - time) / Step, 0, 1) * 255)
    panel.Pressed = math.Clamp((time - Step) / Step, 0, 1) - math.Clamp((time - released) / Step, 0, 1)
end

function KeyPress:Last(playback)
    playback.Environment:RemoveNamedObjectByName("VGUIPanel", self.Name)
end

--[[ Example:
    local alt = Chapter:AddInstruction("KeyPress", {Name = "alt", Key = "Alt", Position = Vector(0.465, 0.27, 0)})
    Chapter:AddDelay(alt.PressedAt)
    -- Whatever Alt changes goes here
    alt:ReleaseAt(Chapter.Time)
]]
