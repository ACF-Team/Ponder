--[[
    Ponder Example Storyboard
    
    This is a comprehensive example showing how to create a storyboard
    with Ponder. It demonstrates various instruction types and best practices.
    
    This example creates a tutorial for a fictional tool called "PropPlacer"
    that shows how to place and manipulate props in Garry's Mod.
]]

-- Create a new storyboard with a unique identifier
local storyboard = Ponder.API.NewStoryboard("ponder", "tests", "prop-placer")

-- Set storyboard properties
storyboard:WithMenuName("ponder.tests.prop_placer.menuname")
storyboard:WithPlaybackName("ponder.tests.prop_placer.playname")
storyboard:WithModelIcon("models/props_junk/wood_crate001a.mdl")
storyboard:WithDescription("ponder.tests.prop_placer.desc")
storyboard:SetPrimaryLanguage("en")

-- You can set contact information for attribution
storyboard:SetContactInfo("Your Name", "https://example.com")

---------------------------------------------
-- CHAPTER 1: INTRODUCTION
---------------------------------------------
local chapter1 = storyboard:Chapter()

-- Set up the initial camera position
chapter1:AddInstruction("MoveCameraLookAt", {
    Target = Vector(0, 0, 0),
    Distance = 1000,
    Angle = 65,
    Height = 150,
    Time = 0,
    Length = 1,
    Easing = math.ease.InOutQuad
})

-- Fade in the camera
chapter1:AddInstruction("FadeCameraIn", {
    Time = 0,
    Length = 0.5
})

-- Show introduction text
chapter1:AddInstruction("ShowText", {
    Name = "IntroText",
    Text = "examples.propplacer.intro",
    Position = Vector(0, 0, 80),
    Time = 0.5,
    Length = 0.5
})

-- Wait for the user to read
chapter1:AddDelay(3)

-- Place the toolgun
chapter1:AddInstruction("ShowToolgun", {
    Time = 0,
    Length = 0.5
})

chapter1:AddInstruction("MoveToolgunTo", {
    Position = Vector(50, 0, 30),
    Time = 0,
    Length = 1
})

-- Show text explaining the toolgun
chapter1:AddInstruction("ShowText", {
    Name = "ToolgunText",
    Text = "examples.propplacer.toolgun_intro",
    Position = Vector(50, 0, 30),
    Time = 0,
    Length = 0.5
})

-- Wait for the user to read
chapter1:AddDelay(3)

---------------------------------------------
-- CHAPTER 2: PLACING PROPS
---------------------------------------------
local chapter2 = storyboard:Chapter()

-- Move camera to a new position
chapter2:AddInstruction("FadeLookAtCameraTransition", {
    Target = Vector(0, 0, 20),
    Distance = 1500,
    Angle = 30,
    Height = 80,
    Time = 0,
    Length = 1.5
})

-- Hide previous text
chapter2:AddInstruction("HideText", {
    Name = "IntroText",
    Time = 0,
    Length = 0.3
})

chapter2:AddInstruction("HideText", {
    Name = "ToolgunText",
    Time = 0,
    Length = 0.3
})

-- Show new instruction text
chapter2:AddInstruction("ShowText", {
    Name = "PlacingText",
    Text = "examples.propplacer.placing_props",
    Position = Vector(0, 0, 80),
    Time = 0.5,
    Length = 0.5
})

-- Move toolgun to placement position
chapter2:AddInstruction("MoveToolgunTo", {
    Position = Vector(0, 0, 40),
    Time = 1,
    Length = 0.8
})

-- Simulate clicking the toolgun
chapter2:AddInstruction("ClickToolgun", {
    Time = 2
})

-- Place a prop
chapter2:AddInstruction("PlaceModel", {
    Name = "Crate",
    Model = "models/props_junk/wood_crate001a.mdl",
    Position = Vector(0, 0, 10),
    ComeFrom = Vector(0, 0, 50),
    Time = 2,
    Length = 0.5
})

-- Show success text
chapter2:AddInstruction("ShowText", {
    Name = "SuccessText",
    Text = "examples.propplacer.prop_placed",
    Position = Vector(0, 0, 60),
    Time = 2.5,
    Length = 0.5
})

-- Wait for the user to see the result
chapter2:AddDelay(3)

---------------------------------------------
-- CHAPTER 3: ROTATING PROPS
---------------------------------------------
local chapter3 = storyboard:Chapter()

-- Transition to a new camera angle
chapter3:AddInstruction("FadeLookAtCameraTransition", {
    Target = Vector(0, 0, 20),
    Distance = 120,
    Angle = 90,
    Height = 60,
    Time = 0,
    Length = 1.5
})

-- Hide previous text
chapter3:AddInstruction("HideText", {
    Name = "PlacingText",
    Time = 0,
    Length = 0.3
})

chapter3:AddInstruction("HideText", {
    Name = "SuccessText",
    Time = 0,
    Length = 0.3
})

-- Show rotation instruction text
chapter3:AddInstruction("ShowText", {
    Name = "RotationText",
    Text = "examples.propplacer.rotating_props",
    Position = Vector(0, 0, 80),
    Time = 0.5,
    Length = 0.5
})

-- Move toolgun to the prop
chapter3:AddInstruction("MoveToolgunTo", {
    Position = Vector(0, 30, 20),
    Time = 1,
    Length = 0.8
})

-- Simulate clicking the toolgun
chapter3:AddInstruction("ClickToolgun", {
    Time = 2
})

-- Rotate the prop
chapter3:AddInstruction("TransformModel", {
    Target = "Crate",
    Angles = Angle(0, 90, 0),
    Time = 2,
    Length = 1
})

-- Show success text
chapter3:AddInstruction("ShowText", {
    Name = "RotationSuccessText",
    Text = "examples.propplacer.prop_rotated",
    Position = Vector(0, 0, 60),
    Time = 3,
    Length = 0.5
})

-- Wait for the user to see the result
chapter3:AddDelay(3)

---------------------------------------------
-- CHAPTER 4: COLORING PROPS
---------------------------------------------
local chapter4 = storyboard:Chapter()

-- Transition to a new camera angle
chapter4:AddInstruction("FadeLookAtCameraTransition", {
    Target = Vector(0, 0, 20),
    Distance = 120,
    Angle = 135,
    Height = 60,
    Time = 0,
    Length = 1.5
})

-- Hide previous text
chapter4:AddInstruction("HideText", {
    Name = "RotationText",
    Time = 0,
    Length = 0.3
})

chapter4:AddInstruction("HideText", {
    Name = "RotationSuccessText",
    Time = 0,
    Length = 0.3
})

-- Show coloring instruction text
chapter4:AddInstruction("ShowText", {
    Name = "ColorText",
    Text = "examples.propplacer.coloring_props",
    Position = Vector(0, 0, 80),
    Time = 0.5,
    Length = 0.5
})

-- Move toolgun to the prop
chapter4:AddInstruction("MoveToolgunTo", {
    Position = Vector(-20, 20, 20),
    Time = 1,
    Length = 0.8
})

-- Simulate clicking the toolgun
chapter4:AddInstruction("ClickToolgun", {
    Time = 2
})

-- Color the prop
chapter4:AddInstruction("ColorModel", {
    Target = "Crate",
    Color = Color(255, 0, 0),
    Time = 2,
    Length = 0.5
})

-- Show success text
chapter4:AddInstruction("ShowText", {
    Name = "ColorSuccessText",
    Text = "examples.propplacer.prop_colored",
    Position = Vector(0, 0, 60),
    Time = 2.5,
    Length = 0.5
})

-- Wait for the user to see the result
chapter4:AddDelay(3)

---------------------------------------------
-- CHAPTER 5: USING THE MENU
---------------------------------------------
local chapter5 = storyboard:Chapter()

-- Transition to a new camera angle
chapter5:AddInstruction("FadeLookAtCameraTransition", {
    Target = Vector(0, 0, 20),
    Distance = 150,
    Angle = 180,
    Height = 70,
    Time = 0,
    Length = 1.5
})

-- Hide previous text
chapter5:AddInstruction("HideText", {
    Name = "ColorText",
    Time = 0,
    Length = 0.3
})

chapter5:AddInstruction("HideText", {
    Name = "ColorSuccessText",
    Time = 0,
    Length = 0.3
})

-- Create a VGUI panel to simulate the tool menu
chapter5:AddInstruction("PlacePanel", {
    Name = "ToolMenu",
    Type = "DFrame",
    Position = Vector(-50, 0, 50),
    Width = 200,
    Height = 300,
    Time = 0.5,
    Length = 0.5
})

-- Show menu instruction text
chapter5:AddInstruction("ShowText", {
    Name = "MenuText",
    Text = "examples.propplacer.using_menu",
    Position = Vector(0, 0, 80),
    Time = 1,
    Length = 0.5
})

-- Wait for the user to see the menu
chapter5:AddDelay(3)

-- Change the panel to highlight a button
chapter5:AddInstruction("ChangePanel", {
    Name = "ToolMenu",
    Properties = {
        HighlightButton = "SavePreset"
    },
    Time = 3,
    Length = 0.5
})

-- Show text explaining the highlighted button
chapter5:AddInstruction("ShowText", {
    Name = "SavePresetText",
    Text = "examples.propplacer.save_preset",
    Position = Vector(-50, 0, 100),
    Time = 3.5,
    Length = 0.5
})

-- Wait for the user to read
chapter5:AddDelay(3)

-- Remove the panel
chapter5:AddInstruction("RemovePanel", {
    Name = "ToolMenu",
    Time = 6.5,
    Length = 0.5
})

---------------------------------------------
-- CHAPTER 6: CONCLUSION
---------------------------------------------
local chapter6 = storyboard:Chapter()

-- Transition to a final camera angle
chapter6:AddInstruction("FadeLookAtCameraTransition", {
    Target = Vector(0, 0, 20),
    Distance = 200,
    Angle = 45,
    Height = 100,
    Time = 0,
    Length = 1.5
})

-- Hide previous text
chapter6:AddInstruction("HideText", {
    Name = "MenuText",
    Time = 0,
    Length = 0.3
})

chapter6:AddInstruction("HideText", {
    Name = "SavePresetText",
    Time = 0,
    Length = 0.3
})

-- Hide the toolgun
chapter6:AddInstruction("HideToolgun", {
    Time = 0,
    Length = 0.5
})

-- Show conclusion text
chapter6:AddInstruction("ShowText", {
    Name = "ConclusionText",
    Text = "examples.propplacer.conclusion",
    Position = Vector(0, 0, 80),
    Time = 0.5,
    Length = 0.5
})

-- Wait for the user to read
chapter6:AddDelay(3)

-- Recommend another storyboard
chapter6:RecommendStoryboard("ponder.tests.prop-placer")

-- Fade out
chapter6:AddInstruction("FadeCameraOut", {
    Time = 3,
    Length = 1
})

-- End of storyboard
