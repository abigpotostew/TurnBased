local util = require "src.util"
local birds = require "actors.birds"

-- This file sets default anims, sounds, bird types, etc. for every level. Each level file may freely override any defaults set here.
return function(l)
	---------------------------------------------------------------------------
	-- Birds: Which birds are assigned to what names in the level
	-- You can edit birds by editing the files in src/birdTypes
	l:SetBird(1, birds["bird1"]())
	l:SetBird(2, birds["bird2"]())
	l:SetBird(3, birds["bird3"]())
	l:SetBird(4, birds["bird4"]())
	l:SetBird(5, birds["bird5"]())

	---------------------------------------------------------------------------
	-- Trajectories: Control data for the paths birds take through the level

	l:SetTrajectoryStart(1, {
		position = {x = 0, y = 60},	-- The position (offscreen) where the bird starts
		angle = 15,					-- The angle (degrees clockwise from straight to the right) that the bird will head
		speed = 400,				-- How fast the bird will be moving
	})

	---------------------------------------------------------------------------
	-- Miscellaneous Level Data

	l.background = "art/scenery/level2_bk.png" -- The level's static background image
	l.width = 500 -- The size of the level's long direction. Height will be scaled accordingly
	l.gravity = { x = 0,  y = 18.5 } -- The level's gravitational acceleration
	l.groundFriction = 0.3 -- How much friction the level's ground has
	l.groundBounce = 0.2 -- How bouncy the level's ground is

	l.ammoType = nil -- The ammo to use for the level
	l.ammoTypeStart = { x = 100, y = 100 } -- The ammo's starting position, relative to the bottom right of the level
end
