function Ponder.SimpleClass()
    return setmetatable({}, {__call = function(self, ...)
        local obj = setmetatable({}, {__index = self, __tostring = self.ToString})
        if self.__new then self.__new(obj, ...) end
        return obj
    end})
end

function Ponder.InheritedClass(baseclass)
    return setmetatable({}, {__index = baseclass, __call = function(self, ...)
        local obj = setmetatable({}, {__index = self, __tostring = self.ToString})
        if self.__new then self.__new(obj, ...) end
        return obj
    end})
end

function Ponder.IsTypeOf(object, type)
    return getmetatable(object).__index == type
end