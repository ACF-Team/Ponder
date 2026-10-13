-- TEMPORARY: demonstration of the DebugOverlay instructions. Delete when verified.
local sb = Ponder.API.NewStoryboard("ponder", "tests", "debugoverlay-demo")
sb:WithMenuName("DebugOverlay demo")
sb:WithPlaybackName("DebugOverlay demo")
sb:WithModelIcon("models/props_junk/wood_crate001a.mdl")
sb:WithDescription("Shows every DebugOverlay instruction.")
sb:SetPrimaryLanguage("en")

-- One chapter per instruction; each removes its own shape before the next begins.
local function Section(title, instr, params, removeWith)
    local c = sb:Chapter(title)
    params.Name = "shape"
    c:AddInstruction("MoveCameraLookAt", {Target = Vector(0, 0, 20), Distance = 700, Angle = 55, Height = 200, Length = 0.5})
    c:AddInstruction(instr, params)
    c:AddInstruction("ShowText", {Name = "lbl", Text = instr, Dimension = "2D", Position = Vector(0.5, 0.75, 0),
        PositionRelativeToScreen = true, Horizontal = TEXT_ALIGN_CENTER, Vertical = TEXT_ALIGN_CENTER, TextAlignment = TEXT_ALIGN_CENTER, Length = 0.2})
    c:AddDelay(2.5)
    c:AddInstruction("HideText", {Name = "lbl", Length = 0.2})
    c:AddInstruction(removeWith or "RemoveDebugOverlay", {Name = "shape"})
    c:AddDelay(0.2)
end

Section("Axis",     "DebugAxis",     {Position = Vector(0, 0, 0), Size = 60})
Section("Box",      "DebugBox",      {Position = Vector(0, 0, 0), Mins = Vector(-30, -30, 0), Maxs = Vector(30, 30, 60), Color = Color(255, 0, 0, 80), Angles = Angle(0, 30, 0)})
Section("Cross",    "DebugCross",    {Position = Vector(0, 0, 30), Size = 60, Color = Color(255, 255, 0)})
Section("Grid",     "DebugGrid",     {Position = Vector(0, 0, 0), Count = 6, Spacing = 20, Color = Color(0, 255, 255)})
Section("Line",     "DebugLine",     {Start = Vector(0, 0, 0), End = Vector(0, 0, 80), Color = Color(0, 255, 0)})
Section("Sphere",   "DebugSphere",   {Position = Vector(0, 0, 40), Radius = 40, Color = Color(0, 128, 255, 80)})
Section("SweptBox", "DebugSweptBox", {Start = Vector(-80, 0, 0), End = Vector(80, 0, 0), Mins = Vector(-10, -10, 0), Maxs = Vector(10, 10, 20), Color = Color(255, 128, 0)})
Section("Triangle", "DebugTriangle", {P1 = Vector(-40, 0, 0), P2 = Vector(40, 0, 0), P3 = Vector(0, 0, 70), Color = Color(200, 0, 255, 150)})
Section("Text",     "DebugText",     {Position = Vector(0, 0, 40), Text = "DebugText in the world"})
Section("ScreenText", "DebugScreenText", {X = 0.5, Y = 0.2, Text = "DebugScreenText"})

-- Clear removes everything at once
local c = sb:Chapter("Clear")
c:AddInstruction("DebugCross", {Name = "a", Position = Vector(-40, 0, 20), Size = 40})
c:AddInstruction("DebugSphere", {Name = "b", Position = Vector(40, 0, 20), Radius = 20})
c:AddDelay(1.5)
c:AddInstruction("ClearDebugOverlay", {})
c:AddDelay(1.5)
