local MeshObject = Ponder.API.NewNamedObjectType("Mesh")

-- The environment expects named objects to answer IsValid and Remove, like panels do.
-- Meshes built from Triangles are owned by Ponder and destroyed on removal; a supplied IMesh is left alone.
function MeshObject.Initialize(_, _, data)
    local mesh = data.Mesh
    local owned = false

    if not mesh then
        mesh = Mesh()
        mesh:BuildFromTriangles(data.Triangles)
        owned = true
    end

    data.Mesh      = mesh
    data.IsValid   = function() return true end
    data.Remove    = function()
        if owned and IsValid(mesh) then mesh:Destroy() end
    end

    return data
end

local MeshRenderer = Ponder.API.NewRenderer("MeshRenderer")

function MeshRenderer:Render3D(env)
    local alpha = env.Opacity

    for _, m in ipairs(env:GetAllNamedObjects("Mesh")) do
        local color = m.Color
        local blend = (color.a / 255) * m.Alpha * alpha

        local matrix = Matrix()
        matrix:SetTranslation(m.Position)
        matrix:SetAngles(m.Angles)
        matrix:SetScale(m.Scale)

        -- render.SetColorModulation/SetBlend don't affect IMesh draws, so the material is tinted for the draw instead
        local mat = m.Material
        local oldColor, oldAlpha = mat:GetVector("$color2"), mat:GetFloat("$alpha")

        mat:SetVector("$color2", Vector(color.r / 255, color.g / 255, color.b / 255))
        mat:SetFloat("$alpha", blend)

        render.SetMaterial(mat)

        cam.PushModelMatrix(matrix)
            m.Mesh:Draw()
        cam.PopModelMatrix()

        if m.Outline and m.Triangles then
            local lineColor = Color(m.Outline.r, m.Outline.g, m.Outline.b, m.Outline.a * m.Alpha * alpha)
            for i = 1, #m.Triangles - 2, 3 do
                local a, b, c = matrix * m.Triangles[i].pos, matrix * m.Triangles[i + 1].pos, matrix * m.Triangles[i + 2].pos
                render.DrawLine(a, b, lineColor, false)
                render.DrawLine(b, c, lineColor, false)
                render.DrawLine(c, a, lineColor, false)
            end
        end

        mat:SetVector("$color2", oldColor)
        mat:SetFloat("$alpha", oldAlpha)
    end
end

local PlaceMesh = Ponder.API.NewInstruction("PlaceMesh")
PlaceMesh.Name      = ""
PlaceMesh.Mesh      = nil -- An existing IMesh to draw. Takes priority over Triangles
PlaceMesh.Triangles = nil -- A table of MeshVertex structs, three per triangle. Used with IMesh:BuildFromTriangles
PlaceMesh.Material  = Material("models/wireframe")
PlaceMesh.Position  = Vector(0, 0, 0)
PlaceMesh.Angles    = Angle(0, 0, 0)
PlaceMesh.Scale     = Vector(1, 1, 1)
PlaceMesh.Color     = Color(255, 255, 255, 255)
PlaceMesh.Outline   = nil -- A color to also draw every triangle edge in.
PlaceMesh.Length    = .5

-- Renames the old mesh to an "outgoing" name so it can fade out while the new mesh fades in.
local function OutgoingName(name) return name .. "\0outgoing" end

function PlaceMesh:First(playback)
    local env = playback.Environment
    if not self.Mesh and not self.Triangles then return Ponder.Print("PlaceMesh needs a Mesh or Triangles") end

    local old = env:GetNamedObject("Mesh", self.Name)
    if old then
        local list = env.CustomNamedLists.Mesh
        env:RemoveNamedObjectByName("Mesh", OutgoingName(self.Name))
        list:RemoveByName(self.Name)
        list:Add(old, OutgoingName(self.Name))
    end

    env:NewNamedObject("Mesh", self.Name, {
        Mesh      = self.Mesh,
        Triangles = self.Triangles,
        Material  = self.Material,
        Position  = self.Position,
        Angles    = self.Angles,
        Scale     = self.Scale,
        Color     = self.Color,
        Outline   = self.Outline,
        Alpha     = 0,
    })
end

function PlaceMesh:Update(playback)
    local progress = playback:GetInstructionProgress(self)
    progress = self.Easing and self.Easing(progress) or progress

    local mesh = playback.Environment:GetNamedObject("Mesh", self.Name)
    if mesh then mesh.Alpha = progress end

    local outgoing = playback.Environment:GetNamedObject("Mesh", OutgoingName(self.Name))
    if outgoing then outgoing.Alpha = 1 - progress end
end

function PlaceMesh:Last(playback)
    local mesh = playback.Environment:GetNamedObject("Mesh", self.Name)
    if mesh then mesh.Alpha = 1 end

    playback.Environment:RemoveNamedObjectByName("Mesh", OutgoingName(self.Name))
end

local RemoveMesh = Ponder.API.NewInstruction("RemoveMesh")
RemoveMesh.Name   = ""
RemoveMesh.Length = .5

function RemoveMesh:Update(playback)
    local progress = playback:GetInstructionProgress(self)
    progress = self.Easing and self.Easing(progress) or progress

    local mesh = playback.Environment:GetNamedObject("Mesh", self.Name)
    if mesh then mesh.Alpha = 1 - progress end
end

function RemoveMesh:Last(playback)
    playback.Environment:RemoveNamedObjectByName("Mesh", self.Name)
end

--[[ Example:
    Chapter:AddInstruction("PlaceMesh", {
        Name = "pyramid",
        Material = Material("models/debug/debugwhite"),
        Position = Vector(0, 0, 10),
        Triangles = {
            {pos = Vector(-20, -20, 0), u = 0, v = 0}, {pos = Vector(20, -20, 0), u = 1, v = 0}, {pos = Vector(0, 0, 40), u = 0.5, v = 1},
        },
    })
    Chapter:AddInstruction("RemoveMesh", {Name = "pyramid"})
]]
