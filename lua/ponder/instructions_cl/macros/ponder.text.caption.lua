local CaptionIndex = 0 -- Systime as UUID? lol...
local Caption = Ponder.API.NewInstructionMacro("Caption")

function Caption:Run(chapter, parameters)
    local FadeInOutTime = parameters.FadeInOutTime or 0.5
    local WPM = parameters.WPM or 200
    local TextLength = parameters.TextLength or #string.Explode(" ", parameters.Text) / WPM * 60

    local UseEntity = parameters.UseEntity or false

    CaptionIndex = CaptionIndex + 1
    local Name = parameters.Name or "Caption" .. CaptionIndex
    local tAdd = 0

    chapter:AddInstruction("ShowText", {
        Time = parameters.Time or tAdd,
        Length = FadeInOutTime,
        Name = Name,
        Dimension = not UseEntity and "2D" or "3D",
        Text = parameters.Text,
        Horizontal = parameters.Horizontal or TEXT_ALIGN_CENTER,
        PositionRelativeToScreen = not UseEntity and true or false,
        Position = parameters.Position or Vector(0.5, 0.15, 0),
        ParentTo = parameters.ParentTo or nil,
    })

    tAdd = tAdd + FadeInOutTime + TextLength

    if not parameters.KeepText then
        chapter:AddInstruction("HideText", {
            Time = tAdd,
            Length = FadeInOutTime,
            Name = Name,
        })

        tAdd = tAdd + FadeInOutTime
    end

    return tAdd, Name
end