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

    -- Blank placeholders for addon/categories. This ensures they're still visible in the menu
    if not API.RegisteredAddons[addon_name] then
        API.RegisterAddon(addon_name, {
            Name = addon_name,
            ModelIcon = "models/error.mdl",
            Description = "ponder.no_addon_desc"
        })
    end
    if not API.RegisteredAddonCategories[addon_name] then API.RegisteredAddonCategories[addon_name] = {} end
    if not API.RegisteredAddonCategories[addon_name][category_name] then
        API.RegisterAddonCategory(addon_name, category_name, {
            Name = category_name,
            Order = 0,
            ModelIcon = "models/error.mdl",
            Description = "ponder.no_category_desc"
        })
    end
    local storyboards = API.RegisteredACSLookup[addon_name][category_name]
    storyboards[storyboard_name] = storyboard

    return storyboard
end

function API.GetStoryboard(uuid)
    return API.RegisteredStoryboards[uuid]
end

function API.NewInstruction(name)
    local instrClass = Ponder.InheritedClass(Ponder.Instruction)
    instrClass.__INSTRUCTION_NAME = name
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

function API.RegisterAddon(name, data)
    API.RegisteredAddons[name] = data
    data.ID = name
end

function API.RegisterAddonCategory(addon_name, category_name, data)
    if not API.RegisteredAddonCategories[addon_name] then API.RegisteredAddonCategories[addon_name] = {} end

    API.RegisteredAddonCategories[addon_name][category_name] = data
    data.ID = category_name
end

local function sortByName(tab)
    local TableMemberSort = function( a, b, MemberName, bReverse )
        if not istable(a) then return not bReverse end
        if not istable(b) then return bReverse end

        local aMemberName = language.GetPhrase(a[MemberName])
        local bMemberName = language.GetPhrase(b[MemberName])

        if not aMemberName then return not bReverse end
        if not bMemberName then return bReverse end

        if isstring(aMemberName) then
            if bReverse then
                return language.GetPhrase(aMemberName:lower()) < language.GetPhrase(bMemberName:lower())
            else
                return language.GetPhrase(aMemberName:lower()) > language.GetPhrase(bMemberName:lower())
            end
        end

        if bReverse then
            return aMemberName < bMemberName
        else
            return aMemberName > bMemberName
        end

    end

    table.sort(tab, function(a, b) return TableMemberSort(a, b, "Name", false) end)
end

-- Gets all addons
function API.GetAddonsList()
    local items = {}
    for _, v in pairs(API.RegisteredAddons) do items[#items + 1] = v end

    sortByName(items)
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

    table.SortByMember(items, "IndexOrder")
    return items
end