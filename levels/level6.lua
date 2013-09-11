-- Create a default level - For documentation on all available parameters, read "defaults.lua" in the levels directory!
local util = require "src.util"
local level = require "src.level"
local levelDefaults = require "levels.defaults"
local huts = require "actors.huts"
local birds = require "actors.birds"
local ammos = require "actors.ammos"

local l = level:init()
levelDefaults(l)

l.width = 1900 -- The size of the level's long direction.
l.gravity = { x = 20,  y = 99.0 } -- The level's gravitational acceleration

l.background = "art/scenery/level3_bk.png" -- The level's static background image

l:TimelineSpawnHut{hutType = huts.BrickHut(), x = 1770, y = 1210}
l:TimelineSpawnHut{hutType = huts.strawhut(), x = 1550, y = 1210}
l:TimelineSpawnHut{hutType = huts.strawhut(), x = 1350, y = 1210}
l:TimelineSpawnHut{hutType = huts.strawhut(), x = 1150, y = 1210}
--l:TimelineSpawnHut{hutType = huts.strawhut(), x = 850, y = 1210}

-- Modified ammo
l.ammoType = ammos.pan()
l.ammoType.physics.rotation = -0
l.ammoType.physics.bounce = 1.5
l.ammoType.lifeSpan = 0.5
l.ammoType.speed = 3800
l.ammoType.cooldown = 0.15

l:SetBird("BigBoss", birds.bossbird())

l:SetTrajectoryStart(1, { -- Comes in from upper left and smacks left two crates
	position = {x = 10, y = 99},
	angle = -20,
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


-- Timeline: Specify events that happen in sequence, including bird spawning

l:TimelineWait(1.0)

l:TimelineSpawnBird{bird = "BigBoss", trajectory = "Boss Side", wait = 1.5}
l:TimelineSpawnBird{bird = 5, trajectory = 1, wait = 2.5}



l:TimelineWait(2.0)

l:TimelineSpawnBird{bird = "BigBoss", trajectory = "Boss Side", wait = 2.5}
l:TimelineSpawnBird{bird = 1, trajectory = 3, wait = 1.0}

l:TimelineWait(2.0)

l:TimelineSpawnBird{bird = "BigBoss", trajectory = "Boss Side", wait = 2.5}
l:TimelineSpawnBird{bird = 5, trajectory = 1, wait = 1.0}

l:TimelineWait(2.0)

l:TimelineWait(1.0)
l:TimelineSpawnBird{bird = "BigBoss", trajectory = "Boss Side", wait = 2.0}
l:TimelineSpawnBird{bird = 4, trajectory = 2, wait = 1.0}
l:TimelineSpawnBird{bird = 4, trajectory = 1, wait = 1.0}
l:TimelineSpawnBird{bird = 4, trajectory = 1, wait = 1.0}



return l.scene
