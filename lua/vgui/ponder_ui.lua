local PANEL     = {}

DEFINE_BASECLASS "Panel"

surface.CreateFont("Ponder.Title", {
    font = "Tahoma",
    extended = false,
    size = 24,
    weight = 100,
    antialias = true
})

surface.CreateFont("Ponder.Subtitle", {
    font = "Tahoma",
    extended = false,
    size = 38,
    weight = 100,
    antialias = true
})

local padding = 48

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    self.Icon = vgui.Create("ModelImage", self)
    self.Icon:SetMouseInputEnabled(false)
    self.Icon:SetKeyboardInputEnabled(false)
    self.Icon:SetPos(-5000, padding)

    local close = self:Add "DButton"
    close:SetSize(64, 64)
    close:SetPos(ScrW() - 64 - padding, padding)
    function close.DoClick()
        self:Remove()
    end
    close:SetText("")
    function close:Paint(w, h)
        local xc, yc = w / 2, h / 2

        local mult = self.Hovered and 1.5 or self.Depressed and 0.5 or 1
        surface.SetDrawColor(150 * mult, 50 * mult, 50 * mult, 170)
        surface.DrawOutlinedRect(0, 0, w, h, 2)
        local xsize = 12
        surface.DrawLine(xc - xsize, yc - xsize, xc + xsize, yc + xsize)
        surface.DrawLine(xc + xsize, yc - xsize, xc - xsize, yc + xsize)
    end

    local controls = self:Add "Ponder.Controls"
    controls:LinkTo(self)
    controls:SetSize(ScrW(), 384)
    controls:SetPos(0, ScrH() - 384 - 64)

    self.Controls = controls
end

function PANEL:LoadStoryboard(uuid)
    self.Storyboard = Ponder.API.GetStoryboard(uuid)
    self.Icon:SetModel(self.Storyboard.Icon)

    if self.Environment then
        self.Environment:Free()
    end

    self.Storyboard:Preload()

    self.Environment = Ponder.Environment()

    self.Playback = Ponder.Playback(self.Storyboard, self.Environment)

    function self.Environment.Render3D()
        self.Playback:Render3D()
    end

    function self.Environment.Render2D()
        self.Playback:Render2D()
    end

    self.Playback:Play()
    self.Playback.OnComplete = function()
        self.Controls.PlayPauseButton:SetImage("ponder/ui/icon64/play.png")
    end

    self.StartTime = CurTime()
end

function PANEL:Think()
    self.Playback:Update()
end

local COLOR_Title = Color(170, 170, 170)
local COLOR_Subtitle = Color(245, 245, 245)
local GRADIENT = Material("gui/gradient")

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 170)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(0, 0, 0, 255)
    surface.SetMaterial(GRADIENT)

    local size = 32

    local animTime = math.Clamp((CurTime() - self.StartTime) / 1, 0, 1)
    local animGradient = math.ease.OutCirc(animTime)
    local animXGrad = (1 - math.ease.OutBack(animTime)) * 64

    surface.DrawTexturedRect(padding - animXGrad, padding - 12, 500 * animGradient, 48 + 32, 0)
    surface.DrawTexturedRectRotated(padding - animXGrad - (size / 2), (padding - 12) + 40, size, 80, 180)

    draw.SimpleText("Pondering about...", "Ponder.Title", padding - animXGrad + 74, padding, COLOR_Title)
    draw.SimpleText(self.Storyboard.Name, "Ponder.Subtitle", padding - animXGrad + 74, padding + 16 + 6, COLOR_Subtitle)

    self.Environment:Render(w / 2, h / 2, h * 0.8, h * 0.8)
    self.Icon:SetPos(padding - animXGrad, padding)
end

function PANEL:OnRemove()
    -- Free all assets
    self.Environment:Free()
end

derma.DefineControl("Ponder.UI", "Ponder's root UI element", PANEL, "Panel")