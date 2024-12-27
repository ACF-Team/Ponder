local PANEL     = {}

DEFINE_BASECLASS "Panel"

function PANEL:Init()
    self:Dock(FILL)

    local controls = self:Add "Ponder.Controls"
    controls:LinkTo(self)
    controls:SetSize(ScrW(), 384)
    controls:SetPos(0, ScrH() - 384 - 64)

    self.StoryboardIcon = self:Add "Ponder.StoryboardIcon"
    self.StoryboardIcon:SetPos(48, 48)

    self.Controls = controls
end

function PANEL:LoadStoryboard(uuid)
    if self.Environment then
        self.Environment:Free()
    end

    self.Storyboard = Ponder.API.GetStoryboard(uuid)
    self.StoryboardIcon:SetStoryboard(self.Storyboard)

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

function PANEL:Paint()
    self.Environment:Render()
end

function PANEL:OnRemove()
    -- Free all assets
    self.Environment:Free()
end

derma.DefineControl("Ponder.Storyboard", "Ponder's storyboard visualizer", PANEL, "Panel")