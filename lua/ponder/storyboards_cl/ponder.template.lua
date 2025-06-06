--[[
    Ponder Storyboard Template
    
    Use this template as a starting point for creating your own storyboards.
    Replace the placeholder values with your own content.
]]

-- Create a new storyboard with a unique identifier
-- Format: addon_name, category_name, storyboard_name
local storyboard = Ponder.API.NewStoryboard("ponder", "tests", "true-art")

-- Set storyboard properties
storyboard:WithMenuName("ponder.tests.true_art.menuname")  -- Translation key for menu name
storyboard:WithPlaybackName("ponder.tests.true_art.playname")  -- Translation key for playback name
storyboard:WithModelIcon("models/gibs/hgibs.mdl")  -- Model to show in the menu
storyboard:WithDescription("ponder.tests.true_art.desc")  -- Description text
storyboard:SetPrimaryLanguage("en")  -- Primary language (default is "en")

-- Optional: Set contact information
-- storyboard:SetContactInfo("Your Name", "https://example.com")

---------------------------------------------
-- CHAPTER 1: INTRODUCTION
---------------------------------------------
local chapter1 = storyboard:Chapter()

-- Set up the initial camera position
chapter1:AddInstruction("MoveCameraLookAt", {
    Target = Vector(0, 0, 0),  -- Point to look at
    Distance = 200,            -- Distance from target
    Angle = 45,                -- Angle around target (degrees)
    Height = 100,              -- Height above target
    Time = 0,                  -- When to start
    Length = 1                 -- Duration
})

-- Fade in the camera
chapter1:AddInstruction("FadeCameraIn", {
    Time = 0,
    Length = 0.5
})

-- Place a model
chapter1:AddInstruction("PlaceModel", {
    Name = "MyModel",          -- Identifier for this model
    Model = "models/gibs/hgibs.mdl",  -- Model path
    Position = Vector(5, 0, 5),  -- Position in the environment
    ComeFrom = Vector(0, 0, 50),  -- Starting position offset for animation
    Time = 0.5,                -- When to start
    Length = 0.5               -- Duration
})

-- Show text
chapter1:AddInstruction("ShowText", {
    Name = "IntroText",        -- Identifier for this text
    Text = "my_addon.intro_text",  -- Translation key or direct text
    Position = Vector(0, 0, 50),  -- Position in the environment
    Time = 1,                  -- When to start
    Length = 0.5               -- Duration of fade-in
})

-- Wait for the user to read
chapter1:AddDelay(3)

---------------------------------------------
-- CHAPTER 2: MAIN CONTENT
---------------------------------------------
local chapter2 = storyboard:Chapter()

-- Move camera to a new position with a fade transition
chapter2:AddInstruction("FadeLookAtCameraTransition", {
    Target = Vector(20, 0, 0),  -- New point to look at
    Distance = 150,            -- New distance
    Angle = 90,                -- New angle
    Height = 80,               -- New height
    Time = 0,                  -- When to start
    Length = 1.5               -- Total duration of transition
})

-- Hide previous text
chapter2:AddInstruction("HideText", {
    Name = "IntroText",
    Time = 0,
    Length = 0.3
})

-- Show new text
chapter2:AddInstruction("ShowText", {
    Name = "MainText",
    Text = "my_addon.main_text",
    Position = Vector(20, 0, 50),
    Time = 0.5,
    Length = 0.5
})

-- Add a second model
chapter2:AddInstruction("PlaceModel", {
    Name = "SecondModel",
    Model = "models/props_junk/watermelon01.mdl",
    Position = Vector(40, 0, 0),
    ComeFrom = Vector(0, 0, 50),
    Time = 1,
    Length = 0.5
})

-- Wait for the user to see
chapter2:AddDelay(3)

-- Transform the first model
chapter2:AddInstruction("TransformModel", {
    Target = "MyModel",
    Position = Vector(10, 10, 5),  -- New position
    Angles = Angle(0, 45, 0),      -- New rotation
    Time = 3,
    Length = 1
})

-- Show text explaining the transformation
chapter2:AddInstruction("ShowText", {
    Name = "TransformText",
    Text = "my_addon.transform_text",
    Position = Vector(10, 10, 50),
    Time = 3.5,
    Length = 0.5
})

-- Wait for the user to see
chapter2:AddDelay(3)

---------------------------------------------
-- CHAPTER 3: CONCLUSION
---------------------------------------------
local chapter3 = storyboard:Chapter()

-- Final camera transition
chapter3:AddInstruction("FadeLookAtCameraTransition", {
    Target = Vector(0, 0, 0),
    Distance = 200,
    Angle = 45,
    Height = 100,
    Time = 0,
    Length = 1.5
})

-- Hide previous text
chapter3:AddInstruction("HideText", {
    Name = "MainText",
    Time = 0,
    Length = 0.3
})

chapter3:AddInstruction("HideText", {
    Name = "TransformText",
    Time = 0,
    Length = 0.3
})

-- Show conclusion text
chapter3:AddInstruction("ShowText", {
    Name = "ConclusionText",
    Text = "my_addon.conclusion_text",
    Position = Vector(0, 0, 50),
    Time = 0.5,
    Length = 0.5
})

-- Wait for the user to read
chapter3:AddDelay(3)

-- Optional: Recommend another storyboard
-- chapter3:RecommendStoryboard("my_addon.my_category.another_storyboard")

-- Fade out
chapter3:AddInstruction("FadeCameraOut", {
    Time = 3,
    Length = 1
})

-- End of storyboard
