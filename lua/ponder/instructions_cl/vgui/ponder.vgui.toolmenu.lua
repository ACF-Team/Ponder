-- Shows a tool's own spawn menu (TOOL.BuildCPanel) inside a storyboard.
-- The controls are cut off from their convars, so the storyboard can set them without touching the viewer's settings.
-- Remove it with RemovePanel.
local function BuildToolMenu(panel, toolName)
    local tool = weapons.GetStored("gmod_tool").Tool[toolName]
    if not tool or not tool.BuildCPanel then return Ponder.Print("PlaceToolMenu: no tool menu for " .. toolName) end

    panel:SetMouseInputEnabled(false)
    panel:SetLabel(language.GetPhrase((string.gsub(tool.Name or toolName, "^#", ""))))
    tool.BuildCPanel(panel)

    panel.ConVarControls = {} -- Convar name -> the control that was bound to it

    local function Detach(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child.m_strConVar then
                local default = GetConVar(child.m_strConVar):GetDefault()
                panel.ConVarControls[child.m_strConVar] = child
                child.m_strConVar, child.Think, child.OnChange = nil, function() end, function() end

                if child.ChooseOptionID then
                    for id = 1, #(child.Choices or {}) do
                        if tostring(child:GetOptionData(id)) == default then child:ChooseOptionID(id) end
                    end
                elseif child.SetValue then
                    child:SetValue(default)
                end
            end

            Detach(child)
        end
    end

    Detach(panel)
    panel:InvalidateLayout(true)
end

local function SetControl(control, value)
    if control.ChooseOptionID then
        for id = 1, #(control.Choices or {}) do
            if control.Choices[id] == value or tostring(control:GetOptionData(id)) == tostring(value) then control:ChooseOptionID(id) end
        end
    else
        control:SetValue(value)
    end
end

local PlaceToolMenu = Ponder.API.NewInstruction("PlaceToolMenu")
PlaceToolMenu.Name     = ""
PlaceToolMenu.Tool     = "" -- The tool's mode name, like "weld"
PlaceToolMenu.Position = Vector(0.8, 0.14, 0) -- Top left corner, as fractions of the screen
PlaceToolMenu.Width    = 300 -- In pixels, like a real tool menu
PlaceToolMenu.Height   = 0.6 -- As a fraction of the screen
PlaceToolMenu.Length   = 0.3

function PlaceToolMenu:First(playback)
    local panel = playback.Environment:NewNamedObject("VGUIPanel", self.Name, "ControlPanel")

    panel:SetSize(self.Width, ScrH() * self.Height)
    panel:SetPos(ScrW() * self.Position.x, ScrH() * self.Position.y)
    BuildToolMenu(panel, self.Tool)
end

function PlaceToolMenu:Update(playback)
    local progress = playback:GetInstructionProgress(self)
    progress = self.Easing and self.Easing(progress) or progress

    playback.Environment:GetNamedObject("VGUIPanel", self.Name):SetAlpha(progress * 255)
end

local SetToolOption = Ponder.API.NewInstruction("SetToolOption")
SetToolOption.Name   = ""
SetToolOption.ConVar = "" -- The convar the control is bound to. The menu no longer changes it, so the viewer's settings stay as they are
SetToolOption.Value  = true -- A boolean for a checkbox, a number for a slider, or an option's text for a combo box
SetToolOption.Length = 0

function SetToolOption:First(playback)
    local menu = playback.Environment:GetNamedObject("VGUIPanel", self.Name)
    local option = menu and menu.ConVarControls[self.ConVar]
    if not option then return Ponder.Print("SetToolOption: no control bound to " .. self.ConVar) end

    SetControl(option, self.Value)
end

--[[ Example:
    Chapter:AddInstruction("PlaceToolMenu", {Name = "menu", Tool = "weld"})
    Chapter:AddInstruction("SetToolOption", {Name = "menu", ConVar = "weld_nocollide", Value = true})
    Chapter:AddInstruction("RemovePanel", {Name = "menu"})
]]
