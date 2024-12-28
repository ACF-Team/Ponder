local toolgun96 = Material("ponder/ui/toolgun_cursor96.png")
local toolgunRenderer = Ponder.API.NewRenderer("Toolgun")

function toolgunRenderer:Initialize(env)
    env.ToolgunState = nil
end

function toolgunRenderer:Render3D(env)
    if not env.ToolgunState then return end
    env.ToolgunState.ToolFromToPos2D = env.ToolgunState.Position:ToScreen()
end

function toolgunRenderer:Render2D(env)
    if not env.ToolgunState then return end
    local state = env.ToolgunState
    local alpha = state.Alpha * 255

    local x, y = state.ToolFromToPos2D.x + 32, state.ToolFromToPos2D.y + 32
    surface.SetMaterial(toolgun96)
    surface.SetDrawColor(255, 255, 255, alpha)
    surface.DrawTexturedRectRotated(x, y, 96, 96, 0)

    draw.SimpleTextOutlined(state.ToolName, "DermaLarge", x, y + 32, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, alpha))
end