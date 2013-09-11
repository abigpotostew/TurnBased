-- Building Type.lua
--info on building type actors

local actorType = require "src.actors.actorType"
local BuildingType = actorType:makeSubclass("BuildingType")

BuildingType:makeInit(function(class, self)
	class.super:initWith(self)

	self.physics.category = "building"
	self.physics.colliders = {"pollution"}
    
    self.width = 1
    self.height = 1

	-- set radius
	self.radius = 100

	self.transition = {}
	self.start = {}

	return self
end)

return BuildingType

-- set radius
--local circleBounding = display.newCircle( (display.contentWidth / 2) - 10 , display.contentHeight / 2, 120)
--circleBounding:setFillColor(255,255,255,50)
-- circleBounding.isVisible = false  -- optional
-- physics.addBody( circleBounding, { isSensor = true } )
-- circleBounding.myName = "circle"