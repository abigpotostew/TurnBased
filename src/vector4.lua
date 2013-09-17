--Simple vector4 class

local class = require "src.class"
local util = require "src.util"

local Vector4 = class:makeSubclass("Vector4")

local function isVector4Equivalent(obj)
	return (type(obj) == "table" and 
            type(obj.x) == "number" and 
            type(obj.y) == "number" and 
            type(obj.z) == "number" and 
            type(obj.w) == "number")
end

Vector4:makeInit(function(class, self, ...)
	class.super:initWith(self)

	if (#arg == 0) then
        self.x = 0
        self.y = 0
        self.z = 0
        self.w = 0
	elseif (#arg == 1) then
		local other = arg[1]
		assert(isVector4Equivalent(other), "The Vector4 single argument constructor takes a table with an x, y, z, & w property")
		self.x = other.x
		self.y = other.y
        self.z = other.z
        self.w = other.w
	elseif (#arg == 3) then
		self.x = arg[1]
		self.y = arg[2]
        self.z = arg[3]
        self.w = 0
    elseif (#arg == 4) then
		self.x = arg[1]
		self.y = arg[2]
        self.z = arg[3]
        self.w = arg[4]
	else
		error("The Vector4 constructor takes zero, one, three, or four arguments")
	end

	return self

end)

Vector4:setMeta("add", function(a, b)
	if (isVector4Equivalent(a) and isVector4Equivalent(b)) then
		return Vector4:init(a.x+b.x, a.y+b.y, a.z+b.z, a.w+b.w)
	else
		if (Vector4:isAncestorOf(a)) then
			error("Cannot add dissimilar object of type " .. type(b) .. " to Vector4")
		else
			error("Cannot add Vector4 to dissimilar object of type " .. type(a))
		end
	end
end)

Vector4:setMeta("sub", function(a, b)
	if (isVector4Equivalent(a) and isVector4Equivalent(b)) then
		return Vector4:init(a.x-b.x, a.y-b.y, a.z-b.z, a.w-b.w)
	else
		if (Vector4:isAncestorOf(a)) then
			error("Cannot subtract dissimilar object of type " .. type(b) .. " from Vector4")
		else
			error("Cannot subtract Vector4 from dissimilar object of type " .. type(a))
		end
	end
end)

Vector4:setMeta("mul", function(a, b)
	if (not isVector4Equivalent(a)) then a, b = b, a end

	if (type(b) == "number") then
		return Vector4:init(a.x * b, a.y * b, a.z * b, a.w * b)
	else
		error("Multiplying Vector4 by non-number object: " .. type(b))
	end
end)

Vector4:setMeta("div", function(a, b)
	if (not isVector4Equivalent(a)) then a, b = b, a end

	if (type(b) == "number") then
		return Vector4:init(a.x / b, a.y / b, a.z / b, a.w / b)
	else
		error("Dividing Vector4 with non-number object: " .. type(b))
	end
end)

Vector4:setMeta("unm", function(a)
	return Vector4:init(-a.x, -a.y, -a.z, -a.w)
end)

Vector4:setMeta("eq", function(a, b)
	if (not isVector4Equivalent(a)) then a, b = b, a end

	if (b == nil) then
		return false
	elseif (isVector4Equivalent(b)) then
		return (math.abs(a.x - b.x) <= util.EPSILON and
                math.abs(a.y - b.y) <= util.EPSILON and
                math.abs(a.z - b.z) <= util.EPSILON and
                math.abs(a.w - b.w) <= util.EPSILON )
	else
		error("Can't compare Vector4 to dissimilar object of type " .. type(b))
	end
end)

Vector4:setMeta("tostring", function(self)
	return string.format("<%8.02f, %8.02f, %8.02f, %8.02f>", self:xyzw())
end)

Vector4.lerp = Vector4:makeMethod(function(self, other, t)
	return other * t + self * (1 - t)
end)

Vector4.dot = Vector4:makeMethod(function(self, other)
	assert(isVector4Equivalent(other), "Can't perform Vector4 dot product on dissimilar object of type " .. type(b))
	return (self.x * other.x + self.y * other.y + self.z * other.z + self.w * other.w)
end)

Vector4.length = Vector4:makeMethod(function(self)
	return math.sqrt(self:dot(self))
end)

Vector4.length2 = Vector4:makeMethod(function(self)
	return self:dot(self)
end)

Vector4.normalized = Vector4:makeMethod(function(self)
	local mag = self:length()
	return self / mag, mag
end)

Vector4.copy = Vector4:makeMethod(function(self, other)
    return Vector4:init(self.x,self.y,self.z,self.w)
end)

--get the midpoint between two vectors!!
Vector4.mid = Vector4:makeMethod(function(self, other)
    return ((other + -self)/2)+self
end)

Vector4.isVector4 = Vector4:makeMethod(function(self,obj)
	return isVector4Equivalent(obj)
end)

Vector4.xyz = Vector4:makeMethod(function(self)
	return self.x,self.y,self.z
end)

Vector4.xyzw = Vector4:makeMethod(function(self)
	return self.x,self.y,self.z,self.w
end)


return Vector4
