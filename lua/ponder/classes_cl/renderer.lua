Ponder.Renderer = Ponder.SimpleClass()

function Ponder.Renderer:__new() end

function Ponder.Renderer:ToString()
    return "Ponder Renderer"
end

function Ponder.Renderer:Initialize(env)    env = env end
function Ponder.Renderer:Update(env)   env = env end
function Ponder.Renderer:Render3D(env) env = env end
function Ponder.Renderer:Render2D(env) env = env end