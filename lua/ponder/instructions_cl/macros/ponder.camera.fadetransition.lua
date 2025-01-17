local FadeLookAtCameraTransition = Ponder.API.NewInstructionMacro("FadeLookAtCameraTransition")

function FadeLookAtCameraTransition:Run(chapter, parameters)
    local time       = parameters.Time or 0
    local length     = parameters.Length or 1
    local easeIn     = parameters.EaseIn
    local easeOut    = parameters.EaseOut
    local target     = parameters.Target
    local distance   = parameters.Distance
    local angle      = parameters.Angle
    local height     = parameters.Height
    --[[
        Valid options:
            - None (no delay created, idk why you'd need this though)
            - OnTransition (delay created after fadecameraout ends, so Length / 2)
            - AfterFade (delay created after FadeCameraIn, so just Length)
    ]]
    local whereDelay = parameters.DelayBehavior or "OnTransition"

    chapter:AddInstruction("FadeCameraOut", {Time = time, Length = length / 2, Easing = easeOut})
    chapter:AddInstruction("MoveCameraLookAt", {
        Time = time + (length / 2),
        Length = 0,
        Target = target,
        Distance = distance,
        Angle = angle,
        Height = height
    })

    if whereDelay == "OnTransition" then
        chapter:AddInstruction("Delay", {Time = time, Length = length / 2})
        chapter:AddInstruction("FadeCameraIn", {Time = time, Length = length / 2, Easing = easeIn})
    elseif whereDelay == "AfterFade" then
        chapter:AddInstruction("FadeCameraIn", {Time = time + (length / 2), Length = length / 2, Easing = easeIn})
        chapter:AddInstruction("Delay", {Length = length})
    end
end