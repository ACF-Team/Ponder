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
    Ponder.OpenIndex()
end, nil, "Open the Ponder index")