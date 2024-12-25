Ponder.Environment = Ponder.SimpleClass()

local function NamedList()
    local ret = {}

    ret.Named = {}
    ret.List  = {}

    function ret:Add(item, name)
        if self:Find(name) then self:RemoveByName(name) end

        self.List[#self.List + 1] = item
        self.Named[name] = item
    end

    function ret:Find(name) return self.Named[name] end

    function ret:RemoveByValue(value)
        table.RemoveByValue(self.List, value)
        table.RemoveByValue(self.Named, value)
        return value
    end

    function ret:RemoveByName(name)
        table.RemoveByValue(self.List, name)
        local retObj = self.Named[name]
        self.Named[name] = nil

        return retObj
    end

    function ret:Clear()
        table.Empty(self.List)
        table.Empty(self.Named)
    end

    return ret
end

function Ponder.Environment:__new()
    self.ClientsideModels = NamedList()
    self.NamedTextObjects = NamedList()

    self:SetLookParams(1300, 55, 600, vector_origin)

    local grid = self:NewModel("models/hunter/blocks/cube150x150x025.mdl", "GRID")
    grid:SetPos(Vector(0, 0, -5.9))
end

function Ponder.Environment:GetCameraPosAng()
    return self.CameraPosition, self.CameraAngles
end

function Ponder.Environment:LookParamsToPosAng(camDist, rotation, height, lookAt)
    local rads = math.rad(rotation)
    local s, c = math.sin(rads) * camDist, math.cos(rads) * camDist
    local campos = Vector(s, c, height)
    local camang = (lookAt - campos):Angle()

    return campos, camang
end

function Ponder.Environment:SetLookParams(camDist, rotation, height, lookAt)
    local rads = math.rad(rotation)
    local s, c = math.sin(rads) * camDist, math.cos(rads) * camDist
    self:SetCameraPosition(Vector(s, c, height))
    self:SetLookAt(Vector(0, 0, 0))
    self:SetCameraFOV(15)
end

function Ponder.Environment:NewModel(mdl, name)
    local csModel = ClientsideModel(mdl)
    csModel:SetPos(vector_origin)
    csModel:Spawn()
    self.ClientsideModels:Add(csModel, name)
    return csModel
end
function Ponder.Environment:GetNamedModel(name) return self.ClientsideModels:Find(name) end
function Ponder.Environment:RemoveModel(model) self.ClientsideModels:RemoveByValue(model):Remove() end
function Ponder.Environment:RemoveModelByName(name)
    local csModel = self.ClientsideModels:Find(name)
    if not IsValid(csModel) then return end

    self.ClientsideModels:RemoveByName(name):Remove()
end

function Ponder.Environment:NewText(name)
    local csModel = Ponder.TextObject()
    self.NamedTextObjects:Add(csModel, name)
    return csModel
end
function Ponder.Environment:GetNamedText(name) return self.NamedTextObjects:Find(name) end
function Ponder.Environment:RemoveText(model) self.NamedTextObjects:RemoveByValue(model) end
function Ponder.Environment:RemoveTextByName(name)
    local txtObj = self.NamedTextObjects:Find(name)
    if not txtObj then return end

    self.NamedTextObjects:RemoveByName(name)
end

function Ponder.Environment:Free()
    for _, v in ipairs(self.ClientsideModels.List) do v:Remove() end
    self.ClientsideModels:Clear()
    self.NamedTextObjects:Clear()
end

function Ponder.Environment:SetCameraPosition(vPos)
    self.CameraPosition = vPos
end

function Ponder.Environment:SetCameraAngles(aAng)
    self.CameraAngles = aAng
end

function Ponder.Environment:SetLookAt(vLookat)
    self.LastLookat = vLookat
    self.CameraAngles = (vLookat - self.CameraPosition):Angle()
end

function Ponder.Environment:ToString()
    return "Ponder Environment"
end

function Ponder.Environment:SetCameraFOV(nFOV)
    self.CameraFOV = nFOV
end

function Ponder.Environment:Render(x, y, w, h)
    --[[local ct = CurTime() * 1
    local r = 1200
    local s, c = math.sin(ct) * r, math.cos(ct) * r
    self:SetCameraPosition(Vector(s, c, r * .2))
    self:SetLookAt(Vector(0, 0, 0))
    self:SetCameraFOV(15)]]

    self.Camera = {
        x = 0,
        y = 0,
        w = ScrW(),
        h = ScrH(),
        type = "3D",
        origin = self.CameraPosition,
        angles = self.CameraAngles,
        fov = self.CameraFOV
    }

    cam.Start(self.Camera)
    for _, v in ipairs(self.NamedTextObjects.List) do
        v:ResolvePos2D()
    end

    for _, v in ipairs(self.ClientsideModels.List) do
        v:DrawModel()
    end


    cam.End()
    for _, v in ipairs(self.NamedTextObjects.List) do
        v:Render()
    end
    -- surface.SetDrawColor(255,255,255,255)
    -- surface.DrawOutlinedRect(rX, rY, w, h, 2)
end