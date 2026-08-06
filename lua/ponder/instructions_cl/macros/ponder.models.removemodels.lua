local RemoveModels = Ponder.API.NewInstructionMacro("RemoveModels")

function RemoveModels:Run(chapter, parameters)
    local length = parameters.Length or 1
    local timeForEachClick = length / (#parameters.Models + 1)

    local Models = table.Reverse(parameters.Models)
    local tAdd = 0

    for _, data in ipairs(Models) do
        chapter:AddInstruction("RemoveModel", {Time = tAdd, Name = data.Name})
        tAdd = tAdd + timeForEachClick
    end

    return tAdd + timeForEachClick
end