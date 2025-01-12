local storyboard = Ponder.API.NewStoryboard("ponder", "tests", "taking-a-shower")
storyboard:WithMenuName("ponder.tests.shower.menuname")
storyboard:WithPlaybackName("ponder.tests.shower.playname")
storyboard:WithModelIcon("models/props_interiors/BathTub01a.mdl")
storyboard:WithDescription(language.GetPhrase("ponder.tests.shower.desc"))
local chapter1 = storyboard:Chapter()
chapter1:AddInstruction("PlaceModel", {
    Name  = "Bathtub",
    IdentifyAs = "ponder.tests.shower.identify_bathtub",
    Model = "models/props_interiors/BathTub01a.mdl",
    Position = Vector(0, 0, 10),
    ComeFrom = Vector(0, 0, 32)
})
chapter1:AddInstruction("PlaceModel", {
    Name  = "Breen",
    Model = "models/player/breen.mdl",
    Position = Vector(-65, 0, 5),
    ComeFrom = Vector(0, 0, 32),
    Time = 0.5
})

chapter1:AddInstruction("SetSequence", {
    Name = "Breen",
    Time = 0.5,
    Sequence = "idle_all_cower",
    Speed = 2
})

chapter1:AddInstruction("Delay", {Time = 0, Length = 1.5})

chapter1:AddInstruction("SetSequence", {
    Name = "Breen",
    Time = 0,
    Sequence = "death_04",
    Speed = 2
})

chapter1:AddInstruction("ShowText", {
    Name = "hintBreenDied",
    Text = "ponder.tests.shower.breen_died",
    Time = 0,
    Position = Vector(-65, 0, 0)
})

chapter1:AddInstruction("Delay", {Time = 0, Length = 3})

local chapter2 = storyboard:Chapter()
chapter2:AddInstruction("MoveCameraLookAt", {Time = 0, Length = 1.6, Target = Vector(-35, 0, 36), Angle = 150, Distance = 500, Height = 250})
chapter2:AddInstruction("Delay", {Time = 0, Length = 2})
chapter2:AddInstruction("HideText", {Name = "hintBreenDied"})

chapter2:AddInstruction("ShowText", {
    Name = "hintTurnOnShower",
    Text = "ponder.tests.shower.turn_on",
    Time = 0,
    Position = Vector(-35.834717, 10.808605, 36.374023)
})
chapter2:AddInstruction("Delay", {Time = 0, Length = 6})
chapter2:RecommendStoryboard("ponder.tests.taking-a-shower")