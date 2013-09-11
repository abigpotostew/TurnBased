-- Create a default level - For documentation on all available parameters, read "defaults.lua" in the levels directory!
local util = require "src.util"
local level = require "src.level"
local levelDefaults = require "levels.defaults"
local huts = require "actors.huts"
local birds = require "actors.birds"
local ammos = require "actors.ammos"

local l = level:init()
levelDefaults(l)

l.gravity = { x = 5,  y = 32.3 } -- The level's gravitational acceleration
l.width = 2500 -- The size of the level's long direction.

l.background = "art/scenery/level1_bk.png" -- The level's static background image

l.ammoType = ammos.pig()

l:SetTrajectoryStart(1, { -- Comes in from upper left and smacks left two crates
	position = {x = 50, y = 30},
	angle = 8,
	speed = 400,
})

l:SetTrajectoryStart(2, { -- Comes in from middle left and grazes barns in reverse order
	position = {x = 0, y = 150},
	angle = -5,
	speed = 440,
})

l:SetTrajectoryStart(3, { -- Comes in from the top middle and hits the right two crates
	position = {x = 100, y = -10},
	angle = 20,
	speed = 300,
})

l:TimelineSpawnHut{hutType = huts.BrickHut(), x = 2100, y = 1600}
--l:TimelineSpawnHut{hutType = huts.strawhut(), x = 1100, y = 940}

-- Timeline: Specify events that happen in sequence, including bird spawning
l:TimelineWait(1.0)

l:TimelineSpawnBird{bird = 3, trajectory = 3, wait = 0.1}
l:TimelineSpawnBird{bird = 3, trajectory = 3, wait = 0.5}
l:TimelineSpawnBird{bird = 3, trajectory = 3, wait = 0.5}
l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 1.5}
l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 0.5}
l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 0.5}

l:TimelineWait(8.0)

l:TimelineSpawnBird{bird = 3, trajectory = 3, wait = 0.1}
l:TimelineSpawnBird{bird = 3, trajectory = 3, wait = 0.5}
l:TimelineSpawnBird{bird = 3, trajectory = 3, wait = 0.5}
l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 1.5}
l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 0.5}
l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 0.5}

l:TimelineWait(8.0)

l:TimelineSpawnBird{bird = 3, trajectory = 2, wait = 0.5}
l:TimelineSpawnBird{bird = 3, trajectory = 3, wait = 0.5}
l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 1.5}
l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 0.5}
l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 0.5}

l:TimelineWait(8.0)

l:TimelineSpawnBird{bird = 3, trajectory = 2, wait = 1.5}
l:TimelineSpawnBird{bird = 3, trajectory = 3, wait = 0.5}
l:TimelineSpawnBird{bird = 3, trajectory = 3, wait = 0.5}
l:TimelineSpawnBird{bird = 3, trajectory = 3, wait = 0.5}
l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 0.5}
l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 0.5}
l:TimelineSpawnBird{bird = 5, trajectory = 2, wait = 0.5}


return l.scene
