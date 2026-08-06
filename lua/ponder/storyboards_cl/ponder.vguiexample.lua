local storyboard = Ponder.API.NewStoryboard("ponder", "tests", "vgui-poc")

-- Set storyboard properties
storyboard:WithName("ponder.tests.cool_buttons.menuname")
storyboard:WithPlaybackName("ponder.tests.cool_buttons.playname")
storyboard:WithModelIcon("models/maxofs2d/button_05.mdl")
storyboard:WithDescription("ponder.tests.cool_buttons.desc")
storyboard:SetPrimaryLanguage("en")

local chapter1 = storyboard:Chapter()

-- Set up the initial camera position
chapter1:AddInstruction("PlacePanel", {
    Name = "Test1",
    Type = "DButton",
    Calls = {
        {Method = "SetSize", Args = {300, 50}},
        {Method = "CenterHorizontal", Args = {}},
        {Method = "CenterVertical", Args = {0.25}},
        {Method = "SetText", Args = {"#ponder.tests.cool_buttons.panel1"}},
    },
    Time = 0,
    Length = 2,
})
chapter1:AddInstruction("PlacePanel", {
    Name = "Test2",
    Type = "DButton",
    Calls = {
        {Method = "SetSize", Args = {300, 50}},
        {Method = "CenterHorizontal", Args = {}},
        {Method = "CenterVertical", Args = {0.5}},
        {Method = "SetText", Args = {"#ponder.tests.cool_buttons.panel2"}},
    },
    Time = 2.25,
    Length = 2,
})
chapter1:AddInstruction("PlacePanel", {
    Name = "Test3",
    Type = "DButton",
    Calls = {
        {Method = "SetSize", Args = {300, 50}},
        {Method = "CenterHorizontal", Args = {}},
        {Method = "CenterVertical", Args = {0.75}},
        {Method = "SetText", Args = {"#ponder.tests.cool_buttons.panel3"}},
    },
    Time = 4.5,
    Length = 2,
})
chapter1:AddInstruction("RemovePanel", {
    Name = "Test1",
    Time = 7.75,
    Length = 0.75,
})
chapter1:AddInstruction("RemovePanel", {
    Name = "Test2",
    Time = 7.75,
    Length = 0.75,
})
chapter1:AddInstruction("RemovePanel", {
    Name = "Test3",
    Time = 7.75,
    Length = 0.75,
})