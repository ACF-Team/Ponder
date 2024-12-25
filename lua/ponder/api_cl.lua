Ponder.API = {}
local API = Ponder.API
API.RegisteredStoryboards  = {}
API.RegisteredInstructions = {}

function API.NewStoryboard(addon_name, category_name, storyboard_name)
    local storyboard = Ponder.Storyboard()
    storyboard.AddonName    = addon_name
    storyboard.CategoryName = category_name
    storyboard.Name         = storyboard_name

    local UUID = storyboard:GenerateUUID()
    API.RegisteredStoryboards[UUID] = storyboard

    return storyboard
end

function API.GetStoryboard(uuid)
    return API.RegisteredStoryboards[uuid]
end

function API.NewInstruction(name)
    local instrClass = Ponder.InheritedClass(Ponder.Instruction)
    API.RegisteredInstructions[name] = instrClass

    return instrClass
end