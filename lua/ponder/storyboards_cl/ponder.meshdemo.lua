-- TEMPORARY: demonstration of the PlaceMesh instruction. Delete when verified.
local sb = Ponder.API.NewStoryboard("ponder", "tests", "mesh-demo")
sb:WithMenuName("Mesh demo")
sb:WithPlaybackName("Mesh demo")
sb:WithModelIcon("models/props_junk/wood_crate001a.mdl")
sb:WithDescription("Draws a procedural mesh with PlaceMesh.")
sb:SetPrimaryLanguage("en")

-- Mesh test: the same procedural pyramid, once with a solid material and once with the default wireframe
local function Tri(a, b, c)
    local normal = (b - a):Cross(c - a):GetNormalized()
    return {
        {pos = a, normal = normal, u = 0,   v = 0},
        {pos = b, normal = normal, u = 1,   v = 0},
        {pos = c, normal = normal, u = 0.5, v = 1},
    }
end

local function PyramidTriangles()
    local tip = Vector(0, 0, 70)
    local p1, p2, p3, p4 = Vector(-35, -35, 0), Vector(35, -35, 0), Vector(35, 35, 0), Vector(-35, 35, 0)
    local tris = {}
    for _, t in ipairs({
        Tri(p1, p2, tip), Tri(p2, p3, tip), Tri(p3, p4, tip), Tri(p4, p1, tip),
        Tri(p1, p4, p3), Tri(p1, p3, p2),
    }) do
        for _, v in ipairs(t) do tris[#tris + 1] = v end
    end
    return tris
end

local c = sb:Chapter("Mesh")
c:AddInstruction("MoveCameraLookAt", {Target = Vector(0, 0, 20), Distance = 700, Angle = 55, Height = 200, Length = 0.5})
c:AddInstruction("PlaceMesh", {
    Name = "pyramid", Material = Material("models/debug/debugwhite"), Position = Vector(-60, 0, 0),
    Color = Color(255, 128, 0), Triangles = PyramidTriangles(),
})
c:AddInstruction("PlaceMesh", {
    Name = "wire", Position = Vector(60, 0, 0), Angles = Angle(0, 45, 0), Scale = Vector(1, 1, 0.5), Triangles = PyramidTriangles(),
})
c:AddInstruction("ShowText", {Name = "lbl", Text = "PlaceMesh", Dimension = "2D", Position = Vector(0.5, 0.75, 0),
    PositionRelativeToScreen = true, Horizontal = TEXT_ALIGN_CENTER, Vertical = TEXT_ALIGN_CENTER, TextAlignment = TEXT_ALIGN_CENTER, Length = 0.2})
c:AddDelay(2.5)
c:AddInstruction("HideText", {Name = "lbl", Length = 0.2})
c:AddInstruction("RemoveMesh", {Name = "pyramid"})
c:AddInstruction("RemoveMesh", {Name = "wire"})
c:AddDelay(0.5)
