local VGUIPanelRenderer = Ponder.API.NewRenderer("VGUIPanelRenderer")

function VGUIPanelRenderer:Render2D(env)
    local items = env:GetAllNamedObjects("VGUIPanel")

    local failed = {}

    for _, v in ipairs(items) do
        if IsValid(v) then
            if v.PONDER_RenderRoot then
                v:PaintManual(true)
            end
        else
            failed[#failed + 1] = v
        end
    end

    for _, v in ipairs(failed) do
        env:RemoveNamedObject("VGUIPanel", v)
    end
end