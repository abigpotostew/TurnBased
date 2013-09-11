--[[
Project Sunlight
ActorType
Stores information about an actor
]]--

--local spAnimInfo = require "src.libs.swiftping.sp_animinfo"
--local spAnimSet = require "src.libs.swiftping.sp_animset"
local audio = require "audio"
local class = require "src.class"
local assetManager = require "src.assetManager"
local util = require "src.util"

local ActorType = class:makeSubclass("ActorType")

ActorType:makeInit(function(class, self)
	class.super:initWith(self)

	self.anims = {}
	self.sounds = {}

	self.physics = {
		mass = 1,
		friction = 0,
		bounce = 0,
		bodyType = "kinematic",
		category = "",
		collidables = {},
		gravity = 0,
		isSensor = true,
		
	 }
	 util.errorOnUndefinedProperty(self.physics)

	self.scale = 1
	util.errorOnUndefinedProperty(self.scale)

	self.animSet = nil
	self.soundSet = nil

	return self
end)

ActorType.load = ActorType:makeMethod(function(self)

	self.animSet = spAnimSet.init(nil)
	for animName, anim in pairs(self.anims) do
		self.animSet:addAnim(assetManager.getAsset(anim, "anim"), animName)
	end

	self.soundSet = {}
	for soundName, sound in pairs(self.sounds) do
		self.soundSet[soundName] = assetManager.getAsset("sfx/" .. sound, "sound")
	end
end)

return ActorType
