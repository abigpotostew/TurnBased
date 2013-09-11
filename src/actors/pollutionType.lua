--Polution type
--Stores info on polluttion types
local actorType = require "src.actors.actorType"

local PollutionType = actorType:makeSubclass("PollutionType")

PollutionType:makeInit(function(class, self)
	class.super:initWith(self)

	self.physics.category = "pollution"
	self.physics.colliders = {"tower", "city", "energy", "terrain"}
	self.speed = 5
	-- self.pattern = nil 

	self.transition = {}
	self.start = {}

	return self
end)

return PollutionType
