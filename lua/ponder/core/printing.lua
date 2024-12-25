local COLOR_Bracket = Color(215, 215, 215)
local COLOR_Ponder  = Color(100, 140, 240)
local COLOR_Text    = Color(230, 230, 230)

function Ponder.Print(...)
    MsgC(COLOR_Bracket, "[", COLOR_Ponder, "Ponder", COLOR_Bracket, "]: ", COLOR_Text, ..., "\n")
end