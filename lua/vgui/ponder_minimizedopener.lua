local MINIMIZED_OPENER = {}

local ponder_minimizedbutton_xmul = CreateClientConVar("ponder_minimizedbutton_xmul", "0", true, false, "", 0, 1)
local ponder_minimizedbutton_ymul = CreateClientConVar("ponder_minimizedbutton_ymul", "1", true, false, "", 0, 1)

Ponder.UI_MINIMIZE_TIME = .5
Ponder.UI_RESTORE_TIME  = .4

function MINIMIZED_OPENER:Init()
    self:SetText("")
    self:SetSize(64, 64)

    local buttonPadding = 32

    self.Icon = self:Add("ModelImage")
    self.Icon:SetMouseInputEnabled(false)
    self.Icon:SetPaintedManually(true)
    self.Icon:SetModel("models/maxofs2d/logo_gmod_b.mdl")
    self.Icon:Dock(FILL)

    local scrw, scrh = ScrW(), ScrH()
    local xmul, ymul = ponder_minimizedbutton_xmul:GetFloat(), ponder_minimizedbutton_ymul:GetFloat()
    local xCoordM = Lerp(xmul, buttonPadding, scrw - buttonPadding - self:GetWide())
    local yCoordM = Lerp(ymul, buttonPadding, scrh - buttonPadding - self:GetTall())

    self:SetPos(xCoordM, yCoordM)

    self.State = -1
end

function MINIMIZED_OPENER:SetupUI(ui)
    self.UI = ui
    self.Matrix = Matrix()
end

function MINIMIZED_OPENER:SetModelIcon(modelIcon)
    self.Icon:SetModel(modelIcon)
end

function MINIMIZED_OPENER:OnRemove()
    self.Icon:Remove()
    Ponder.__MinimizeState = nil
end

function MINIMIZED_OPENER:StartMinimize()
    self.State = 0
    self.Start = CurTime()
end

function MINIMIZED_OPENER:StartRestore()
    self.State = 1
    self.Start = CurTime()
end

local function DrawUI(self, alphaProgress, scaleProgress, translationProgress)
    local matrix = self.Matrix
    matrix:Identity()

    surface.SetAlphaMultiplier(alphaProgress)

    local scrw, scrh = ScrW(), ScrH()
    local sW = math.Remap(scaleProgress, 0, 1, 1, self:GetWide() / scrw)
    local sH = math.Remap(scaleProgress, 0, 1, 1, self:GetTall() / scrh)

    local usX, usY = self:LocalToScreen(0, 0)

    local sX = math.Remap(translationProgress, 0, 1, 0, usX)
    local sY = math.Remap(translationProgress, 0, 1, 0, usY)

    matrix:Translate(Vector(sX, sY, 0))
    matrix:Scale(Vector(sW, sH, 1))
    cam.PushModelMatrix(matrix)
    -- I should probably have a better way to do this...
    Ponder.__MinimizeState = {
        X = sX,
        Y = sY,
        W = sW * scrw,
        H = sH * scrh
    }
    self.UI:PaintManual(true)
    cam.PopModelMatrix()
    surface.SetAlphaMultiplier(1)
end

local function DrawButton(self, alphaProgress, scaleProgress, translationProgress)
    local matrix = self.Matrix
    matrix:Identity()

    surface.SetAlphaMultiplier(alphaProgress)
    local scrw, scrh = ScrW(), ScrH()
    local sW = math.Remap(scaleProgress, 0, 1, scrw / self:GetWide(), 1)
    local sH = math.Remap(scaleProgress, 0, 1, scrh / self:GetWide(), 1)

    local usX, usY = self:LocalToScreen(0, 0)
    local usW, usH = self:GetWide(), self:GetTall()

    local sX = math.Remap(translationProgress, 0, 1, 0, usX)
    local sY = math.Remap(translationProgress, 0, 1, 0, usY)

    matrix:Translate(Vector(sX, sY, 0))
    matrix:Scale(Vector(sW, sH, 0))
    matrix:Translate(Vector(-usX, -usY, 0))
    cam.PushModelMatrix(matrix)

    DButton.Paint(self, usW, usH)
    surface.SetAlphaMultiplier(alphaProgress * alphaProgress)
    self.Icon:PaintManual()

    cam.PopModelMatrix()
    surface.SetAlphaMultiplier(1)
end

function MINIMIZED_OPENER:Paint(w, h)
    DisableClipping(true)

    local time = CurTime() - self.Start
    if self.State == -1 then
        DButton.Paint(self, w, h)
        self.Icon:PaintManual()
    elseif self.State == 0 then
        local progress = math.Clamp(time / Ponder.UI_MINIMIZE_TIME, 0, 1)
        if progress >= 1 then
            self.State = -1
        else
            local scaleProgress = math.ease.OutSine(progress)
            local translationProgress = math.ease.InCubic(progress)

            DrawUI(self, 1 - progress, scaleProgress, translationProgress)
            DrawButton(self, progress, scaleProgress, translationProgress)
        end
    elseif self.State == 1 then
        local progress = math.Clamp(time / Ponder.UI_RESTORE_TIME, 0, 1)
        local scaleProgress = math.ease.InSine(1 - progress)
        local translationProgress = math.ease.InCubic(1 - progress)
        DrawUI(self, progress, scaleProgress, translationProgress)
        DrawButton(self, 1 - progress, scaleProgress, translationProgress)

        if progress >= 1 then
            self.State = -2
            Ponder.__MinimizeState = nil
            self.UI:SetPaintedManually(false)
        end
    end

    DisableClipping(false)
end

function MINIMIZED_OPENER:DoClick()
    self.UI:PonderShow()
end

derma.DefineControl("Ponder.MinimizedOpener", "Minimize re-opener with animations", MINIMIZED_OPENER, "DButton")