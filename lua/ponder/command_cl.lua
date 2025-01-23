concommand.Add("ponder_about", function(_, _, args)
    Ponder.Open(args[1])
end, function(cmd, _, args)
    local arg1 = args[1]
    local rets = {}

    if not arg1 then
        for key in pairs(Ponder.API.RegisteredStoryboards) do
            rets[#rets + 1] = cmd .. " " .. key
        end
    else
        for key in pairs(Ponder.API.RegisteredStoryboards) do
            if string.StartsWith(key, arg1) then rets[#rets + 1] = cmd .. " " .. key end
        end
    end

    return rets
end, "Open the Ponder storyboard for the given UUID")

concommand.Add("ponder_index", function(_, _, _)
    if IsValid(Ponder.UIWindow) then
        Ponder.UIWindow:PonderShow()
    else
        Ponder.OpenIndex()
    end
end, nil, "Open the Ponder index")

concommand.Add("ponder_restore", function(_, _, _)
    local UI = Ponder.UIWindow
    if not IsValid(UI) then return Ponder.Print("The Ponder UI is not minimized, so it cannot be restored") end
    UI:PonderShow()
end, nil, "Re-opens the Ponder window")