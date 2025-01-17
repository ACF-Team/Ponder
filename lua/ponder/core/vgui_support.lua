Ponder.VGUI_Support = {}

-- Runs all methods provided in the instruction's calls on the specified panel.
-- If the call method is reserved by CustomMethodHandlers, then it is passed into 
-- the method handler with an additional argument after panel (env).

-- This scenario would be used, for example, if an argument was a Panel in a panel method;
-- then you'd want to convert the string input from the instruction call into a Panel

function Ponder.VGUI_Support.ConfigureParentPaint(panel, parent)
    panel.PONDER_RenderRoot = not IsValid(parent)
    panel:SetPaintedManually(panel.PONDER_RenderRoot)
end

function Ponder.VGUI_Support.RunMethods(env, panel, calls, props)
    if not panel then return end
    if not calls then return end
    if props then
        for k, v in pairs(props) do
            local method = Ponder.VGUI_Support.CustomMethodHandlers[v.Method]
            if method then
                panel[k] = method(panel, env, v)
            else
                panel[k] = v
            end
        end
    end
    for _, v in ipairs(calls) do
        if not v.Method then ErrorNoHaltWithStack("Instructions.Ponder.PlacePanel: Instruction must specify the Method property") end

        local method = Ponder.VGUI_Support.CustomMethodHandlers[v.Method]
        if not method then
            method = panel[v.Method]
            if not method then ErrorNoHaltWithStack("Instructions.Ponder.PlacePanel: The panel setting '" .. v.Method .. "' wasn't found...") end
            if not v.Args then method(panel)
            else method(panel, unpack(v.Args)) end
        else
            if not v.Args then method(panel, env)
            else method(panel, env, unpack(v.Args)) end
        end
    end
end

Ponder.VGUI_Support.CustomMethodHandlers = {}

function Ponder.VGUI_Support.AddCustomMethodHandler(methodName, methodHandler)
    Ponder.VGUI_Support.CustomMethodHandlers[methodName] = methodHandler
end

Ponder.VGUI_Support.AddCustomMethodHandler("SetParent", function(panel, env, parentName)
    local parent = env:GetNamedObject("VGUIPanel", parentName)
    panel:SetParent(parent)
    Ponder.VGUI_Support.ConfigureParentPaint(panel, parent)
end)