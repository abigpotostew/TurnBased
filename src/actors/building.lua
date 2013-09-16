-- Building.lua

local actor = require "src.actors.actor"
local Building = actor:makeSubclass("Building")

Building:makeInit(function(class, self, group, gridX,gridY)
    class.super:initWith(self,gridX,gridY)
	buildingType = buildingType or {}
	self.group = group
    
    --local  posX, posY = self.X*sun.tileWidth, self.Y*sun.tileHeight
    
    self.typeName = buildingType.typeName or "building"
    self.typeInfo = buildingType
    --Doesn't have much yet, but will have events and health and whatever.
	--self.radiusSprite = nil
    --self.sprite = self:createSprite(self.typeInfo.anims.normal,x,y)
    --self:createRectangleSprite(group, sun.tileWidth, sun.tileWidth)
	--self.sprite:setFillColor(255,0,255) --default building rectangle is magenta
	--self.sprite:setStrokeColor(200, 200, 200)
    
	self.movements = 0
	
    return self
end)

return Building