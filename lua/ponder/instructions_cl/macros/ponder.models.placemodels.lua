local PlaceModels = Ponder.API.NewInstructionMacro("PlaceModels")

function PlaceModels:Run(chapter, parameters)
    local length = parameters.Length or 1
    local timeForEachClick = length / (#parameters.Models + 1)

    local tAdd = 0

    for _, data in ipairs(parameters.Models) do
        chapter:AddInstruction("PlaceModel", {
            Time = tAdd,
            Name = data.Name,
            IdentifyAs = data.IdentifyAs,
            Model = data.Model,
            Angles = data.Angles,
            Position = data.Position,
            ComeFrom = data.ComeFrom,
            Scale = data.Scale,
            ParentTo = data.ParentTo or nil,
        })

        if data.Material then
            chapter:AddInstruction("MaterialModel", {Time = tAdd, Target = data.Name, Material = data.Material})
        end

        tAdd = tAdd + timeForEachClick
    end

    return tAdd + timeForEachClick
end