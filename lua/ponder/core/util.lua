if CLIENT then
    surface.CreateFont("Ponder.Title", {
        font = "Tahoma",
        extended = false,
        size = 24,
        weight = 100,
        antialias = true
    })

    surface.CreateFont("Ponder.Subtitle", {
        font = "Tahoma",
        extended = false,
        size = 38,
        weight = 100,
        antialias = true
    })

    surface.CreateFont("Ponder.BigText", {
        font = "Tahoma",
        extended = false,
        size = 60,
        weight = 100,
        antialias = true
    })

    surface.CreateFont("Ponder.Text", {
        font = "Arial",
        extended = false,
        size = 20,
        weight = 900,
        antialias = true
    })
end
function Ponder.IsStringNilOrEmpty(s) return s == nil or #string.Trim(s) == 0 end