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
        local retObj = self.Named[name]
        table.RemoveByValue(self.List, self.Named[name])
        self.Named[name] = nil

        return retObj
    end

    function ret:Clear(foreach)
        if foreach then
            for _, v in ipairs(self.List) do foreach(v) end
        end
        table.Empty(self.List)
        table.Empty(self.Named)
    end

    return ret
end

function Ponder.Environment:__new()
    self.ClientsideModels = NamedList()
    self.NamedTextObjects = NamedList()
    self.SoundPatches     = {}
    self.ModelHalos       = {}
    self.HalosToRemove    = {}

    self.CustomNamedLists = {}
    for k in pairs(Ponder.API.GetNamedObjectImplementors()) do
        self.CustomNamedLists[k] = NamedList()
    end

    self.Opacity = 1
    self:SetLookParams(1300, 55, 600, vector_origin)
end

function Ponder.Environment:NewNamedObject(listname, name, ...)
    local list = self.CustomNamedLists[listname]
    if not list then return ErrorNoHaltWithStack("Ponder.Environment: No NamedList with the name '" .. listname .. "'") end

    if list:Find(name) then
        local obj = list:RemoveByName(name)
        if IsValid(obj) then obj:Remove() end
    end

    local obj = Ponder.API.GetNamedObjectImplementors()[listname].Initialize(self, name, ...)

    list:Add(obj, name)
    return obj
end

function Ponder.Environment:GetNamedObject(listname, objName)
    local list = self.CustomNamedLists[listname]
    if not list then return ErrorNoHaltWithStack("Ponder.Environment: No NamedList with the name '" .. listname .. "'") end

    return list:Find(objName)
end

function Ponder.Environment:GetAllNamedObjects(listname)
    local list = self.CustomNamedLists[listname]
    if not list then return ErrorNoHaltWithStack("Ponder.Environment: No NamedList with the name '" .. listname .. "'") end

    return list.List
end

function Ponder.Environment:CreateSound(...)
    local soundPatch = CreateSound(...)
    self.SoundPatches[#self.SoundPatches + 1] = soundPatch
    return soundPatch
end

function Ponder.Environment:RemoveNamedObject(listname, object)
    local list = self.CustomNamedLists[listname]
    if not list then return ErrorNoHaltWithStack("Ponder.Environment: No NamedList with the name '" .. listname .. "'") end

    local obj = list:RemoveByValue(object)
    if IsValid(obj) then obj:Remove() end
end

function Ponder.Environment:RemoveNamedObjectByName(listname, objName)
    local list = self.CustomNamedLists[listname]
    if not list then return ErrorNoHaltWithStack("Ponder.Environment: No NamedList with the name '" .. listname .. "'") end
    local obj = list:Find(objName)
    if not IsValid(obj) then return end

    list:RemoveByName(objName):Remove()
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
    self:SetLookAt(lookAt)
    self:SetCameraFOV(15)
end

function Ponder.Environment:NewModel(mdl, name, dontSpawn)
    if self.ClientsideModels:Find(name) then
        local ent = self.ClientsideModels:RemoveByName(name)
        if IsValid(ent) then ent:Remove() end
    end

    local csModel = ClientsideModel(mdl)

    if dontSpawn ~= true then
        csModel:SetPos(vector_origin)
        csModel:Spawn()
    end

    csModel.IsPonderEntity = true
    csModel:SetNoDraw(true)
    csModel.Name = name

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

function Ponder.Environment:Halt()
    for _, v in pairs(self.CustomNamedLists) do
        for _, o in ipairs(v.List) do
            if o.Ponder_OnHalt then
                o:Ponder_OnHalt(self)
            end
        end
    end
end

function Ponder.Environment:Continue()
    for _, v in pairs(self.CustomNamedLists) do
        for _, o in ipairs(v.List) do
            if o.Ponder_OnContinue then
                o:Ponder_OnContinue(self)
            end
        end
    end
end

function Ponder.Environment:Free()
    for _, v in ipairs(self.SoundPatches) do v:Stop() end
    for _, v in ipairs(self.ClientsideModels.List) do v:Remove() end

    self.ClientsideModels:Clear()
    self.NamedTextObjects:Clear()
    table.Empty(self.SoundPatches)

    for _, v in pairs(self.CustomNamedLists) do
        v:Clear(function(x) x:Remove() end)
    end
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

function Ponder.Environment:BuildCamera()
    local __MinimizeState = Ponder.__MinimizeState
    self.Camera = {
        x = __MinimizeState and __MinimizeState.X or 0,
        y = __MinimizeState and __MinimizeState.Y or 0,
        w = __MinimizeState and __MinimizeState.W or ScrW(),
        h = __MinimizeState and __MinimizeState.H or ScrH(),
        type = "3D",
        origin = self.CameraPosition,
        angles = self.CameraAngles,
        fov = self.CameraFOV
    }
end

function Ponder.Environment:AimVector()
    local mX, mY = input.GetCursorPos()
    local mV = util.AimVector(self.Camera.angles, self.Camera.fov, mX, mY, ScrW(), ScrH())
    return mV
end
function Ponder.Environment:AimEntity()
    local pos = self.Camera.origin
    local dir = self:AimVector()
    local stop = pos + (dir * 10000)

    local ret
    local dist = 1000000000

    for _, v in ipairs(self.ClientsideModels.List) do
        local bMI, bMA = v:GetRenderBounds()
        --render.DrawWireframeBox(v:GetPos(), v:GetAngles(), bMI, bMA)
        local test = util.IntersectRayWithOBB(pos, stop, v:GetPos(), v:GetAngles(), bMI, bMA)
        if test then
            local testDist = test:Distance(pos)
            if testDist < dist then
                dist = testDist
                ret = v
            end
        end
    end

    return ret
end

local matCopy = Material("pp/copy")
local matAdd  = Material("pp/add")
local matSub  = Material("pp/sub")
local rtStore = render.GetScreenEffectTexture(0)
local rtBlur  = render.GetScreenEffectTexture(1)

-- Adapted from the base game's halo library for our purposes
function Ponder.Environment:RenderHalo(model, haloData)
    -- Don't draw while minimizing/maximizing
    -- This prevents a temporary flashbang if you happened to pause while a halo is in use
    if Ponder.__MinimizeState then return end

    local camera = self.Camera
    local haloColor = haloData.Color
    cam.Start2D()

    local rtScene = render.GetRenderTarget()

    -- Store a copy of the original scene
    render.CopyRenderTargetToTexture(rtStore)

    -- Clear our scene so that additive/subtractive rendering with it will work later
    if haloData.Additive then
        render.Clear(0, 0, 0, 255, false, true)
    else
        render.Clear(255, 255, 255, 255, false, true)
    end

    -- For certain materials this is necessary to not have the entire screen go pitch black
    -- For example the glass doors in Episode 2 GMan sequence
    render.UpdateRefractTexture()

    -- Render colored props to the scene and set their pixels high
    cam.Start(camera)
        render.SetStencilEnable(true)
            render.SuppressEngineLighting(true)
            cam.IgnoreZ(haloData.IgnoreZ)

                render.SetStencilWriteMask(1)
                render.SetStencilTestMask(1)
                render.SetStencilReferenceValue(1)

                render.SetStencilCompareFunction(STENCIL_ALWAYS)
                render.SetStencilPassOperation(STENCIL_REPLACE)
                render.SetStencilFailOperation(STENCIL_KEEP)
                render.SetStencilZFailOperation(STENCIL_KEEP)

                model:DrawModel()

                render.SetStencilCompareFunction(STENCIL_EQUAL)
                render.SetStencilPassOperation(STENCIL_KEEP)

                cam.Start2D()
                    surface.SetDrawColor(haloColor)
                    surface.DrawRect(0, 0, camera.w, camera.h)
                cam.End2D()

            cam.IgnoreZ(false)
            render.SuppressEngineLighting(false)
        render.SetStencilEnable(false)
    cam.End3D()

    -- Store a blurred version of the colored props in an RT
    render.CopyRenderTargetToTexture(rtBlur)
    render.BlurRenderTarget(rtBlur, haloData.BlurX, haloData.BlurY, 1)

    -- Restore the original scene
    render.SetRenderTarget(rtScene)
    matCopy:SetTexture("$basetexture", rtStore)
    matCopy:SetString("$color", "1 1 1")
    matCopy:SetString("$alpha", "1")
    render.SetMaterial(matCopy)
    render.DrawScreenQuad()

    -- Draw back our blurred colored props additively/subtractively, ignoring the high bits
    render.SetStencilEnable(true)

        render.SetStencilCompareFunction(STENCIL_NOTEQUAL)

        if haloData.Additive then
            matAdd:SetTexture("$basetexture", rtBlur)
            render.SetMaterial(matAdd)
        else
            matSub:SetTexture("$basetexture", rtBlur)
            render.SetMaterial(matSub)
        end

        for _ = 0, haloData.DrawPasses do
            render.DrawScreenQuad()
        end

    render.SetStencilEnable(false)

    -- Return original values
    render.SetStencilTestMask(0)
    render.SetStencilWriteMask(0)
    render.SetStencilReferenceValue(0)

    cam.End2D()
end

local magnifier = Material("ponder/ui/icon64/magnifier_no_back.png", "mips smooth")

function Ponder.Environment:Render()
    self:BuildCamera()

    cam.Start(self.Camera)

    self.Rendering3D = true
    if self.Fullbright then
        render.SuppressEngineLighting(true)
    end
    self.AimedEntity = self:AimEntity()
    local envOpacity = self.Opacity

    for _, v in ipairs(self.NamedTextObjects.List) do v:ResolvePos2D() end
    for _, v in ipairs(self.ClientsideModels.List) do
        local c = v:GetColor()
        local aOverride = v.PONDER_AlphaOverride or 1
        local blend = (c.a / 255) * aOverride * envOpacity

        render.SetColorModulation(c.r / 255, c.g / 255, c.b / 255)
        if blend < 1 then
            render.OverrideColorWriteEnable(true, false)
            v:DrawModel()
            render.OverrideColorWriteEnable(false, false)
            render.SetBlend(blend)
            v:DrawModel()
            render.SetBlend(1)
        else
            v:DrawModel()
        end
        render.SetColorModulation(1, 1, 1)

        local haloData = v.PONDER_HALO_DATA

        if haloData then
            self:RenderHalo(v, haloData)
        end
    end
    for _, v in pairs(Ponder.API.RegisteredRenderers) do if v.Render3D then v:Render3D(self) end end
    if self.Render3D then self:Render3D() end

    render.SuppressEngineLighting(false)
    self.Rendering3D = false
    cam.End()

    self.Rendering2D = true

    for _, v in ipairs(self.NamedTextObjects.List) do
        if not v.RenderOnTopOfRenderers then v:Render() end
    end

    for _, v in pairs(Ponder.API.RegisteredRenderers) do if v.Render2D then v:Render2D(self) end end
    if self.Render2D then self:Render2D() end

    for _, v in ipairs(self.NamedTextObjects.List) do
        if v.RenderOnTopOfRenderers then v:Render() end
    end

    if self.Identifying then
        local mX, mY = input.GetCursorPos()
        surface.SetMaterial(magnifier)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(mX + 8, mY + 9, 64, 64, 0)

        if self.AimedEntity then
            mX = mX + 32

            local mkup = markup.Parse(self.AimedEntity.IdentifyMarkup and self.AimedEntity.IdentifyMarkup or ("<font=Ponder.Text><colour=25,25,25,255>" .. (self.AimedEntity.IdentifyAs or self.AimedEntity.Name) .. "</colour></font>")) -- I don't feel like caching this right now...
            surface.SetFont("Ponder.Text")
            local w, h = mkup:Size()
            local p = 8
            surface.SetDrawColor(245, 245, 245, 220)
            surface.DrawRect(mX - p, mY - p, w + (p * 2), h + (p * 2))
            surface.SetDrawColor(25, 25, 25, 255)
            surface.DrawOutlinedRect(mX - p, mY - p, w + (p * 2), h + (p * 2))
            mkup:Draw(mX + (w / 2), mY + (h / 2), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    self.Rendering2D = false
end