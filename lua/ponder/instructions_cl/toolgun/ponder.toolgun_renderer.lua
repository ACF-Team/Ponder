local toolgun96 = Material("ponder/ui/toolgun_cursor96.png")
local toolTracer = Material("effects/tool_tracer")
local selectIndicator = Material("effects/select_dot")
local toolgunRenderer = Ponder.API.NewRenderer("Toolgun")

function toolgunRenderer:Initialize(env)
    env.ToolgunState = nil
end

function toolgunRenderer:Render3D(env)
    local state = env.ToolgunState
    if not state then return end

    state.ToolFromToPos2D = state.Position:ToScreen()

    -- Beam rendering based on the actual tooltracer effect
    if state.RenderingBeam then
        local beamAlpha = state.BeamAlpha
        local beamLength = state.BeamLength / 128
        local texCoord = math.Rand(0, 1)
        local beamColor = Color(255, 255, 255, beamAlpha)

        render.SetMaterial(toolTracer)

        for _ = 1, 3 do
            render.DrawBeam(state.BeamStart - state.BeamNorm, state.BeamEnd, 8, texCoord, texCoord + state.BeamNormLength / 128, beamColor)
        end

        render.DrawBeam(state.BeamStart, state.BeamEnd, 8, texCoord, texCoord + beamLength, beamColor)
    end

    if state.RenderingMarker then
        state.TargetFromToPos2D = state.BeamEnd:ToScreen()
    end
end

function toolgunRenderer:Render2D(env)
    local state = env.ToolgunState
    if not state then return end

    local alpha = state.Alpha * 255
    local x, y = state.ToolFromToPos2D.x + 32, state.ToolFromToPos2D.y + 32

    surface.SetMaterial(toolgun96)
    surface.SetDrawColor(255, 255, 255, alpha)
    surface.DrawTexturedRectRotated(x, y, 96, 96, 0)

    draw.SimpleTextOutlined(state.ToolName, "DermaLarge", x, y + 32, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, alpha))

    if state.RenderingMarker then
        local endX, endY = state.TargetFromToPos2D.x, state.TargetFromToPos2D.y

        surface.SetMaterial(selectIndicator)
        surface.SetDrawColor(255, 255, 255, state.MarkerAlpha)
        surface.DrawTexturedRect(endX, endY, 32, 32)
    end
end