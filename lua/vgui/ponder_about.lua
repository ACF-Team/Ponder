-- You should copy this file into your addon; it is designed to give notifications when Ponder is not installed
-- Intended to be placed in lua/vgui/ponder_about.lua

local PANEL     = {}

DEFINE_BASECLASS "DImageButton"

function PANEL:Init()
    BaseClass.Init(self)
    self:SetTooltipDelay(0)
    self:SetImage("icon16/magnifier.png")
    self:SetSize(24, 24)
end

function PANEL:GenTooltip(uuid)
    if not Ponder then return "Ponder is not installed." end

    local storyboard = Ponder.API.RegisteredStoryboards[uuid]
    if not storyboard then return "Ponder storyboard '" .. uuid .. "' not found; the developer likely mistyped something..." end

    return "Open Storyboard '" .. storyboard.Name .. "'"
end

function PANEL:DoClick()
    if not Ponder then
        Derma_Message("Ponder not installed!", "Ponder is not installed on this server. Ask the server to install it here: https://github.com/ACF-Team/Ponder", "OK")
        return
    end

    if not self.UUID then
        Derma_Message("UUID not set!", "The developer made this button without setting a storyboard UUID!", "OK")
        return
    end

    local storyboard = Ponder.API.RegisteredStoryboards[self.UUID]
    if not storyboard then
        Derma_Message("Storyboard not found!", "The storyboard '" .. self.UUID .. "' was not found.", "OK")
        return
    end

    Ponder.Open(self.UUID)
end

function PANEL:SetStoryboard(uuid)
    self.UUID = uuid
    self:SetTooltip(self:GenTooltip(uuid))
end

derma.DefineControl("Ponder.About", "A button that opens the Ponder UI for a specific storyboard", PANEL, "DImageButton")

--[[
local test = vgui.Create "DFrame"
test:SetSize(300, 300)
test:MakePopup()
test:Center()

local p = test:Add "Ponder.About"
p:SetStoryboard "acf-3.turrets.parenting-to-turrets"
p:SetPos(64, 64)
]]