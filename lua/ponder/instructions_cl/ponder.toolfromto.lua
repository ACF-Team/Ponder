local ToolFromTo = Ponder.API.NewInstruction("ToolFromTo")

ToolFromTo.Length = 2

local toolsound = "Airboat.FireGunRevDown"
local toolgun96 = Material("ponder/ui/toolgun_cursor96.png")
function ToolFromTo:First(playback)
    playback.ToolFromToState = 0
end

function ToolFromTo:Update(playback)
    local progress = playback:GetInstructionProgress(self)
    local alpha = (math.Clamp(progress, 0, 0.1) / 0.1) * (math.Clamp(math.Remap(progress, 0.9, 1, 1, 0), 0, 1))

    local movement_state = math.Clamp(math.Remap(progress, 0.25, 0.75, 0, 1), 0, 1)
    movement_state = math.ease.InOutQuad(movement_state)

    if movement_state > 0 and playback.ToolFromToState == 0 then
        playback.ToolFromToState = 1
        surface.PlaySound(toolsound)
    elseif movement_state >= 1 and playback.ToolFromToState == 1 then
        playback.ToolFromToState = 2
        surface.PlaySound(toolsound)
    end

    local from = playback.Environment:GetNamedModel(self.From)
    local to   = playback.Environment:GetNamedModel(self.To)

    playback.ToolFromToAlpha = alpha * 255
    playback.ToolFromToPos = LerpVector(movement_state, from:GetPos(), to:GetPos())
end

function ToolFromTo:Render3D(playback)
    playback.ToolFromToPos2D = playback.ToolFromToPos:ToScreen()
end

function ToolFromTo:Render2D(playback)
    local x, y = playback.ToolFromToPos2D.x + 32, playback.ToolFromToPos2D.y + 32

    surface.SetMaterial(toolgun96)
    surface.SetDrawColor(255, 255, 255, playback.ToolFromToAlpha)
    surface.DrawTexturedRectRotated(x, y, 96, 96, 0)

    draw.SimpleTextOutlined(self.Tool, "DermaLarge", x, y + 32, Color(255, 255, 255, playback.ToolFromToAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, playback.ToolFromToAlpha))
end