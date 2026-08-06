local FlashModel = Ponder.API.NewInstructionMacro("FlashModel")

function FlashModel:Run(chapter, parameters)
    local length = parameters.Length or 1
    local reps = parameters.Reps or 1
    local lengthPerRep = length / reps

    local fillColor = parameters.FillColor or Color(0, 0, 255, 255)
    local clearColor = parameters.ClearColor or Color(255, 255, 255, 255)

    local tAdd = 0

    for _ = 1, reps do
        for _, model in ipairs(parameters.Models) do
            chapter:AddInstruction("ColorModel", {Time = tAdd, Target = model, Length = lengthPerRep / 2, Color = fillColor})
        end

        tAdd = tAdd + lengthPerRep / 2

        for _, model in ipairs(parameters.Models) do
            chapter:AddInstruction("ColorModel", {Time = tAdd, Target = model, Length = lengthPerRep / 2, Color = clearColor})
        end

        tAdd = tAdd + lengthPerRep / 2
    end

    return tAdd + length / 2
end