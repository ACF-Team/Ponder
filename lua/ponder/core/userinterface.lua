hook.Add("PopulateMenuBar", "Ponder.PopulateMenuBar.InsertMenuOption", function(menubar)
    local b = menubar:Add("DButton")
    b:SetText(language.GetPhrase("ponder"))
    b:Dock(LEFT)
    b:DockMargin(5, 0, 0, 0)
    b:SetIsMenu(true)
    b:SetPaintBackground(false)
    b:SizeToContentsX(16)

    function b:DoClick()
        if IsValid(Ponder.UIWindow) then
            Ponder.UIWindow:PonderShow()
        else
            Ponder.OpenIndex()
        end
    end
end)