-- Building.lua

local actor = require "src.actors.actor"
local Building = actor:makeSubclass("Building")

Building:makeInit(function(class, self, group, posX,posY)
    class.super:initWith(self)
	buildingType = buildingType or {}
	self.group = group
    
    self.typeName = buildingType.typeName or "building"
    self.typeInfo = buildingType
    --Doesn't have much yet, but will have events and health and whatever.
	--self.radiusSprite = nil
    --self.sprite = self:createSprite(self.typeInfo.anims.normal,x,y)
	self.sprite = display.newRect(self.group, posX-sun.tileWidth/2, posY-sun.tileWidth/2, sun.tileWidth, sun.tileWidth)
    self.sprite.actor = self
	self.sprite:setFillColor(10,10,10)
	self.sprite:setStrokeColor(200, 200, 200)
	
	
    return self
end)

return Building