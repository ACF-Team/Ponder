# Ponder - In-Game Tutorial System Wiki

## Table of Contents
1. [Introduction](#introduction)
2. [Core Concepts](#core-concepts)
3. [Creating a Storyboard](#creating-a-storyboard)
4. [Working with Chapters](#working-with-chapters)
5. [Instruction Types](#instruction-types)
   - [Model Instructions](#model-instructions)
   - [Camera Instructions](#camera-instructions)
   - [Text Instructions](#text-instructions)
   - [Timing Instructions](#timing-instructions)
   - [Toolgun Instructions](#toolgun-instructions)
   - [VGUI Instructions](#vgui-instructions)
   - [Sound Instructions](#sound-instructions)
6. [Instruction Macros](#instruction-macros)
7. [Advanced Features](#advanced-features)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)
10. [Example Storyboards](#example-storyboards)

## Introduction

Ponder is a powerful in-game tutorial system for Garry's Mod that allows you to create interactive, animated tutorials to explain game mechanics, addons, or any other concept. It provides a rich set of tools to place models, animate cameras, display text, and more in a 3D environment.

This wiki will guide you through the process of creating your own storyboards using the Ponder API.

## Core Concepts

Ponder is built around several key concepts:

- **Storyboard**: The main container for a tutorial. A storyboard has a unique identifier, name, description, and contains one or more chapters.
- **Chapter**: A section of a storyboard containing a sequence of instructions. Chapters are played in order.
- **Instruction**: An individual action like placing a model, showing text, or moving the camera. Instructions have a start time and duration.
- **Environment**: The 3D space where the tutorial takes place. It manages models, text, and other elements.
- **Playback**: Controls the playback of a storyboard, handling timing and transitions.

## Creating a Storyboard

To create a new storyboard, use the `Ponder.API.NewStoryboard` function:

```lua
local storyboard = Ponder.API.NewStoryboard("addon_name", "category_name", "storyboard_name")
```

These parameters form a unique identifier for your storyboard. After creating the storyboard, you can set additional properties:

```lua
-- Set the name that appears in the menu
storyboard:WithMenuName("my.translation.key.menu")

-- Set the name that appears during playback
storyboard:WithPlaybackName("my.translation.key.playback")

-- Set both names to the same value
storyboard:WithName("my.translation.key")

-- Set the description
storyboard:WithDescription("A detailed description of this tutorial")

-- Set the model icon (shown in the menu)
storyboard:WithModelIcon("models/mymodel.mdl")

-- Set the primary language (default is "en")
storyboard:SetPrimaryLanguage("en")

-- Set contact information
storyboard:SetContactInfo("Your Name", "https://example.com")
```

## Working with Chapters

Chapters divide your storyboard into logical sections. To create a chapter:

```lua
local chapter1 = storyboard:Chapter()
```

You can optionally provide a name for the chapter:

```lua
local chapter2 = storyboard:Chapter("Second Chapter")
```

Once you have a chapter, you can add instructions to it:

```lua
chapter1:AddInstruction("InstructionType", {
    -- Instruction parameters
    Time = 0,
    Length = 1,
    -- Other parameters specific to the instruction type
})
```

The `Time` parameter specifies when the instruction should start relative to the beginning of the chapter. The `Length` parameter specifies how long the instruction should take to complete.

## Instruction Types

Ponder provides many types of instructions for different purposes. Here are the main categories:

### Model Instructions

Model instructions allow you to place, transform, and manipulate 3D models in the environment.

#### PlaceModel

Places a model in the environment:

```lua
chapter:AddInstruction("PlaceModel", {
    Name = "ModelName",           -- Identifier for referencing this model later
    IdentifyAs = "display.name",  -- Optional: Display name when hovering over the model
    Model = "models/path.mdl",    -- Model path
    Position = Vector(0, 0, 10),  -- Position in the environment
    Angles = Angle(0, 0, 0),      -- Optional: Rotation angles
    ComeFrom = Vector(0, 0, 50),  -- Optional: Starting position offset for animation
    RotateFrom = Angle(0, 0, 0),  -- Optional: Starting rotation offset for animation
    Time = 0,                     -- When to start this instruction
    Length = 0.5,                 -- How long the animation should take
    Scale = Vector(1, 1, 1)       -- Optional: Scale the model
})
```

#### SetBodyGroup

Changes a model's bodygroup:

```lua
chapter:AddInstruction("SetBodyGroup", {
    Name = "ModelName",  -- Name of the model to modify
    Index = 0,           -- Bodygroup index
    Value = 1            -- New value for the bodygroup
})
```

#### ColorModel

Changes a model's color:

```lua
chapter:AddInstruction("ColorModel", {
    Name = "ModelName",      -- Name of the model to modify
    Color = Color(255, 0, 0) -- New color
})
```

#### MaterialModel

Changes a model's material:

```lua
chapter:AddInstruction("MaterialModel", {
    Name = "ModelName",           -- Name of the model to modify
    Material = "path/to/material" -- New material
})
```

#### RemoveModel

Removes a model from the environment:

```lua
chapter:AddInstruction("RemoveModel", {
    Name = "ModelName",        -- Name of the model to remove
    FadeOut = true,            -- Optional: Fade out instead of instant removal
    Time = 0,                  -- When to start this instruction
    Length = 0.5               -- How long the fade should take
})
```

#### SetSequence

Sets an animation sequence on a model:

```lua
chapter:AddInstruction("SetSequence", {
    Name = "ModelName",        -- Name of the model to animate
    Sequence = "sequence_name", -- Name of the sequence
    Speed = 1,                 -- Optional: Playback speed
    Time = 0                   -- When to start this instruction
})
```

#### TransformModel

Moves and/or rotates a model:

```lua
chapter:AddInstruction("TransformModel", {
    Name = "ModelName",        -- Name of the model to transform
    Position = Vector(10, 0, 0), -- New position
    Angles = Angle(0, 90, 0),  -- New angles
    Time = 0,                  -- When to start this instruction
    Length = 1                 -- How long the animation should take
})
```

### Camera Instructions

Camera instructions control the viewpoint of the tutorial.

#### MoveCameraLookAt

Moves the camera to look at a specific point:

```lua
chapter:AddInstruction("MoveCameraLookAt", {
    Target = Vector(0, 0, 0),  -- Point to look at
    Distance = 1500,           -- Distance from the target
    Angle = 55,                -- Angle around the target (degrees)
    Height = 1000,             -- Height above the target
    Time = 0,                  -- When to start this instruction
    Length = 0.5,              -- How long the camera movement should take
    Easing = math.ease.InOutQuad -- Optional: Easing function
})
```

#### FadeCameraIn

Fades the camera in from black:

```lua
chapter:AddInstruction("FadeCameraIn", {
    Time = 0,                  -- When to start this instruction
    Length = 0.5,              -- How long the fade should take
    Easing = math.ease.OutQuad -- Optional: Easing function
})
```

#### FadeCameraOut

Fades the camera out to black:

```lua
chapter:AddInstruction("FadeCameraOut", {
    Time = 0,                  -- When to start this instruction
    Length = 0.5,              -- How long the fade should take
    Easing = math.ease.InQuad  -- Optional: Easing function
})
```

### Text Instructions

Text instructions display text in the environment.

#### ShowText

Shows text in the environment:

```lua
chapter:AddInstruction("ShowText", {
    Name = "TextName",         -- Identifier for referencing this text later
    Text = "my.translation.key", -- Text to display (or translation key)
    Markup = "<font=DermaLarge>Custom markup</font>", -- Optional: Custom markup
    Position = Vector(0, 0, 50), -- Position in the environment
    Dimension = "3D",          -- "3D" or "2D"
    Time = 0,                  -- When to start this instruction
    Length = 0.5,              -- How long the fade-in should take
    Horizontal = TEXT_ALIGN_LEFT, -- Horizontal alignment
    Vertical = TEXT_ALIGN_TOP,    -- Vertical alignment
    TextAlignment = TEXT_ALIGN_LEFT, -- Text alignment
    LocalizeText = true        -- Whether to translate the text
})
```

#### ChangeText

Changes the text of an existing text object:

```lua
chapter:AddInstruction("ChangeText", {
    Name = "TextName",         -- Name of the text to modify
    Text = "new.translation.key", -- New text
    Time = 0,                  -- When to start this instruction
    Length = 0.5               -- How long the transition should take
})
```

#### HideText

Hides a text object:

```lua
chapter:AddInstruction("HideText", {
    Name = "TextName",         -- Name of the text to hide
    Time = 0,                  -- When to start this instruction
    Length = 0.5               -- How long the fade-out should take
})
```

### Timing Instructions

Timing instructions control the flow of the tutorial.

#### Delay

Adds a delay before the next instruction:

```lua
chapter:AddInstruction("Delay", {
    Time = 0,                  -- When to start this instruction
    Length = 2                 -- How long to delay
})
```

You can also use the shorthand:

```lua
chapter:AddDelay(2)  -- Adds a 2-second delay
```

### Toolgun Instructions

Toolgun instructions simulate the use of the Garry's Mod toolgun.

#### ShowToolgun

Shows the toolgun:

```lua
chapter:AddInstruction("ShowToolgun", {
    Time = 0,                  -- When to start this instruction
    Length = 0.5               -- How long the fade-in should take
})
```

#### HideToolgun

Hides the toolgun:

```lua
chapter:AddInstruction("HideToolgun", {
    Time = 0,                  -- When to start this instruction
    Length = 0.5               -- How long the fade-out should take
})
```

#### MoveToolgunTo

Moves the toolgun to a specific position:

```lua
chapter:AddInstruction("MoveToolgunTo", {
    Position = Vector(10, 0, 20), -- Target position
    Time = 0,                  -- When to start this instruction
    Length = 0.5               -- How long the movement should take
})
```

#### ClickToolgun

Simulates clicking the toolgun:

```lua
chapter:AddInstruction("ClickToolgun", {
    Time = 0                   -- When to start this instruction
})
```

### VGUI Instructions

VGUI instructions allow you to work with Garry's Mod UI elements.

#### PlacePanel

Places a VGUI panel in the environment:

```lua
chapter:AddInstruction("VGUI.PlacePanel", {
    Name = "PanelName",        -- Identifier for referencing this panel later
    Panel = "DFrame",          -- Panel type
    Position = Vector(0, 0, 50), -- Position in the environment
    Width = 400,               -- Panel width
    Height = 300,              -- Panel height
    Time = 0,                  -- When to start this instruction
    Length = 0.5               -- How long the fade-in should take
})
```

#### RemovePanel

Removes a VGUI panel:

```lua
chapter:AddInstruction("VGUI.RemovePanel", {
    Name = "PanelName",        -- Name of the panel to remove
    Time = 0,                  -- When to start this instruction
    Length = 0.5               -- How long the fade-out should take
})
```

#### ChangePanel

Changes a VGUI panel's properties:

```lua
chapter:AddInstruction("VGUI.ChangePanel", {
    Name = "PanelName",        -- Name of the panel to modify
    Properties = {             -- Properties to change
        Text = "New Title",
        BackgroundColor = Color(255, 0, 0)
    },
    Time = 0,                  -- When to start this instruction
    Length = 0.5               -- How long the transition should take
})
```

### Sound Instructions

Sound instructions play sounds during the tutorial.

#### PlaySound

Plays a sound:

```lua
chapter:AddInstruction("PlaySound", {
    Sound = "path/to/sound.wav", -- Sound file path
    Volume = 1,                -- Optional: Volume (0-1)
    Time = 0                   -- When to start this instruction
})
```

## Instruction Macros

Instruction macros are special instructions that generate multiple instructions. They simplify common patterns.

### FadeLookAtCameraTransition

Creates a smooth camera transition with fade effects:

```lua
chapter:AddInstruction("FadeLookAtCameraTransition", {
    Target = Vector(0, 0, 0),  -- Point to look at
    Distance = 1500,           -- Distance from the target
    Angle = 55,                -- Angle around the target (degrees)
    Height = 1000,             -- Height above the target
    Time = 0,                  -- When to start this instruction
    Length = 1,                -- Total length of the transition
    EaseIn = math.ease.OutQuad, -- Optional: Easing function for fade in
    EaseOut = math.ease.InQuad, -- Optional: Easing function for fade out
    DelayBehavior = "OnTransition" -- When to add delay: "None", "OnTransition", "AfterFade"
})
```

### RecommendStoryboard

Recommends another storyboard at the end of a chapter:

```lua
chapter:RecommendStoryboard("addon.category.storyboard")
```

### Tools.MultiParent

Parents multiple models to a parent model:

```lua
chapter:AddInstruction("Tools.MultiParent", {
    Parent = "ParentModelName", -- Name of the parent model
    Children = {               -- Names of child models
        "ChildModel1",
        "ChildModel2"
    }
})
```

## Advanced Features

### Localization

Ponder supports multiple languages. You can set the primary language for a storyboard and mark other languages as supported:

```lua
storyboard:SetPrimaryLanguage("en")
storyboard:MarkLanguageAsSupported("fr", Ponder.Localization.TranslationQuality.Supported)
storyboard:MarkLanguageAsSupported("de", Ponder.Localization.TranslationQuality.Unsupported)
```

Translation strings are stored in `resource/localization/<language>/ponder.properties` files.

### Model Parenting

You can parent models to other models to create hierarchical structures:

```lua
chapter:AddInstruction("PlaceModel", {
    Name = "Child",
    Model = "models/child.mdl",
    Position = Vector(0, 0, 10),
    ParentTo = "Parent",       -- Name of the parent model
    LocalToParent = true       -- Position is relative to parent
})
```

### Custom Base Entity

By default, Ponder places a grid model at the base of the environment. You can change this or disable it:

```lua
storyboard:WithBaseEntity("models/custom_grid.mdl")  -- Custom grid model
-- or
storyboard:WithBaseEntity(nil)  -- No grid model
```

## Best Practices

1. **Plan your storyboard**: Before coding, sketch out the sequence of events and camera movements.

2. **Use meaningful names**: Give your models and text objects descriptive names for easier reference.

3. **Keep chapters focused**: Each chapter should explain one concept or step.

4. **Use appropriate timing**: Allow enough time for users to read text and understand what's happening.

5. **Test frequently**: Preview your storyboard often to ensure smooth animations and correct timing.

6. **Use macros for complex sequences**: Instruction macros can simplify common patterns like camera transitions.

7. **Add descriptive text**: Always include explanatory text to guide the user through the tutorial.

8. **Organize instructions by time**: Keep your instructions in chronological order for easier maintenance.

9. **Use comments to separate sections**: Add comments to mark different parts of your storyboard.

10. **Preload assets**: Use the `Preload` method to ensure models are loaded before they're needed.

## Troubleshooting

### Common Issues

1. **Models not appearing**: Check that the model path is correct and the model exists.

2. **Text not visible**: Ensure the text position is within the camera's view.

3. **Animations too fast/slow**: Adjust the `Length` parameter to control animation speed.

4. **Camera movements jarring**: Use longer durations and appropriate easing functions for smoother transitions.

5. **Instructions not executing**: Verify that the `Time` parameter is set correctly.

### Debugging

Ponder provides debugging functions to help troubleshoot issues:

```lua
Ponder.Print("Debug message")  -- Prints a message to the console
Ponder.DebugPrint("Detailed debug info")  -- Prints only when debugging is enabled
```

## Example Storyboards

Here's a complete example of a simple storyboard:

```lua
local storyboard = Ponder.API.NewStoryboard("my_addon", "tutorials", "getting_started")
storyboard:WithMenuName("myaddon.tutorial.menu.getting_started")
storyboard:WithPlaybackName("myaddon.tutorial.play.getting_started")
storyboard:WithModelIcon("models/myaddon/icon.mdl")
storyboard:WithDescription("Learn the basics of My Addon")
storyboard:SetPrimaryLanguage("en")

-- Chapter 1: Introduction
local chapter1 = storyboard:Chapter()

-- Place a model
chapter1:AddInstruction("PlaceModel", {
    Name = "MainDevice",
    Model = "models/myaddon/device.mdl",
    Position = Vector(0, 0, 10),
    ComeFrom = Vector(0, 0, 50)
})

-- Show explanatory text
chapter1:AddInstruction("ShowText", {
    Name = "IntroText",
    Text = "myaddon.tutorial.intro_text",
    Position = Vector(0, 0, 60)
})

-- Wait for 3 seconds
chapter1:AddDelay(3)

-- Chapter 2: Features
local chapter2 = storyboard:Chapter()

-- Move camera to focus on a detail
chapter2:AddInstruction("MoveCameraLookAt", {
    Target = Vector(10, 0, 15),
    Distance = 500,
    Angle = 45,
    Height = 200,
    Length = 1
})

-- Show feature text
chapter2:AddInstruction("ShowText", {
    Name = "FeatureText",
    Text = "myaddon.tutorial.feature_text",
    Position = Vector(10, 0, 40)
})

-- Wait for 3 seconds
chapter2:AddDelay(3)

-- End with a recommendation
chapter2:RecommendStoryboard("my_addon.tutorials.advanced_features")
```

For more complex examples, refer to the built-in storyboards in the `lua/ponder/storyboards_cl/` directory.

## Conclusion

Ponder is a powerful tool for creating in-game tutorials in Garry's Mod. With its rich set of instructions and flexible architecture, you can create engaging and informative tutorials for your addons or game mechanics.

This wiki covers the basics of using Ponder, but there's much more to explore. Experiment with different instruction types and combinations to create unique and effective tutorials.
