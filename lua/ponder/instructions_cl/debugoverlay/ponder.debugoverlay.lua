-- Ponder equivalents of the debugoverlay library: https://wiki.facepunch.com/gmod/debugoverlay
-- Shapes live until removed (RemoveDebugOverlay), or until their optional Lifetime
-- (in seconds) runs out. Every instruction takes a Name.
local colorDefault = Color(255, 255, 255, 255)

local DebugOverlayObject = Ponder.API.NewNamedObjectType("DebugOverlay")

-- The environment expects named objects to answer IsValid and Remove, like panels do
function DebugOverlayObject.Initialize(_, _, shape)
    shape.IsValid = function() return true end
    shape.Remove  = function() end
    return shape
end

local function CornersOf(mins, maxs)
    return {
        Vector(mins.x, mins.y, mins.z), Vector(maxs.x, mins.y, mins.z),
        Vector(maxs.x, maxs.y, mins.z), Vector(mins.x, maxs.y, mins.z),
        Vector(mins.x, mins.y, maxs.z), Vector(maxs.x, mins.y, maxs.z),
        Vector(maxs.x, maxs.y, maxs.z), Vector(mins.x, maxs.y, maxs.z),
    }
end

local boxEdges = {{1, 2}, {2, 3}, {3, 4}, {4, 1}, {5, 6}, {6, 7}, {7, 8}, {8, 5}, {1, 5}, {2, 6}, {3, 7}, {4, 8}}

local function DrawWireBoxAngled(origin, mins, maxs, ang, color)
    local pts = CornersOf(mins, maxs)
    for i, p in ipairs(pts) do pts[i] = LocalToWorld(p, angle_zero, origin, ang) end
    for _, e in ipairs(boxEdges) do render.DrawLine(pts[e[1]], pts[e[2]], color, false) end
end

local function WithColor(c, a) return Color(c.r, c.g, c.b, a) end

-- Shape kinds register here from DefineShape: Draw3D runs inside the 3D camera, Draw2D after it.
local Kinds = {}

local function Visible(s) return not s.Expires or CurTime() < s.Expires end

local DebugRenderer = Ponder.API.NewRenderer("DebugOverlayRenderer")

function DebugRenderer:Render3D(env)
    for _, s in ipairs(env:GetAllNamedObjects("DebugOverlay")) do
        local draw = Kinds[s.Kind].Draw3D
        if draw and Visible(s) then draw(s) end
    end
end

function DebugRenderer:Render2D(env)
    for _, s in ipairs(env:GetAllNamedObjects("DebugOverlay")) do
        local draw = Kinds[s.Kind].Draw2D
        if draw and Visible(s) then draw(s) end
    end
end

local function DrawLabel(s, x, y)
    draw.SimpleTextOutlined(s.Text, s.Font, x, y, s.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, s.Color.a))
end

-- Registers an instruction that places one debug shape, along with how that shape is drawn.
-- `defaults` are the instruction's fields; `drawers` is {Draw3D = fn(shape), Draw2D = fn(shape)}.
local function DefineShape(instructionName, kind, defaults, drawers)
    Kinds[kind] = drawers

    local instr = Ponder.API.NewInstruction(instructionName)
    instr.Length   = 0
    instr.Name     = ""
    instr.Color    = colorDefault
    instr.IgnoreZ  = false
    instr.Lifetime = nil -- seconds; nil = until removed

    for k, v in pairs(defaults) do instr[k] = v end

    function instr:First(playback)
        local shape = {Kind = kind}
        for k in pairs(defaults) do shape[k] = self[k] end
        shape.Color   = self.Color
        shape.IgnoreZ = self.IgnoreZ
        if self.Lifetime then shape.Expires = CurTime() + self.Lifetime end
        playback.Environment:NewNamedObject("DebugOverlay", self.Name, shape)
    end

    return instr
end

DefineShape("DebugAxis", "Axis", {Position = vector_origin, Angles = angle_zero, Size = 16}, {
    Draw3D = function(s)
        local o, a, sz = s.Position, s.Angles, s.Size
        render.DrawLine(o, o + a:Forward() * sz, Color(255, 0, 0, s.Color.a), s.IgnoreZ)
        render.DrawLine(o, o - a:Right() * sz,   Color(0, 255, 0, s.Color.a), s.IgnoreZ)
        render.DrawLine(o, o + a:Up() * sz,      Color(0, 0, 255, s.Color.a), s.IgnoreZ)
    end,
})

DefineShape("DebugBox", "Box", {Position = vector_origin, Angles = angle_zero, Mins = Vector(-8, -8, -8), Maxs = Vector(8, 8, 8), Filled = false}, {
    Draw3D = function(s)
        render.SetColorMaterial()
        if s.Color.a < 255 or s.Filled then
            render.DrawBox(s.Position, s.Angles, s.Mins, s.Maxs, s.Color)
        end
        DrawWireBoxAngled(s.Position, s.Mins, s.Maxs, s.Angles, WithColor(s.Color, 255))
    end,
})

DefineShape("DebugCross", "Cross", {Position = vector_origin, Size = 8}, {
    Draw3D = function(s)
        local o, h = s.Position, s.Size / 2
        render.DrawLine(o - Vector(h, 0, 0), o + Vector(h, 0, 0), s.Color, s.IgnoreZ)
        render.DrawLine(o - Vector(0, h, 0), o + Vector(0, h, 0), s.Color, s.IgnoreZ)
        render.DrawLine(o - Vector(0, 0, h), o + Vector(0, 0, h), s.Color, s.IgnoreZ)
    end,
})

DefineShape("DebugGrid", "Grid", {Position = vector_origin, Count = 4, Spacing = 16}, {
    Draw3D = function(s)
        local o, c = s.Position, s.Color
        local n, step = s.Count, s.Spacing
        for i = -n, n do
            render.DrawLine(o + Vector(i * step, -n * step, 0), o + Vector(i * step, n * step, 0), c, s.IgnoreZ)
            render.DrawLine(o + Vector(-n * step, i * step, 0), o + Vector(n * step, i * step, 0), c, s.IgnoreZ)
        end
    end,
})

DefineShape("DebugLine", "Line", {Start = vector_origin, End = Vector(0, 0, 32)}, {
    Draw3D = function(s) render.DrawLine(s.Start, s.End, s.Color, s.IgnoreZ) end,
})

DefineShape("DebugSphere", "Sphere", {Position = vector_origin, Radius = 16}, {
    Draw3D = function(s)
        render.SetColorMaterial()
        if s.Color.a < 255 then
            render.DrawSphere(s.Position, s.Radius, 16, 16, s.Color)
        end
        render.DrawWireframeSphere(s.Position, s.Radius, 12, 12, WithColor(s.Color, 255), s.IgnoreZ)
    end,
})

DefineShape("DebugSweptBox", "SweptBox", {Start = vector_origin, End = Vector(0, 0, 32), Angles = angle_zero, Mins = Vector(-8, -8, -8), Maxs = Vector(8, 8, 8)}, {
    Draw3D = function(s)
        DrawWireBoxAngled(s.Start, s.Mins, s.Maxs, s.Angles, s.Color)
        DrawWireBoxAngled(s.End,   s.Mins, s.Maxs, s.Angles, s.Color)
        render.DrawLine(s.Start, s.End, s.Color, s.IgnoreZ)
    end,
})

DefineShape("DebugTriangle", "Triangle", {P1 = vector_origin, P2 = Vector(16, 0, 0), P3 = Vector(0, 16, 0)}, {
    Draw3D = function(s)
        render.SetColorMaterial()
        cam.IgnoreZ(s.IgnoreZ)
        render.DrawQuad(s.P1, s.P2, s.P3, s.P3, s.Color)
        render.DrawQuad(s.P3, s.P2, s.P1, s.P1, s.Color)
        cam.IgnoreZ(false)
    end,
})

DefineShape("DebugText", "Text", {Position = vector_origin, Text = "", Font = "DermaDefault"}, {
    -- ToScreen only works inside the 3D camera, so resolve it there and draw in 2D
    Draw3D = function(s) s.Screen = s.Position:ToScreen() end,
    Draw2D = function(s)
        if s.Screen and s.Screen.visible then DrawLabel(s, s.Screen.x, s.Screen.y) end
    end,
})

-- X and Y are fractions of the screen (0-1)
DefineShape("DebugScreenText", "ScreenText", {X = 0.5, Y = 0.5, Text = "", Font = "DermaDefault"}, {
    Draw2D = function(s) DrawLabel(s, s.X * ScrW(), s.Y * ScrH()) end,
})

local Remove = Ponder.API.NewInstruction("RemoveDebugOverlay")
Remove.Length = 0
Remove.Name   = ""

function Remove:First(playback)
    playback.Environment:RemoveNamedObjectByName("DebugOverlay", self.Name)
end

local Clear = Ponder.API.NewInstruction("ClearDebugOverlay")
Clear.Length = 0

function Clear:First(playback)
    local env = playback.Environment
    -- Iterate backwards since removal edits the list in place
    local shapes = env:GetAllNamedObjects("DebugOverlay")
    for i = #shapes, 1, -1 do
        env:RemoveNamedObject("DebugOverlay", shapes[i])
    end
end

--[[ Example:
    Chapter:AddInstruction("DebugBox", {
        Name = "hitbox", Mins = Vector(-8, -8, 0), Maxs = Vector(8, 8, 16), Color = Color(255, 0, 0, 64),
    })
    Chapter:AddInstruction("DebugText", {Name = "label", Position = Vector(0, 0, 32), Text = "Hello"})
    Chapter:AddInstruction("RemoveDebugOverlay", {Name = "hitbox"})
]]
