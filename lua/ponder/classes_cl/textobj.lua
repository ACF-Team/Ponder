Ponder.TextObject = Ponder.SimpleClass()

function Ponder.TextObject:__new()
    self.Position = Vector(0, 0, 0)
    self.Pos2D = {x = 0, y = 0}
    self.Dimension = "3D"
    self.Alpha = 255
    self.Horizontal = TEXT_ALIGN_LEFT
    self.Vertical = TEXT_ALIGN_TOP
    self.TextAlignment = TEXT_ALIGN_LEFT
    self.PositionRelativeToScreen = false
end

function Ponder.TextObject:SetMarkup(markupTxt)
    self.Markup = markupTxt
    self.LastMaxWidth = nil
end

function Ponder.TextObject:GetMarkupObject()
    local maxWidth = ScrW() - self.Pos2D.x - 32

    if not self.MarkupCache or self.LastMaxWidth ~= maxWidth then
        self.MarkupCache = markup.Parse(self.Markup, maxWidth)
        self.LastMaxWidth = maxWidth
    end

    return self.MarkupCache
end

-- Expect 3D context here
function Ponder.TextObject:ResolvePos2D()
    if self.Dimension == "2D" then
        self.Pos2D.x = self.Position[1]
        self.Pos2D.y = self.Position[2]

        if self.PositionRelativeToScreen then
            self.Pos2D.x = ScrW() * self.Pos2D.x
            self.Pos2D.y = ScrH() * self.Pos2D.y
        end
    else
        local resolved
        if IsValid(self.Parent) then
            resolved = self.Parent:LocalToWorld(self.Position):ToScreen()
        else
            resolved = self.Position:ToScreen()
        end
        self.Pos2D.x = resolved.x
        self.Pos2D.y = resolved.y
    end
end

-- We expect 2D context here
function Ponder.TextObject:Render()
    local mkup = self:GetMarkupObject()

    if not mkup then Ponder.Print("No self.Markup!!!") return end

    local x, y, w, h = self.Pos2D.x, self.Pos2D.y, mkup:Size()
    local alphaFrac = self.Alpha / 255

    local textOffsetX, textOffsetY = 0, 0
    local textPadding = 6

    surface.SetDrawColor(255, 255, 255, alphaFrac * 255)
    local yUp, xRight = 0, 0
    if self.Dimension == "3D" then
        textOffsetX, textOffsetY = 32, -200
        yUp, xRight = (y + textOffsetY) + (h / 2), (x + textOffsetX) - 16
        surface.DrawLine(x, y, x, yUp)
        surface.DrawLine(x, yUp, xRight, yUp)
    end

    local rX, rY = 0, 0

    if self.Horizontal == TEXT_ALIGN_RIGHT then rX = w
    elseif self.Horizontal == TEXT_ALIGN_CENTER then rX = w / 2 end
    if self.Vertical == TEXT_ALIGN_BOTTOM then rY = h
    elseif self.Vertical == TEXT_ALIGN_CENTER then rY = h / 2 end

    surface.SetDrawColor(20, 20, 20, alphaFrac * 170)
    surface.DrawRect((x - textPadding + textOffsetX) - rX, (y - textPadding + textOffsetY) - rY , w + (textPadding * 2), h + (textPadding * 2))

    mkup:Draw(x + textOffsetX, y + textOffsetY, self.Horizontal, self.Vertical, self.Alpha, self.TextAlignment)
end