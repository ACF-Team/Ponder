# Ponder Quick Reference Guide

## Storyboard Creation

```lua
local storyboard = Ponder.API.NewStoryboard("addon_name", "category_name", "storyboard_name")
storyboard:WithMenuName("translation.key.menu")
storyboard:WithPlaybackName("translation.key.playback")
storyboard:WithModelIcon("models/path.mdl")
storyboard:WithDescription("Description text")
storyboard:SetPrimaryLanguage("en")
```

## Chapter Creation

```lua
local chapter = storyboard:Chapter()
```

## Common Instructions

### Camera Control

```lua
-- Move camera
chapter:AddInstruction("MoveCameraLookAt", {
    Target = Vector(0, 0, 0),  -- Point to look at
    Distance = 1500,           -- Distance from target
    Angle = 55,                -- Angle around target (degrees)
    Height = 1000,             -- Height above target
    Time = 0,                  -- When to start
    Length = 0.5               -- Duration
})

-- Fade in/out
chapter:AddInstruction("FadeCameraIn", {Time = 0, Length = 0.5})
chapter:AddInstruction("FadeCameraOut", {Time = 0, Length = 0.5})

-- Camera transition with fade
chapter:AddInstruction("FadeLookAtCameraTransition", {
    Target = Vector(0, 0, 0),
    Distance = 1500,
    Angle = 55,
    Height = 1000,
    Time = 0,
    Length = 1
})
```

### Model Manipulation

```lua
-- Place model
chapter:AddInstruction("PlaceModel", {
    Name = "ModelName",           -- Identifier
    Model = "models/path.mdl",    -- Model path
    Position = Vector(0, 0, 10),  -- Position
    ComeFrom = Vector(0, 0, 50),  -- Starting offset
    Time = 0,                     -- When to start
    Length = 0.5                  -- Duration
})

-- Transform model
chapter:AddInstruction("TransformModel", {
    Name = "ModelName",
    Position = Vector(10, 0, 0),  -- New position
    Angles = Angle(0, 90, 0),     -- New angles
    Time = 0,
    Length = 1
})

-- Color model
chapter:AddInstruction("ColorModel", {
    Name = "ModelName",
    Color = Color(255, 0, 0),
    Time = 0,
    Length = 0.5
})

-- Remove model
chapter:AddInstruction("RemoveModel", {
    Name = "ModelName",
    Time = 0,
    Length = 0.5
})
```

### Text Display

```lua
-- Show text
chapter:AddInstruction("ShowText", {
    Name = "TextName",
    Text = "translation.key",
    Position = Vector(0, 0, 50),
    Time = 0,
    Length = 0.5
})

-- Change text
chapter:AddInstruction("ChangeText", {
    Name = "TextName",
    Text = "new.translation.key",
    Time = 0,
    Length = 0.5
})

-- Hide text
chapter:AddInstruction("HideText", {
    Name = "TextName",
    Time = 0,
    Length = 0.5
})
```

### Toolgun Simulation

```lua
-- Show toolgun
chapter:AddInstruction("ShowToolgun", {
    Time = 0,
    Length = 0.5
})

-- Move toolgun
chapter:AddInstruction("MoveToolgunTo", {
    Position = Vector(10, 0, 20),
    Time = 0,
    Length = 0.5
})

-- Click toolgun
chapter:AddInstruction("ClickToolgun", {
    Time = 0
})

-- Hide toolgun
chapter:AddInstruction("HideToolgun", {
    Time = 0,
    Length = 0.5
})
```

### Timing Control

```lua
-- Add delay
chapter:AddInstruction("Delay", {
    Time = 0,
    Length = 2
})

-- Shorthand
chapter:AddDelay(2)
```

### VGUI (UI Elements)

```lua
-- Place panel
chapter:AddInstruction("VGUI.PlacePanel", {
    Name = "PanelName",
    Panel = "DFrame",
    Position = Vector(0, 0, 50),
    Width = 400,
    Height = 300,
    Time = 0,
    Length = 0.5
})

-- Change panel
chapter:AddInstruction("VGUI.ChangePanel", {
    Name = "PanelName",
    Properties = {
        Text = "New Title",
        BackgroundColor = Color(255, 0, 0)
    },
    Time = 0,
    Length = 0.5
})

-- Remove panel
chapter:AddInstruction("VGUI.RemovePanel", {
    Name = "PanelName",
    Time = 0,
    Length = 0.5
})
```

### Sound

```lua
-- Play sound
chapter:AddInstruction("PlaySound", {
    Sound = "path/to/sound.wav",
    Volume = 1,
    Time = 0
})
```

## Advanced Features

### Model Parenting

```lua
-- Parent model to another model
chapter:AddInstruction("PlaceModel", {
    Name = "Child",
    Model = "models/child.mdl",
    Position = Vector(0, 0, 10),
    ParentTo = "Parent",
    LocalToParent = true
})

-- Parent multiple models
chapter:AddInstruction("Tools.MultiParent", {
    Parent = "ParentModel",
    Children = {"Child1", "Child2", "Child3"}
})
```

### Recommendations

```lua
-- Recommend another storyboard
chapter:RecommendStoryboard("addon.category.storyboard")
```

## Timing Tips

- `Time` is relative to the start of the chapter
- `Length` is how long the instruction takes to complete
- Instructions with `Length = 0` happen instantly
- Use `AddDelay()` to add pauses between actions
- Organize instructions chronologically by their `Time` value

## Best Practices

1. Plan your storyboard before coding
2. Use meaningful names for models and text objects
3. Keep chapters focused on one concept
4. Allow enough time for users to read text
5. Test frequently to ensure smooth animations
6. Add comments to separate sections
7. Use macros for complex sequences
8. Include explanatory text for each step
