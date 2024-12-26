Ponder.TextObject = Ponder.SimpleClass()

function Ponder.TextObject:__new()
    self.Position = Vector(0, 0, 0)
    self.Pos2D = {x = 0, y = 0}
    self.Dimension = "3D"
    self.Alpha = 255
    self.Horizontal = TEXT_ALIGN_LEFT
    self.Vertical = TEXT_ALIGN_TOP
    self.TextAlignment = TEXT_ALIGN_LEFT
end

function Ponder.TextObject:SetMarkup(markupTxt)
    self.Markup = markup.Parse(markupTxt)
end

-- Expect 3D context here
function Ponder.TextObject:ResolvePos2D()
    if self.Dimension == "2D" then
        self.Pos2D.x = self.Position[1]
        self.Pos2D.y = self.Position[2]
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
    if not self.Markup then Ponder.Print("No self.Markup!!!") return end

    local x, y, w, h = self.Pos2D.x, self.Pos2D.y, self.Markup:Size()
    local alphaFrac = self.Alpha / 255

    local textOffsetX, textOffsetY = 32, -200
    local textPadding = 6

    surface.SetDrawColor(255, 255, 255, alphaFrac * 255)
    local yUp, xRight = (y + textOffsetY) + (h / 2), (x + textOffsetX) - 16

    surface.DrawLine(x, y, x, yUp)
    surface.DrawLine(x, yUp, xRight, yUp)

    surface.SetDrawColor(20, 20, 20, alphaFrac * 170)
    surface.DrawRect(x - textPadding + textOffsetX, y - textPadding + textOffsetY, w + (textPadding * 2), h + (textPadding * 2))

    self.Markup:Draw(x + textOffsetX, y + textOffsetY, self.Horizontal, self.Vertical, self.Alpha, self.TextAlignment)
end