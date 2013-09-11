-- Create a default level - For documentation on all available parameters, read "defaults.lua" in the levels directory!
local util = require 'src.util'
local level = require 'src.level'
local l = level:init()

l:SetAmmoAnims{
	normal = 'pigs_fly',
	explosion = 'pigs_fly_explode',
}

l:SetAmmoSounds{
	launch = 'pig.wav',
	explosion = 'harp_01.wav',
}

l:SetAmmoTransitionInfo{
	flightTime = nil,
	flightSpeed = 1000,
	rotation = -360 --Rotate twice counterclockwise
}

l:SetAmmoPhysics{
	bounce = 0.6, -- Launch them out of the park!
}

l:SetTrajectoryStart(1, { -- Comes in from upper left and smacks left two crates
	position = {x = 10, y = 30},
	angle = 35,
	speed = 1500,
})

l:SetTrajectoryStart(2, { -- Comes in from middle left and grazes barns in reverse order
	position = {x = 0, y = 300},
	angle = -5,
	speed = 1000,
})

l:SetTrajectoryStart(3, { -- Comes in from the top middle and hits the right two crates
	position = {x = 100, y = -10},
	angle = 30,
	speed = 1200,
})

l:GetBird(1):SetInfo{
	health = 10
}

l.gravity = { x = -6,  y = 5.0 } -- The level's gravitational acceleration
l.ammoType.cooldown = 0.4

l.width = 2000 --Huge!

-- Timeline: Specify events that happen in sequence, including bird spawning
local function SpamBirds()
	l:TimelineSpawnBird{bird = 1, trajectory = 2, wait = 0.0}
	l:TimelineSpawnBird{bird = 1, trajectory = 3, wait = 0.1}
	l:TimelineSpawnBird{bird = 1, trajectory = 1, wait = 0.2}
	l:TimelineSpawnBird{bird = 1, trajectory = 3, wait = 0.0}
	l:TimelineSpawnBird{bird = 1, trajectory = 2, wait = 0.1}
	l:TimelineSpawnBird{bird = 1, trajectory = 3, wait = 0.1}
	l:TimelineSpawnBird{bird = 1, trajectory = 1, wait = 0.0}
end

l:TimelineWait(3.0)

SpamBirds()
SpamBirds()

l:TimelineWait(2.0)

SpamBirds()
SpamBirds()

l:TimelineWait(2.0)
SpamBirds()
SpamBirds()

l:TimelineWait(2.0)
SpamBirds()
SpamBirds()

l:TimelineWait(2.0)
SpamBirds()
SpamBirds()

l:TimelineWait(2.0)
SpamBirds()
SpamBirds()

l:TimelineWait(2.0)
SpamBirds()
SpamBirds()

l:TimelineWait(2.0)

return l.scene
