local RecommendStoryboard = Ponder.API.NewInstructionMacro("RecommendStoryboard")

function RecommendStoryboard:Run(chapter, parameters)
    local time            = parameters.Time or 0
    local length          = parameters.Length or 1
    local easing          = parameters.Easing
    local storyboard_tg   = parameters.Storyboard
    local posX            = parameters.X
    local posY            = parameters.Y
    local posRel          = parameters.PositionRelativeToScreen

    if posX == nil and posY == nil and posRel == nil then
        posX = 0.5
        posY = 0.75
        posRel = true
    end

    if posRel then
        posX = posX * ScrW()
        posY = posY * ScrH()
    end

    local id = chapter.Storyboard.Ponder_RecommendationID or 0
    chapter.Storyboard.Ponder_RecommendationID = id + 1

    chapter:AddInstruction("PlacePanel", {
        Name = "PonderRecommendation_" .. id,
        Type = "Ponder.OpenStoryboard",
        Easing = easing,
        Length = length,
        Time = time,
        Calls = {
            {Method = "SetSize", Args = {256, 64}},
            {Method = "SetPos", Args = {posX, posY}},
            {Method = "SetStoryboard", Args = {storyboard_tg}},
            {Method = "MakePopup", Args = {}}
        }
    })
end