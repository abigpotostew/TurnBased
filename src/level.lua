local widget = require "widget"
local sprite = require "sprite"
local storyboard = require "storyboard"
local math = require "math"

local fps = require "src.libs.fps"

local util = require"src.util"
local gamestate = require "src.gamestate"
local collision = require "src.collision"
local score = require "src.score"

local class = require "src.class"
local path = require "src.path"

local Vector2 = require "src.vector2"

local Grid = require("src.grid")

--collision.SetGroups{"bird", "ammo", "ammoExplosion", "ground", "hut"}

local Player = require("src.actors.player")
local Building = require("src.actors.building")
local Enemy = require("src.actors.enemy")


local Level = class:makeSubclass("Level")


-------------------------------------------------------------------------------
-- Constructor

Level:makeInit(function(class, self)
	class.super:initWith(self)

	self.timeline = {}
	self.enemies = {}
	self.terrain = {}
	self.buildings = {}
	self.timers = {}
	self.transitions = {}
	self.listeners = {}
	self.movingActors = {}
	self.movingActorsCt = 0
	self.lastFrameTime = 0

	self.scene = storyboard.newScene()
	self.scene.view = display.newGroup()
	self.scene:addEventListener("createScene", self)
	self.scene:addEventListener("enterScene", self)
	self.scene:addEventListener("exitScene", self)
	self.scene:addEventListener("destroyScene", self)
	
	self.width = display.contentWidth
	
	self.doubleTapMark = 0

	return self
end)



function Level:touch(event)
	--local currTile = event.target
	if event.phase == "began" then
        self.prevTouchPos = Vector2:init(self.xBegan or -1,self.yBegan or -1)
		self.xBegan = event.x
		self.yBegan = event.y
		if self.stepping then return true end
	elseif event.phase == "moved" then
		if self.stepping then return true end
		local dx = event.x - self.xBegan
		local dy = event.y - self.yBegan
		local delta = Vector2:init(event.x - self.xBegan,event.y - self.yBegan)
		local dist = delta:length()
		if(dist > 100) then
			local quadrants = {}
			quadrants[1] = math.pi/4
			quadrants[2] = 3*math.pi/4
			local angle = delta:angle()
			local out = ""
			local x = 0
			local y = 0
			if math.abs(angle) > quadrants[2] then
				out="right"
				x = sun.tileWidth
				self.player.destX = 1
				self.player.destY = 0
			elseif angle > quadrants[1] then
				out="up"
				y = -sun.tileWidth
				self.player.destX = 0
				self.player.destY = -1
			elseif angle > -quadrants[1] then
				out="left"
				x = -sun.tileWidth
				self.player.destX = -1
				self.player.destY = 0
			elseif angle > -quadrants[2] then
				out = "down"
				y = sun.tileWidth
				self.player.destX = 0
				self.player.destY = 1
			else
				out = "right"
				x = sun.tileWidth
				self.player.destX = 1
				self.player.destY = 0
			end
			--display.getCurrentStage():setFocus( nil )
			--event.target.isFocus = false
			--local p = self.player.sprite
			--transition.to(p,{x=p.x+x,y=p.y+y,
			--				transition=easing.outQuad, 
			--				--onComplete=zoomingListener
			--				})
			--print(out..", angle= "..angle)
			self:step()
		end
	elseif event.phase == "ended" or event.phase == "cancelled" then
		--print("touch end")
		--double tap speed == 500
		if ( system.getTimer() - self.doubleTapMark < sun.doubleTapTime and
                (self.prevTouchPos-
                    Vector2:init(self.xBegan,self.yBegan)):length()<=sun.doubleTapMaxDist ) then
			print("double tap!!")
            
		else
			self.doubleTapMark = system.getTimer()
		end
	
	end
	
	return true --important
end


local function moveActor(actorSprite)
	local a = actorSprite.actor
	local finished = false
    local success = true
	if a.movementsRemaining > 0 then
		a.movementsRemaining = a.movementsRemaining-1
		--do another movement
		success = a:move(a.level.grid, moveActor)
		if success == false then finished = true end
	else
		finished = true
	end
	
	if finished then
		a.level.movingActorsCt = a.level.movingActorsCt - 1
		a.level:finishStep()
	end
    return success
end

Level.finishStep = Level:makeMethod(function(self)
	if self.movingActorsCt <= 0 then
		self.stepping = false
	end
end)

Level.step = Level:makeMethod(function(self)
	if self.stepping == true then return end
	--print("stepping")
	self.stepping = true
	local p = self.player
	local i = 1
	p.moveIndex = i
    p.movementsRemaining = p.movements
	if moveActor(p.sprite) then 
    
        self.movingActors = {}
        --add all other actors here
        for i=1,#self.enemies do
            table.insert(self.movingActors,self.enemies[i])
        end
        
        self.movingActorsCt = #self.movingActors
        
        for i=1,#self.movingActors do
            local a = self.movingActors[i]
            a.movementsRemaining = a.movements
            moveActor(a.sprite)
        end
    
    end
	
end)



-------------------------------------------------------------------------------
-- Periodic check for win conditions, bird culling, etc

Level.PeriodicCheck = Level:makeMethod(function(self)
	-- Remove birds that have left the screen (using a separate kill list so we don't step all over ourselves)
--	local killList = {}
--	local width, height = self:GetWorldViewSize()
--	for i, inst in ipairs(self.birds) do
--		if (inst.sprite) then
--			local x = inst.sprite.x
--			local y = inst.sprite.y
--			if (x < -(width  * 2) or x > (width  * 3) or
--				y < -(height * 3) or y > (height * 1)) then
--				table.insert(killList, inst)
--			end
--		end
--	end
--	for i, inst in ipairs(killList) do
--		self:RemoveBird(inst)
--	end

--	-- Check for win/lose conditions
--	local levelLost = true
--	for i, hut in ipairs(self.huts) do
--		if (hut:GetState() ~= "dead") then
--			levelLost = false
--			break
--		end
--	end

--	local levelWon = (#self.timeline == 0 and #self.birds == 0)

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
    
    --------------------------------
    -- Spawn grid here!
    --------------------------------
	self.grid = Grid:init()
	self:createPlayer(2,3)
	self:createBuilding(1,2)
	self:createBuilding(3,2)
	self:createBuilding(5,2)
	self:createBuilding(6,3)
	
	self:createEnemy(2,6)
	
	self.grid.group:addEventListener("touch", self)

	self.aspect = display.contentHeight / display.contentWidth
	self.height = self.width * self.aspect

	self.worldScale = 1--display.contentWidth / self.width
	self.worldOffset = { x = 0, y = 0}

	self.worldGroup = display.newGroup()
	self.scene.view:insert(self.worldGroup)
	self.worldGroup.xScale = self.worldScale
	self.worldGroup.yScale = self.worldScale
	self.worldGroup:insert(self.grid.group)

	print(string.format("Screen Resolution: %i x %i", display.contentWidth, display.contentHeight))
	print(string.format("Level Size: %i x %i", self.width, self.height))


	--self.scoreIndicator = score.CreateScoreIndicator(self.contentWidth, 0)
	--self:GetScreenGroup():insert(self.scoreIndicator)

	print("Timeline has " .. #self.timeline .. " events")

	-- Start processing the level's timeline (usually starts with spawning various things)
	self:ProcessTimeline()

	local performance = fps.new()
	performance.group.alpha = 0.7 -- So it doesn't get in the way of the rest of the scene
	--self.scene.view.xScale = 0.25
	--self.scene.view.yScale = 0.25

	-- Start the recurring check for win conditions and miscellaneous cleanup
	self:PeriodicCheck()
end)

Level.enterScene = Level:makeMethod(function(self, event)
	print("scene:enterScene")
end)

Level.exitScene = Level:makeMethod(function(self, event)
	print("scene:exitScene")
	
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

Level.createPlayer = Level:makeMethod(function(self,x,y)
	x = x or 1
	y = y or 1
	self.player = Player:init(x,y)
    self.player.level = self
	self.grid:insert(self.player)
	self.grid.player = self.player
	self.grid:setActorAt(self.player,Vector2:init(x,y))
end)

Level.createBuilding = Level:makeMethod(function(self,gridX,gridY)
	assert(type(gridX)=="number",type(gridY)=="number","building requires a grid location x,y")
	local b = Building:init(self.grid.group,gridX*sun.tileWidth,gridY*sun.tileWidth)
	self.grid:insert(b)
    b.level = self
	self.grid:setActorAt(b,Vector2:init(gridX,gridY))
end)

Level.createEnemy = Level:makeMethod(function(self,gridX,gridY)
	assert(type(gridX)=="number",type(gridY)=="number","building requires a grid location x,y")
	local e = Enemy:init(self.grid.group,gridX,gridY)
	self.grid:insert(e)
	self.grid:setActorAt(e,Vector2:init(gridX,gridY))
    e.level = self
	table.insert(self.enemies,e)
end)

return Level
