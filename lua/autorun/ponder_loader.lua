include("includes/gloader.lua")
gloader.Load("Ponder", "ponder")

Ponder.Debug = true
if SERVER then
    -- resource.AddFile("materials/ponder/ui/toolgun_cursor64.png")
    resource.AddFile("materials/ponder/ui/toolgun_cursor96.png")
    -- resource.AddFile("materials/ponder/ui/toolgun_cursor128.png")
    -- resource.AddFile("materials/ponder/ui/toolgun_cursor192.png")
    resource.AddFile("materials/ponder/ui/icon16/play.png")
    resource.AddFile("materials/ponder/ui/icon16/stop.png")
end