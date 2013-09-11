-- Energy.lua

local building = require("src.actors.building")

local Energy = building:makeSubclass("Energy")

Energy:makeInit(function(class, self, buildingType, x, y)
	class.super:initWith(self, buildingType, x, y)
	assert(x,"Please provide an x position when calling init on energy")
	assert(y,"Please provide a y position when calling init on energy")
	
	self.typeName = "energy"
	self.hitCount = 10
	self.energyType = "coal"
	
	self.outPipes = {up=nil,right=nil,down=nil,left=nil}

	self:addPhysics()
	self.sprite.gravityScale = 0.0
	return self
end)

Energy.canStartPipe = Energy:makeMethod(function(self, outDirection)
		--NONE = -1, LEFT = 0, UP = 1, RIGHT = 2, DOWN = 3
	assert(outDirection~=pipe.NONE,"Cant start a pipe for this energy source in a nil direction")
	if outDirection == pipe.LEFT and self.outPipes.left ~= nil then
		return false
	elseif outDirection == pipe.UP and self.outPipes.up ~= nil then
		return false
	elseif outDirection == pipe.RIGHT and self.outPipes.right ~= nil then
		return false
	elseif outDirection == pipe.DOWN and self.outPipes.down ~= nil then
		return false
	end
	
	--check any other conditions here
	
	return true
end)

return Energy