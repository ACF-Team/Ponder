local MultiParent = Ponder.API.NewInstructionMacro("MultiParent")

function MultiParent:Run(chapter, parameters)
    local length = parameters.Length or 1
    local timeForEachClick = length / (#parameters.Children + 1)

    local tAdd = 0
    for _, child in ipairs(parameters.Children) do
        chapter:AddInstruction("MoveToolgunTo", {Time = tAdd, Target = child, Easing = parameters.Easing})
        tAdd = tAdd + timeForEachClick
        chapter:AddInstruction("ClickToolgun", {Time = tAdd, Target = child})
        chapter:AddInstruction("ColorModel", {Time = tAdd, Target = child, Length = 0.1, Color = Color(100, 255, 100, 190)})
    end

    chapter:AddInstruction("MoveToolgunTo", {Time = tAdd, Target = parameters.Parent, Easing = parameters.Easing})
    chapter:AddInstruction("ClickToolgun", {Time = tAdd + timeForEachClick, Target = parameters.Parent})
    for _, child in ipairs(parameters.Children) do
        chapter:AddInstruction("ColorModel", {Time = tAdd + timeForEachClick, Target = child, Length = 0.1, Color = Color(255, 255, 255, 255)})
    end

    return tAdd + timeForEachClick
end