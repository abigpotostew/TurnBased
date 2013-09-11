-- Create a default level - For documentation on all available parameters, read "defaults.lua" in the levels directory!
local util = require "src.util"
local level = require "src.level"
local levelDefaults = require "levels.defaults"
local huts = require "actors.huts"
local birds = require "actors.birds"
local ammos = require "actors.ammos"

-- The TOMATO Level.

local l = level:init()
levelDefaults(l)
l.width = 2700 -- The size of the level's long direction.
l.gravity = { x = 4,  y = 20.0 } -- The level's gravitational acceleration


l.background = "art/scenery/level4_bk.png" -- The level's static background image


l:TimelineSpawnHut{hutType = huts.BrickHut(), x = 2350, y = 1670}

l.ammoType = ammos.tomato()
--l.ammoType.transition.flightSpeed = 100
--l.ammoType.physics.rotation = -60
l.ammoType.scale = 0.2-- Start size
--l.ammoType.mass = .001
l.ammoType.speed = 1800
l.ammoType.lifeSpan = 1.5
l.ammoType.physics.mass = .015 -- How much inertia the ammo has
l.ammoType.physics.friction = 20.9 -- How much much friction objects sliding against the ammo will have
l.ammoType.physics.bounce = 0.18 -- How much force objects will bounce off the ammo with. 0.0 stops the other object 1.0 launches like a pool ball
l.ammoType.physics.normalForce = 400 -- How much to push away birds that hit this object
l.ammoType.physics.antiBounce = -10.4 -- How much to slow down birds that hit this object
l.ammoType.physics.pushout = 300 -- How far to warp the bird away from the collision with the ammo


l:SetTrajectoryStart(1, { -- Comes in from upper left and smacks left two crates
	position = {x = 100, y = 10},
	angle = 8,
	speed = 100,
})

l:SetTrajectoryStart(2, { -- Comes in from middle left and grazes barns in reverse order
	position = {x = 0, y = 150},
	angle = -5,
	speed = 140,
})

l:SetTrajectoryStart(3, { -- Comes in from the top middle and hits the right two crates
	position = {x = 100, y = -10},
	angle = 20,
	speed = 300,
})




-- Timeline: Specify events that happen in sequence, including bird spawning
l:TimelineWait(1.0)
l:TimelineSpawnBird{bird = 5, trajectory = 1, wait = 0.0}

l:TimelineWait(2.0)
l:TimelineSpawnBird{bird = 5, trajectory = 1, wait = 1.0}
l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 1.0}

l:TimelineWait(2.0)
l:TimelineSpawnBird{bird = 5, trajectory = 1, wait = 1.0}
l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 1.0}

l:TimelineWait(2.0)
l:TimelineSpawnBird{bird = 5, trajectory = 1, wait = 1.0}
l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 1.0}


l:TimelineWait(3.0)

l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 1.0}

l:TimelineWait(1.0)

l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 1.0}
l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 3.0}
l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 1.0}

--l:TimelineWait(3.0)

--l:TimelineSpawnBird{bird = 1, trajectory = 1, wait = 1.0}
--l:TimelineSpawnBird{bird = 1, trajectory = 2, wait = 2.0}
--l:TimelineSpawnBird{bird = 1, trajectory = 1, wait = 2.0}


return l.scene
