local widget = require "widget"
local sprite = require "sprite"
local physics = require "physics"
local storyboard = require "storyboard"
local math = require "math"

local fps = require "src.libs.fps"
local spAnimInfo = require "src.libs.swiftping.sp_animinfo"
local spAnimSet = require "src.libs.swiftping.sp_animset"
local spSprite = require "src.libs.swiftping.sp_sprite"

local util = require"src.util"
local gamestate = require "src.gamestate"
local collision = require "src.collision"
local score = require "src.score"

local bird = require "src.actors.bird"
local hut = require "src.actors.hut"
local ammo = require "src.actors.ammo"

local class = require "src.class"
local path = require "src.path"

local vector2 = require "src.vector2"

collision.SetGroups{"bird", "ammo", "ammoExplosion", "ground", "hut"}

local Level = class:makeSubclass("Level")

-------------------------------------------------------------------------------
-- Constructor

Level:makeInit(function(class, self)
	class.super:initWith(self)

	self.trajectories = {}
	self.birdTypes = {}
	self.hutTypes = {}
	self.timeline = {}
	self.birds = {}
	self.huts = {}
	self.timers = {}
	self.transitions = {}
	self.ammoType = {}
	self.listeners = {}
	self.lastFrameTime = 0
	self.ammoReady = true

	self.scene = storyboard.newScene()
	self.scene:addEventListener("createScene", self)
	self.scene:addEventListener("enterScene", self)
	self.scene:addEventListener("exitScene", self)
	self.scene:addEventListener("destroyScene", self)

	return self
end)

-------------------------------------------------------------------------------
-- Ground

Level.AddGround = Level:makeMethod(function(self)
	local width, height = self:GetWorldViewSize()
	local ground = display.newRect(0, 0, width, 22)
	ground:setReferencePoint(display.BottomLeftReferencePoint)
	ground.x = 0
	ground.y = height
	ground.alpha = 0
	ground.typeName = "ground"
	local halfWidth = width * 0.5
	local shape = {	-halfWidth, -14,
					 halfWidth, -14,
					 halfWidth,  14,
					-halfWidth,  14 }
	physics.addBody(ground, "static", {
		shape = shape,
		bounce = self.groundBounce,
		friction = self.groundFriction,
		filter = collision.MakeFilter("ground", {"bird", "ammo"})
	})

	self:GetWorldGroup():insert(ground)
end)

-------------------------------------------------------------------------------
-- Ammo

local launchAreaRatio = 0.2

function Level:touch(event)
	if (event.phase == "began") then
		self.swipeStartX, self.swipeStartY = self:ScreenToWorld(event.x, event.y)
		self.swipeStartTime = event.time
	elseif (event.phase == "ended" and self.swipeStartX ~= nil) then
		self.swipeEndX, self.swipeEndY = self:ScreenToWorld(event.x, event.y)
		self.swipeEndTime = event.time

		local width, height = self:GetWorldViewSize()

		local dx = self.swipeEndX - self.swipeStartX
		local dy = self.swipeEndY - self.swipeStartY
		local magnitude = math.sqrt(dx*dx + dy*dy)

		local cornerX = self.swipeStartX - width
		local cornerY = self.swipeStartY - height
		local cornerMagnitude = math.sqrt(cornerX*cornerX + cornerY*cornerY)

		local dt = (self.swipeEndTime - self.swipeStartTime) / 1000

		local nx, ny, speed

		nx = dx / magnitude
		ny = dy / magnitude

		if (nx > 0 or ny > 0) then
			return
		end

		if (magnitude < 10) then
			return
		end

		speed = math.min(magnitude / dt, self.ammoType.speed)

		if (not self.ammoReady) then
			return
		end

		local spawnX = width - self.ammoTypeStart.x
		local spawnY = height - self.ammoTypeStart.y

		print("ammoLaunch")

		ammo:init(self, self.ammoType, spawnX, spawnY, nx, ny, speed * 1000)

		self.ammoReady = false
		self:CreateTimer(self.ammoType.cooldown, function(event) self.ammoReady = true end)
	end
end


-------------------------------------------------------------------------------
-- Background

Level.AddBackground = Level:makeMethod(function(self)
	local width, height = self:GetWorldViewSize()
	local background = display.newImageRect(self.background, width, height)
	background:setReferencePoint(display.TopLeftReferencePoint);
	background.x = 0
	background.y = 0

	background:addEventListener("touch", self)
	self:GetWorldGroup():insert(background)
end)

-------------------------------------------------------------------------------
-- Periodic check for win conditions, bird culling, etc

Level.PeriodicCheck = Level:makeMethod(function(self)
	-- Remove birds that have left the screen (using a separate kill list so we don't step all over ourselves)
	local killList = {}
	local width, height = self:GetWorldViewSize()
	for i, inst in ipairs(self.birds) do
		if (inst.sprite) then
			local x = inst.sprite.x
			local y = inst.sprite.y
			if (x < -(width  * 2) or x > (width  * 3) or
				y < -(height * 3) or y > (height * 1)) then
				table.insert(killList, inst)
			end
		end
	end
	for i, inst in ipairs(killList) do
		self:RemoveBird(inst)
	end

	-- Check for win/lose conditions
	local levelLost = true
	for i, hut in ipairs(self.huts) do
		if (hut:GetState() ~= "dead") then
			levelLost = false
			break
		end
	end

	local levelWon = (#self.timeline == 0 and #self.birds == 0)

	if (levelLost) then
		self:CreateTimer(2.0, function(event) gamestate.ChangeState("LevelLost") end)
	elseif (levelWon) then
		self:CreateTimer(2.0, function(event) gamestate.ChangeState("LevelWon") end)
	else
		self:CreateTimer(0.5, function(event) self:PeriodicCheck() end) -- Runs every 500ms (~15 frames)
	end
end)

-------------------------------------------------------------------------------
-- Timeline event processor

Level.ProcessTimeline = Level:makeMethod(function(self)
	while #self.timeline ~= 0 do
		local event = table.remove(self.timeline, 1)
		local result = event()
		if (type(result) == "number") then
			self:CreateTimer(result, function() self:ProcessTimeline() end)
			break
		end
	end
end)

-------------------------------------------------------------------------------
-- Callbacks from the scene

Level.createScene = Level:makeMethod(function(self, event)
	--All variables used in createScene are set in the level*.lua files.
	print("Level:CreateScene")

	self.aspect = display.contentHeight / display.contentWidth
	self.height = self.width * self.aspect

	self.worldScale = display.contentWidth / self.width
	self.worldOffset = { x = 0, y = 0}

	self.worldGroup = display.newGroup()
	self.scene.view:insert(self.worldGroup)
	self.worldGroup.xScale = self.worldScale
	self.worldGroup.yScale = self.worldScale

	print(string.format("Screen Resolution: %i x %i", display.contentWidth, display.contentHeight))
	print(string.format("Level Size: %i x %i", self.width, self.height))

	-- Init physics and then pause so we can do setup
	physics.start()
	physics.pause()

	-- Load ammo
	self.ammoType:load()

	-- Load birds
	for _, birdType in pairs(self.birdTypes) do
		birdType:load()
	end

	-- Load huts
	for hutType, _ in pairs(self.hutTypes) do
		hutType:load()
	end

	-- Add scenery (also, the background has the touch listener that fires ammo)
	self:AddBackground()
	self:AddGround()

	self.scoreIndicator = score.CreateScoreIndicator(self.contentWidth, 0)
	self:GetScreenGroup():insert(self.scoreIndicator)

	print("Timeline has " .. #self.timeline .. " events")

	-- Start processing the level's timeline (usually starts with spawning various things)
	self:ProcessTimeline()

	local performance = fps.new()
	performance.group.alpha = 0.4 -- So it doesn't get in the way of the rest of the scene
	self.scene.view.xScale = 0.25
	self.scene.view.yScale = 0.25

	-- Start the recurring check for win conditions and miscellaneous cleanup
	self:PeriodicCheck()
end)

Level.enterScene = Level:makeMethod(function(self, event)
	print("scene:enterScene")
	physics.start()
	physics.setGravity(self.gravity.x, self.gravity.y)
end)

Level.exitScene = Level:makeMethod(function(self, event)
	print("scene:exitScene")
	physics.stop()

	for _, timerToStop in ipairs(self.timers) do
		timer.cancel(timerToStop)
	end
	self.timers = {}

	for _, transitionToStop in ipairs(self.transitions) do
		transition.cancel(transitionToStop)
	end
	self.transitions = {}

    for _, listener in ipairs(self.listeners) do
    	if (listener.object and listener.object.removeEventListener) then
    		listener.object:removeEventListener(listener.name, listener.listener)
    	end
    end
    self.listeners = {}
end)

Level.destroyScene = Level:makeMethod(function(self, event)
	print("scene:destroyScene")
end)

-------------------------------------------------------------------------------
-- Getters and utility functions

Level.GetWorldGroup = Level:makeMethod(function(self)
	return self.worldGroup
end)

Level.GetScreenGroup = Level:makeMethod(function(self)
	return self.scene.view
end)

Level.GetWorldScale = Level:makeMethod(function(self)
	return self.worldScale
end)

Level.WorldToScreen = Level:makeMethod(function(self, x, y)
	return (x * self.worldScale + self.worldOffset.x), (y * self.worldScale + self.worldOffset.y)
end)

Level.ScreenToWorld = Level:makeMethod(function(self, x, y)
	return ((x - self.worldOffset.x) / self.worldScale), ((y - self.worldOffset.y) / self.worldScale)
end)

Level.GetWorldViewSize = Level:makeMethod(function(self)
	return self.width, self.height
end)

Level.CreateExplosion = Level:makeMethod(function(self, object, animSet, animName)
	local explosion = spSprite.init(animSet, animName)
	self:GetWorldGroup():insert(explosion)
	explosion:addEventListener("sprite", util.RemoveAtEnd)
	explosion.x = object.x
	explosion.y = object.y
	explosion:play()

	return explosion
end)

Level.CreateTimer = Level:makeMethod(function(self, secondsDelay, onTimer)
	table.insert(self.timers, timer.performWithDelay(secondsDelay * 1000, onTimer))
end)

Level.CreateListener = Level:makeMethod(function(self, object, name, listener)
	table.insert(self.listeners, {object = object, name = name, listener = listener})
	object:addEventListener(name, listener)
end)

Level.CreateTransition = Level:makeMethod(function(self, object, params)
	table.insert(self.transitions, transition.to(object, params))
end)

Level.RemoveBird = Level:makeMethod(function(self, object)
	util.FindAndRemove(self.birds, object)
	object:removeSelf()
end)

-------------------------------------------------------------------------------
-- Convenience functions for setting level data

Level.SetTrajectoryStart = Level:makeMethod(function(self, name, data)
	self.trajectories[name] = self.trajectories[name] or {}
	self.trajectories[name].start = util.MergeTables(self.trajectories[name].start, data)
end)

Level.SetBird = Level:makeMethod(function(self, name, birdType)
	self.birdTypes[name] = birdType
end)

Level.TimelineWait = Level:makeMethod(function(self, seconds)
	table.insert(self.timeline, function() return seconds end)
end)

Level.TimelineSpawnBird = Level:makeMethod(function(self, data)
	if (data.wait ~= nil) then
		self:TimelineWait(data.wait)
	end

	local function SpawnBird()
		local newBird = bird:init(self, self.birdTypes[data.bird], self.trajectories[data.trajectory])
		table.insert(self.birds, newBird)
	end

	table.insert(self.timeline, SpawnBird)
end)

Level.TimelineSpawnHut = Level:makeMethod(function(self, data)
	local function SpawnHut()
		local newHut = hut:init(self, data.hutType, data.x, data.y)
		table.insert(self.huts, newHut)
	end

	table.insert(self.timeline, SpawnHut)
	if (self.hutTypes[data.hutType] == nil) then
		self.hutTypes[data.hutType] = true
	end
end)

return Level
