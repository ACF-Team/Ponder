local storyboard = Ponder.API.NewStoryboard("ACF-3", "Turrets", "Parenting to Turrets")
storyboard:WithSpawnIcon("models/acf/core/t_ring.mdl")

local chapter1 = storyboard:Chapter()
chapter1:AddInstruction("PlaceModel", {
    Name  = "TurretRing",
    Model = "models/acf/core/t_ring.mdl",
    Position = Vector(0, 0, 10),
    ComeFrom = Vector(0, 0, 32)
})
chapter1:AddInstruction("Delay", {Length = 0.5})
chapter1:AddInstruction("PlaceModel", {
    Name  = "TurretTrun",
    Model = "models/acf/core/t_trun.mdl",
    Position = Vector(0, 20, 48),
    ComeFrom = Vector(0, 0, 32),
    ParentTo = "TurretRing"
})

chapter1:AddInstruction("Delay", {Length = 0.75})

chapter1:AddInstruction("ShowText", {
    Name = "expHRing",
    Text = "Horizontal turret rings turn your turret from side to side...",
    Time = 0,
    Position = Vector(0, 0, 10)
})

chapter1:AddInstruction("Delay", {Length = 0.75})
chapter1:AddInstruction("TransformModel", {Target = "TurretRing", Rotation = Angle(0, 45, 0), Length = 0.5})
chapter1:AddInstruction("Delay", {Length = 0.6})
chapter1:AddInstruction("TransformModel", {Target = "TurretRing", Rotation = Angle(0, -45, 0), Length = 0.75})
chapter1:AddInstruction("Delay", {Length = 0.85})
chapter1:AddInstruction("TransformModel", {Target = "TurretRing", Rotation = Angle(0, 0, 0), Length = 0.75})
chapter1:AddInstruction("Delay", {Length = 0.65})
chapter1:AddInstruction("HideText", {Name = "expHRing", Length = 0.4})
chapter1:AddInstruction("Delay", {Length = 0.3})

chapter1:AddInstruction("ShowText", {
    Name = "expVRing",
    Text = "... and vertical turret rings rotate up and down",
    Time = 0,
    Position = Vector(0, 20, 48)
})

chapter1:AddInstruction("Delay", {Length = 0.75})
chapter1:AddInstruction("TransformModel", {Target = "TurretTrun", Rotation = Angle(45, 0, 0), Length = 0.5})
chapter1:AddInstruction("Delay", {Length = 0.6})
chapter1:AddInstruction("TransformModel", {Target = "TurretTrun", Rotation = Angle(-45, 0, 0), Length = 0.75})
chapter1:AddInstruction("Delay", {Length = 0.85})
chapter1:AddInstruction("TransformModel", {Target = "TurretTrun", Rotation = Angle(0, 0, 0), Length = 0.75})
chapter1:AddInstruction("Delay", {Length = 0.65})
chapter1:AddInstruction("HideText", {Name = "expVRing", Length = 0.4})
chapter1:AddInstruction("Delay", {Length = 0.3})

local chapter2 = storyboard:Chapter()
chapter2:AddInstruction("MoveCameraLookAt", {Time = 0, Length = 1.6, Target = Vector(70, 0, 36), Angle = 30, Distance = 1700, Height = 250})
chapter2:AddInstruction("Delay", {Length = 0.3})
chapter2:AddInstruction("PlaceModel", {
    Name  = "Gun",
    Model = "models/tankgun_new/tankgun_100mm.mdl",
    Position = Vector(0, 0, 48),
    ComeFrom = Vector(500, 0, 0),
    Length = 1.3,
    ParentTo = "TurretTrun"
})

chapter2:AddInstruction("Delay", {Length = 1.4})

chapter2:AddInstruction("ShowText", {
    Name = "expGun",
    Text = "Once parented to the vertical-axis, the gun will\nrotate with the turret",
    Time = 0,
    Position = Vector(0, 0, 0),
    ParentTo = "TurretTrun"
})

chapter2:AddInstruction("ShowToolgun", {Length = .5, Tool = "Multi-Parent"})
local t = chapter2:AddInstruction("MultiParent", {
    Children = {"Gun"},
    Parent = "TurretTrun",
    Easing = math.ease.InOutQuad
})
chapter2:AddInstruction("HideToolgun", {Time = t, Length = .5})
chapter2:AddInstruction("Delay", {Length = 3})

chapter2:AddInstruction("TransformModel", {Target = "TurretRing", Rotation = Angle(0, 45, 0), Length = 0.75})
chapter2:AddInstruction("TransformModel", {Target = "TurretTrun", Rotation = Angle(-25, 0, 0), Length = 0.75})

chapter2:AddInstruction("HideText",       {Name = "expGun", Time = 1})
chapter2:AddInstruction("RemoveModel",    {Name = "Gun", Time = 1})
chapter2:AddInstruction("RemoveModel",    {Name = "TurretTrun", Time = 1})
