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

list.Set("DesktopWindows", "Ponder", {
    title	= "Ponder",
    icon	= "materials/ponder/ui/icon64/magnifier.png",
    width	= 520,
    height	= 700,
    init	= function(_, window)
        window:Remove()
        RunConsoleCommand("ponder_index")
    end
})