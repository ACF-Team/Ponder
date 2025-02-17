function Ponder.Open(uuid)
    if not uuid then return Ponder.Print("Nothing to ponder about...") end

    uuid = string.lower(uuid)

    local storyboard = Ponder.API.RegisteredStoryboards[uuid]
    if not storyboard then return Ponder.Print("Unknown storyboard '" .. uuid .. "'") end

    if not IsValid(Ponder.UIWindow) then
        Ponder.UIWindow = vgui.Create("Ponder.UI")
    end

    local UI = Ponder.UIWindow
    UI:PonderShow()
    UI:LoadStoryboard(uuid)
end

function Ponder.OpenIndex()
    if not IsValid(Ponder.UIWindow) then
        Ponder.UIWindow = vgui.Create("Ponder.UI")
    else
        Ponder.UIWindow:Remove()
    end

    local UI = Ponder.UIWindow
    UI:LoadIndex()
end