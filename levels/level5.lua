-- Create a default level - For documentation on all available parameters, read "defaults.lua" in the levels directory!
local util = require "src.util"
local level = require "src.level"
local levelDefaults = require "levels.defaults"
local huts = require "actors.huts"
local birds = require "actors.birds"
local ammos = require "actors.ammos"

local l = level:init()
levelDefaults(l)

l.width = 1800 -- The size of the level's long direction.
l.gravity = { x = 8.3,  y = 23.23 } -- The level's gravitational acceleration

l.background = "art/scenery/level4_bk.png" -- The level's static background image

--l:TimelineSpawnHut{hutType = huts.BrickHut(), x = 810, y = 1150}
l:TimelineSpawnHut{hutType = huts.strawhut(), x = 1590, y = 1150}
l:TimelineSpawnHut{hutType = huts.strawhut(), x = 800, y = 1150}

l.ammoType = ammos.pan()
l.ammoType.speed = 2800
l.ammoType.transition.rotation =0
l.ammoType.transition.startScale = 0.6

l.ammoType.physics.bounce = 0.5
l.ammoType.cooldown = 0.05
l.ammoType.lifeSpan = 0.8


	l:SetTrajectoryStart(1, { -- Comes in from upper left and smacks left two crates
	position = {x = 0, y = 60},
	angle = 5,
	speed = 300,
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

l:TimelineWait(2.0)

l:TimelineSpawnBird{bird = 1, trajectory = 2, wait = 2.0}
l:TimelineSpawnBird{bird = 2, trajectory = 2, wait = 2.0}
l:TimelineSpawnBird{bird = 1, trajectory = 2, wait = 2.0}

l:TimelineWait(2.0)

l:TimelineSpawnBird{bird = 1, trajectory = 2, wait = 2.0}
l:TimelineSpawnBird{bird = 2, trajectory = 2, wait = 2.0}
l:TimelineSpawnBird{bird = 1, trajectory = 2, wait = 2.0}

--l:TimelineWait(1.0)

--l:TimelineSpawnBird{bird = "BigBoss", trajectory = "Boss Side", wait = 1.0}


l:TimelineWait(1.0)

l:TimelineSpawnBird{bird = 1, trajectory = 2, wait = 2.0}
l:TimelineSpawnBird{bird = 2, trajectory = 2, wait = 1.0}
l:TimelineSpawnBird{bird = 1, trajectory = 2, wait = 1.0}

l:TimelineWait(2.0)

l:TimelineSpawnBird{bird = 1, trajectory = 2, wait = 2.0}
l:TimelineSpawnBird{bird = 2, trajectory = 2, wait = 1.0}
l:TimelineSpawnBird{bird = 1, trajectory = 2, wait = 1.0}


return l.scene
