local class = require "src.class"
local util = require "src.util"

local Vector2 = class:makeSubclass("Vector2")

local function isVector2Equivalent(obj)
	return (type(obj) == "table" and type(obj.x) == "number" and type(obj.y) == "number")
end

Vector2:makeInit(function(class, self, ...)
	class.super:initWith(self)

	if (#arg == 0) then
		self.x = 0
		self.y = 0
	elseif (#arg == 1) then
		local other = arg[1]
		assert(isVector2Equivalent(other), "The Vector2 single argument constructor takes a table with both an x and a y property")
		self.x = other.x
		self.y = other.y
	elseif (#arg == 2) then
		self.x = arg[1]
		self.y = arg[2]
	else
		error("The Vector2 constructor takes zero, one or two arguments")
	end

	return self

end)

Vector2:setMeta("add", function(a, b)
	if (isVector2Equivalent(a) and isVector2Equivalent(b)) then
		return Vector2:init(a.x + b.x, a.y + b.y)
	else
		if (Vector2:isAncestorOf(a)) then
			error("Cannot add dissimilar object of type " .. type(b) .. " to Vector2")
		else
			error("Cannot add Vector2 to dissimilar object of type " .. type(a))
		end
	end
end)

Vector2:setMeta("sub", function(a, b)
	if (isVector2Equivalent(a) and isVector2Equivalent(b)) then
		return Vector2:init(a.x - b.x, a.y - b.y)
	else
		if (Vector2:isAncestorOf(a)) then
			error("Cannot subtract dissimilar object of type " .. type(b) .. " from Vector2")
		else
			error("Cannot subtract Vector2 from dissimilar object of type " .. type(a))
		end
	end
end)

Vector2:setMeta("mul", function(a, b)
	if (not isVector2Equivalent(a)) then a, b = b, a end

	if (type(b) == "number") then
		return Vector2:init(a.x * b, a.y * b)
	else
		error("Multiplying Vector2 by non-number object: " .. type(b))
	end
end)

Vector2:setMeta("div", function(a, b)
	if (not isVector2Equivalent(a)) then a, b = b, a end

	if (type(b) == "number") then
		return Vector2:init(a.x / b, a.y / b)
	else
		error("Dividing Vector2 with non-number object: " .. type(b))
	end
end)

Vector2:setMeta("unm", function(a)
	return Vector2:init(-a.x, -a.y)
end)

Vector2:setMeta("eq", function(a, b)
	if (not isVector2Equivalent(a)) then a, b = b, a end

	if (b == nil) then
		return false
	elseif (isVector2Equivalent(b)) then
		return (math.abs(a.x - b.x) <= util.EPSILON and math.abs(a.y - b.y) <= util.EPSILON)
	else
		error("Can't compare Vector2 to dissimilar object of type " .. type(b))
	end
end)

Vector2:setMeta("tostring", function(self)
	return string.format("<%8.02f, %8.02f>", self.x ,self.y)
end)

Vector2.lerp = Vector2:makeMethod(function(self, other, t)
	return other * t + self * (1 - t)
end)

Vector2.dot = Vector2:makeMethod(function(self, other)
	assert(isVector2Equivalent(other), "Can't perform Vector2 dot product on dissimilar object of type " .. type(b))
	return (self.x * other.x + self.y * other.y)
end)

Vector2.length = Vector2:makeMethod(function(self)
	return math.sqrt(self:dot(self))
end)

Vector2.length2 = Vector2:makeMethod(function(self)
	return self:dot(self)
end)

Vector2.normalized = Vector2:makeMethod(function(self)
	local mag = self:length()
	return self / mag, mag
end)

-- Radians!
Vector2.angle = Vector2:makeMethod(function(self, other)
	other = other or Vector2:init(0,0)
	assert(isVector2Equivalent(other), "Can't perform Vector2 angle on dissimilar object of type " .. type(other))
	return math.atan2(other.y-self.y,other.x-self.x)
end)

Vector2.copy = Vector2:makeMethod(function(self, other)
    return Vector2:init(self.x,self.y)
end)

--get the midpoint between two vectors!!
Vector2.mid = Vector2:makeMethod(function(self, other)
    return ((other + -self)/2)+self
end)

Vector2.isVector2 = Vector2:makeMethod(function(self,obj)
	return isVector2Equivalent(obj)
end)


return Vector2
