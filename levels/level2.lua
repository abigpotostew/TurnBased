-- Create a default level - For documentation on all available parameters, read "defaults.lua" in the levels directory!
local util = require "src.util"
local level = require "src.level"
local levelDefaults = require "levels.defaults"
local huts = require "actors.huts"
local birds = require "actors.birds"
local ammos = require "actors.ammos"

local l = level:init()
levelDefaults(l)

l.width = 2000 -- The size of the level's long direction.
l.gravity = { x = 4.2,  y = 23.0 } -- The level's gravitational acceleration

l:TimelineSpawnHut{hutType = huts.BrickHut(), x = 1850, y = 1280}
l:TimelineSpawnHut{hutType = huts.BrickHut(), x = 1650, y = 1285}


l.background = "art/scenery/level23_bk.png" -- The level's static background image

l.ammoType = ammos.pillow()

l:SetTrajectoryStart(1, { -- Comes in from upper left and smacks left two crates
	position = {x = -100, y = 100},
	angle = -45,
	speed = 200,
})

l:SetTrajectoryStart(2, { -- Comes in from middle left and hits barns on the side
	position = {x = 10, y = 20},
	angle = 20,
	speed = 350,
})

l:SetTrajectoryStart(3, { -- Comes in from middle left and hits barns on the side (slightly higher than 2)
	position = {x = 0, y = 180},
	angle = -5,
	speed = 550,
})

-- Timeline: Specify events that happen in sequence, including bird spawning
l:TimelineWait(2.0)

l:TimelineSpawnBird{bird = 2, trajectory = 1, wait = 1.0}
l:TimelineSpawnBird{bird = 2, trajectory = 1, wait = 2.0}

l:TimelineWait(3.0)

l:TimelineSpawnBird{bird = 2, trajectory = 1, wait = 0.5}
l:TimelineSpawnBird{bird = 2, trajectory = 1, wait = 1.0}

l:TimelineWait(2.0)

l:TimelineSpawnBird{bird = 4, trajectory = 1, wait = 1.0}
l:TimelineSpawnBird{bird = 2, trajectory = 1, wait = 1.0}

l:TimelineWait(2.0)

l:TimelineSpawnBird{bird = 2, trajectory = 1, wait = 1.0}
l:TimelineSpawnBird{bird = 2, trajectory = 1, wait = 1.0}

l:TimelineWait(2.0)

l:TimelineSpawnBird{bird = 4, trajectory = 2, wait = 1.0}
l:TimelineSpawnBird{bird = 2, trajectory = 3, wait = 1.0}


return l.scene
