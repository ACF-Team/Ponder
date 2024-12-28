local MoveToolgunTo = Ponder.API.NewInstruction("MoveToolgunTo")
MoveToolgunTo.Length = 0.5
MoveToolgunTo.Position = Vector(0, 0, 0)

local function GetToolgunPos(playback, target, pos)
    if isstring(target) then
        return playback.Environment:GetNamedModel(target):LocalToWorld(pos)
    elseif target == nil then
        return pos
    end
end

function MoveToolgunTo:First(playback)
    local env = playback.Environment
    local state = env.ToolgunState
    if not state then return end

    if self.Length == 0 then
        state.Position = GetToolgunPos(playback, self.Target, self.Position)
        return
    end

    state.LerpingPosition = true
    state.StartPos  = state.Position
    state.Target    = self.Target
    state.TargetPos = self.Position
end

function MoveToolgunTo:Update(playback)
    local env = playback.Environment
    local state = env.ToolgunState
    if not state then return end

    if state.LerpingPosition then
        local progress = playback:GetInstructionProgress(self)
        progress = self.Easing and self.Easing(progress) or progress
        state.Position = LerpVector(progress, state.StartPos, GetToolgunPos(playback, state.Target, state.TargetPos))
    end
end

function MoveToolgunTo:Last(playback)
    local env = playback.Environment
    local state = env.ToolgunState

    state.LerpingPosition = false
end