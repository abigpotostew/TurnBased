-- Create a default level - For documentation on all available parameters, read "defaults.lua" in the levels directory!
local util = require "src.util"
local level = require "src.level"
local levelDefaults = require "levels.defaults"
local huts = require "actors.huts"
local birds = require "actors.birds"
local ammos = require "actors.ammos"

local l = level:init()
levelDefaults(l)

l.width = 1400 -- The size of the level's long direction.
l.gravity = { x = -5,  y = 10.5 } -- The level's gravitational acceleration

l.groundFriction = 0.1 -- How much friction the level's ground has
l.groundBounce = 0.08 -- How bouncy the level's ground is


l.background = "art/scenery/level3_bk.png" -- The level's static background image

l:TimelineSpawnHut{hutType = huts.BrickHut(), x = 1232, y = 890}
--l:TimelineSpawnHut{hutType = huts.BrickHut(), x = 990, y = 855}

l.ammoType = ammos.pan()

l:SetTrajectoryStart(1, { -- Comes in from upper left and smacks left two crates
	position = {x = 0, y = 60},
	angle = 5,
	speed = 400,
})

l:SetTrajectoryStart(2, { -- Comes in from middle left and hits barns on the side
	position = {x = 0, y = 180},
	angle = 0,
	speed = 550,
})

l:SetTrajectoryStart(3, { -- Comes in from middle left and hits barns on the side (slightly higher than 2)
	position = {x = 10, y = 180},
	angle = -5,
	speed = 550,
})

l:SetTrajectoryStart(4, { -- Comes in from middle left and hits barns on the side (slightly higher than 2)
	position = {x = 250, y = -10},
	angle = 60,
	speed = 300,
})

l:SetTrajectoryStart("Boss Side", { -- Comes in from middle left and hits barns on the side (slightly higher than 2)
	position = {x = 5, y = 180},
	angle = -10,
	speed = 500,
})

l:SetTrajectoryStart("Boss Top", { -- Comes in from middle left and hits barns on the side (slightly higher than 2)
	position = {x = 600, y = -100},
	angle = 90,
	speed = 100,
})

l:SetBird("BigBoss", birds.bossbird())

-- Timeline: Specify events that happen in sequence, including bird spawning

l:TimelineWait(1.0)
l:TimelineSpawnBird{bird = "BigBoss", trajectory = "Boss Side", wait = 1.0}

l:TimelineSpawnBird{bird = 3, trajectory = 2, wait = 2.0}
l:TimelineSpawnBird{bird = 3, trajectory = 2, wait = 2.0}
l:TimelineSpawnBird{bird = 3, trajectory = 2, wait = 1.0}

l:TimelineWait(2.0)

l:TimelineSpawnBird{bird = 3, trajectory = 3, wait = 1.0}
l:TimelineSpawnBird{bird = 3, trajectory = 3, wait = 3.0}
l:TimelineSpawnBird{bird = 3, trajectory = 2, wait = 1.0}

l:TimelineWait(3.0)

l:TimelineSpawnBird{bird = "BigBoss", trajectory = "Boss Side", wait = 1.0}


l:TimelineSpawnBird{bird = 3, trajectory = 1, wait = 2.0}
l:TimelineSpawnBird{bird = 3, trajectory = 1, wait = 1.0}
l:TimelineSpawnBird{bird = 3, trajectory = 1, wait = 1.0}

return l.scene
