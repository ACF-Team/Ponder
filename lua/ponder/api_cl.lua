Ponder.API = {}
local API = Ponder.API
API.RegisteredStoryboards     = {}
API.RegisteredInstructions    = {}
API.RegisteredRenderers       = {}
API.RegisteredAddons          = {}
API.RegisteredAddonCategories = {}
API.RegisteredACSLookup       = {}

function API.NewStoryboard(addon_name, category_name, storyboard_name)
    local storyboard = Ponder.Storyboard()
    storyboard.AddonName    = addon_name
    storyboard.CategoryName = category_name
    storyboard.Name         = storyboard_name

    local UUID = storyboard:GenerateUUID()
    API.RegisteredStoryboards[UUID] = storyboard

    if not API.RegisteredACSLookup[addon_name] then API.RegisteredACSLookup[addon_name] = {} end
    if not API.RegisteredACSLookup[addon_name][category_name] then API.RegisteredACSLookup[addon_name][category_name] = {} end
    local storyboards = API.RegisteredACSLookup[addon_name][category_name]
    storyboards[#storyboards + 1] = storyboard

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

function API.NewInstructionMacro(name)
    local instrClass = Ponder.InheritedClass(Ponder.InstructionMacro)
    API.RegisteredInstructions[name] = instrClass

    return instrClass
end

function API.NewRenderer(name)
    local renderer = Ponder.InheritedClass(Ponder.Renderer)
    API.RegisteredRenderers[name] = renderer

    return renderer
end

function API.RegisterAddon(name, model, desc)
    API.RegisteredAddons[name] = {
        Name = name,
        Model = model,
        Description = desc
    }
end

function API.RegisterAddonCategory(addon_name, category_name, order, model, desc)
    if not API.RegisteredAddonCategories[addon_name] then API.RegisteredAddonCategories[addon_name] = {} end

    API.RegisteredAddonCategories[addon_name][category_name] = {
        AddonName = addon_name,
        CategoryName = category_name,
        Order = order or -1,
        Model = model,
        Description = desc
    }
end

-- Gets all addons
function API.GetAddonsList()
    local items = {}
    for _, v in pairs(API.RegisteredAddons) do items[#items + 1] = v end

    table.SortByMember(items, "Name")
    return items
end

-- Gets all categories in an addon
function API.GetAddonCategoriesList(addon_name)
    local addon = API.RegisteredAddonCategories[addon_name]
    if not addon then return {} end

    local items = {}
    for _, v in pairs(addon) do items[#items + 1] = v end

    table.SortByMember(items, "Order")
    return items
end

-- Gets all storyboards in an addon category
function API.GetCategoryStoryboardList(addon_name, category_name)
    local addon = API.RegisteredAddonCategories[addon_name]
    if not addon then return {} end

    local category = addon[category_name]
    if not category then return {} end

    local lookup = API.RegisteredACSLookup[addon_name][category_name]

    local items = {}
    for _, v in pairs(lookup) do items[#items + 1] = v end

    table.SortByMember(items, "Order")
    return items
end