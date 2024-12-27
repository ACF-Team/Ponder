Ponder.InstructionMacro = Ponder.SimpleClass()

function Ponder.InstructionMacro:__new() end

function Ponder.InstructionMacro:ToString()
    return "Ponder Instruction Macro"
end

function Ponder.InstructionMacro:Run(chapter, parameters) chapter = chapter parameters = parameters end