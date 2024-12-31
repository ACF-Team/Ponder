include("includes/gloader.lua")
gloader.Load("Ponder", "ponder")

Ponder.Debug = false
if SERVER then
    -- resource.AddFile("materials/ponder/ui/toolgun_cursor64.png")
    resource.AddFile("materials/ponder/ui/toolgun_cursor96.png")
    -- resource.AddFile("materials/ponder/ui/toolgun_cursor128.png")
    -- resource.AddFile("materials/ponder/ui/toolgun_cursor192.png")
    resource.AddFile("materials/ponder/ui/icon64/play.png")
    resource.AddFile("materials/ponder/ui/icon64/stop.png")
    resource.AddFile("materials/ponder/ui/icon64/replay.png")
    resource.AddFile("materials/ponder/ui/icon64/fast.png")
    resource.AddFile("materials/ponder/ui/icon64/magnifier.png")
    resource.AddFile("materials/ponder/ui/icon64/magnifier_enabled.png")
    resource.AddFile("materials/ponder/ui/icon64/magnifier_no_back.png")
    resource.AddFile("materials/ponder/ui/icon128/back.png")
    resource.AddFile("materials/ponder/ui/progress/bar.png")
    resource.AddFile("materials/ponder/ui/progress/grabby.png")
    resource.AddFile("materials/ponder/ui/progress/left.png")
    resource.AddFile("materials/ponder/ui/progress/right.png")
    resource.AddFile("materials/ponder/ui/progress/stretchy.png")
end