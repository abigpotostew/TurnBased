local class = require "src.class"
local vector2 = require "src.vector2"
local util = require "src.util"

local Path = class:makeSubclass("Path")
local PathSlider = class:makeSubclass("PathSlider")

Path:makeInit(function(class, self, point, time)
	class.super:initWith(self)

	self.startTime = time
	self.points = {}
	self:addPoint(point, time)

	return self
end)

Path.addPoint = Path:makeMethod(function(self, point, time)
	time = time or 0
	assert(type(time) == "number", "addPoint requires the time parameter to be a number or nil")

	if (#self.points == 0 or self.points[#self.points].point ~= point) then
		table.insert(self.points, {point = vector2:init(point), time = time - self.startTime})
	end
end)

Path.getTime = Path:makeMethod(function(self)
	return self.points[#self.points].time
end)

Path.getLength = Path:makeMethod(function(self)
	local len = 0
	for i = 1, #self.points - 1 do
		len = len + (self.points[i+1].point - self.points[i].point):length()
	end
	return len
end)

Path.drawDebugLine = Path:makeMethod(function(self, displayGroup, width, color)
	assert(displayGroup)
	width = width or 10
	color = color or {32, 128, 32, 128}

	local p1, p2 = self.points[1].point, nil
	local line = display.newLine(displayGroup, p1.x - 1, p1.y, p1.x, p1.y)
	for i = 1, #self.points - 1, 2 do
		p1 = self.points[i+0].point
	 	p2 = self.points[i+1].point
		line:append(p1.x, p1.y, p2.x, p2.y)
	end
	line.width = width
	line:setColor(unpack(color))

	return line
end)

Path.makeSlider = Path:makeMethod(function(self, looping)
	return PathSlider:init(self, looping)
end)

PathSlider:makeInit(function(class, self, path)
	class.super:initWith(self)

	assert(path, "PathSlider requires a path")

	self._path = path
	self._time = 0
	self._idx = 1

	return self
end)

PathSlider._getNextSpan = PathSlider:makeMethod(function(self, dir)
	local point1 = self._path.points[self._idx]
	local point2 = self._path.points[self._idx + dir]

	if (point2 == nil) then
		return false
	end

	local spanTime = point2.time - point1.time
	local spanLength = (point2.point - point1.point):length() * dir
	local param
	if (spanTime <= util.EPSILON) then
		param = 1
	else
		param = 1 - (self._time - point1.time) / spanTime
	end

	return true, spanTime * param, spanLength * param
end)

PathSlider._move = PathSlider:makeMethod(function(self, rTime, rLength, dir, tTime, tLength, depth)
	assert(rTime, rLength, dir, tTime, tLength)

	depth = depth or 1

	local spanExists, spanTime, spanLength = self:_getNextSpan(dir)

	if (not spanExists or
		math.abs(rTime) < util.EPSILON or
		math.abs(rLength) < util.EPSILON ) then

		print(string.format("_move d:%3.04i rt:%8.02f rl:%8.02f                         tt:%8.02f tl:%8.02f t:%8.02f i:%i d:%i",
				depth, rTime, rLength, tTime, tLength, self._time, self._idx, dir))
		return rTime, rLength, tTime, tLength
	end

	print(string.format("_move d:%3.04i rt:%8.02f rl:%8.02f st:%8.02f sl:%8.02f tt:%8.02f tl:%8.02f t:%8.02f i:%i d:%i",
			depth, rTime, rLength, spanTime, spanLength, tTime, tLength, self._time, self._idx, dir))

	local t, l
	if (spanTime <= rTime and spanLength <= rLength) then
		self._idx = self._idx + dir
		t = spanTime
		l = spanLength
	else
		if (spanTime > rTime) then
			t = rTime
			l = spanLength * (rTime / spanTime)
		else
			t = spanTime * (rLength / spanLength)
			l = rLength
		end
	end

	self._time = self._time + t
	rTime = rTime - t
	tTime = tTime + t
	rLength = rLength - l
	tLength = tLength + l

	assert(rLength * dir >= 0, "Bad rLength: " .. rLength)
	assert(rTime * dir >= 0, "Bad rTime: " .. rTime)

	return self:_move(rTime, rLength, dir, tTime, tLength, depth + 1)
end)

PathSlider.moveByTime = PathSlider:makeMethod(function(self, time)
	local dir = util.sign(time)
	local rt, rl, tt, tl = self:_move(time, math.huge * dir, dir, 0, 0)
	return self:getPosition(), rt, rl, tt, tl
end)

PathSlider.moveByLength = PathSlider:makeMethod(function(self, length)
	local dir = util.sign(length)
	local rt, rl, tt, tl = self:_move(math.huge * dir, length, dir, 0, 0)
	return self:getPosition(), rt, rl, tt, tl
end)

PathSlider.getPosition = PathSlider:makeMethod(function(self)
	local points = self._path.points
	local idx = self._idx
	local point1 = points[idx]
	local point2 = points[idx+1]
	if (point2 == nil) then
		return points[idx].point
	else
		local span = point2.time - point1.time
		local param = (self._time - point1.time) / span
		return point1.point:lerp(point2.point, param)
	end
end)

PathSlider.goToBeginning = PathSlider:makeMethod(function(self)
	self._idx = 1
	self._time = 0
end)

PathSlider.goToEnd = PathSlider:makeMethod(function(self)
	self._idx = #points
	self._time = self._path:getTime()
end)

PathSlider.getDist = PathSlider:makeMethod(function(self)
	return self._dist
end)

PathSlider.getTime = PathSlider:makeMethod(function(self)
	return self._time
end)

PathSlider.getPath = PathSlider:makeMethod(function(self)
	return self._path
end)

PathSlider.atBeginning = PathSlider:makeMethod(function(self)
	return (util.EPSILON > self._time)
end)

PathSlider.atEnd = PathSlider:makeMethod(function(self)
	return (self._path:getTime() - util.EPSILON <= self._time)
end)

PathSlider.getVelocity = PathSlider:makeMethod(function(self)
	--TODO
end)

PathSlider.getAcceleration = PathSlider:makeMethod(function(self)
	--TODO
end)

return Path
