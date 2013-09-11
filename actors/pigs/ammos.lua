local ammoType = require "src.actors.ammoType"
local easex = require "src.libs.easex"

local Ammos = {}

---------------------------------------------------------------------------
-- Ammo Defaults

local function SetDefaults(a)
	-- Ammo Anims: What the ammo looks like
	a.anims.normal = "" -- Normal anim to use for the ammo
	a.anims.explosion = "" -- Anim to play when the ammo reaches its target

	-- Ammo Sounds: What the ammo sounds like
	a.sounds.launch = "" -- Sound to play when the ammo is launched
	a.sounds.explosion = "" -- Sound to play when the ammo explodes

	-- Ammo Physics: How the ammo behaves physically, if it's set to be physically controlled
	a.physics.mass = 10 -- How much inertia the ammo has
	a.physics.friction = 1.9 -- How much much friction objects sliding against the ammo will have
	a.physics.bounce = 0.8 -- How much force objects will bounce off the ammo with. 0.0 stops the other object 1.0 launches like a pool ball
	a.physics.normalForce = 500 -- How much to push away birds that hit this object
	a.physics.antiBounce = -0.4 -- How much to slow down birds that hit this object
	a.physics.pushout = 30 -- How far to warp the bird away from the collision with the ammo

	-- Ammo Start: Where the ammo begins it's life
	a.scale = 1 -- The ammo's starting scale

	-- Ammo Transition: If the ammo uses a non-physical transition this is where you set the parameters
	a.transition.startScale = 1 -- What the projectile's scale should be when it starts the transition
	a.transition.rotation = 0 -- What the projectile's angle should be when it reaches the target
	a.transition.ease = easing.linear -- How the projectile should ease to the target. Valid values other than easing.linear are:
    	-- easing.inExpo easing.outExpo easing.inOutExpo
		-- easing.inQuad easing.outQuad easing.inOutQuad
		-- easex.easeIn easex.easeOut easex.easeInOut easex.easeOutIn
		-- easex.easeInBack easex.easeOutBack easex.easeInOutBack easex.easeOutInBack
		-- easex.easeInElastic easex.easeOutElastic easex.easeInOutElastic easex.easeOutInElastic
		-- easex.easeInBounce easex.easeOutBounce easex.easeInOutBounce easex.easeOutInBounce

	a.speed = 500 -- Starting speed of projectile in units per frame
	a.lifeSpan = 1.0

	a.cooldown = 0.3 -- How many seconds the player has to wait between shots

end

Ammos["pig"] = function()
	local a = ammoType:init()
	SetDefaults(a)

	a.anims.normal = 'art/ammo/pig/pigs_fly'
	a.anims.explosion = 'art/ammo/pig/pigs_fly_explode'

	a.sounds.launch = 'launch_pig.wav'
	a.sounds.explosion = 'subwoof.wav'

	a.speed = 2000
	a.transition.rotation = 360
	a.transition.startScale = 0.2

	a.physics.bounce = 1.15
	a.physics.mass = 50.0
	a.cooldown = 0.25
	a.lifeSpan = 0.8
	return a
end

Ammos["pillow"] = function()
	local a = ammoType:init()
	SetDefaults(a)

	a.anims.normal = 'art/ammo/pillow/pig_pillow'
	a.anims.explosion = 'art/ammo/pillow/pig_pillow_explode'

	a.sounds.launch = 'pillowhoosh.wav'
	a.sounds.explosion = 'subwoof.wav'
	a.speed = 1300
	a.physics.bounce = 0.01
	a.physics.mass = 10.0

	a.physics.antiBounce = -100.4 
	
	a.transition.rotation =-360
	a.transition.startScale = 5.8
	a.scale = 1.5
	a.cooldown = 0.05
	a.lifeSpan = 1.5

	return a
end

Ammos["pan"] = function()
	local a = ammoType:init()
	SetDefaults(a)

	a.anims.normal = 'art/ammo/pan/pan'
	a.anims.explosion = 'art/ammo/pan/pan_fry'

	a.sounds.launch = 'thud_1.wav'
	a.sounds.explosion = 'implo3.wav'

	a.speed = 1400
	a.transition.rotation =-0
	a.transition.startScale = 1.1

	a.physics.bounce = 0.81
	a.physics.mass = 10.0
	a.lifeSpan = 0.93
	a.cooldown = 0.65

	return a
end

Ammos["corn"] = function()
	local a = ammoType:init()
	SetDefaults(a)

	a.anims.normal = 'art/ammo/corn/corn'
	a.anims.explosion = 'art/ammo/corn/corn_pop'

	a.sounds.launch = 'jaw_harp.wav'
	a.sounds.explosion = 'corn_pop.wav'

	a.speed = 1800
	a.transition.rotation =0
	a.transition.startScale = 0.6

	a.physics.bounce = 1.5
	a.lifeSpan = 0.5
	a.cooldown = 0.45

	return a
end

Ammos["tomato"] = function()
	local a = ammoType:init()
	SetDefaults(a)

	a.anims.normal = 'art/ammo/tomato/tomato'
	a.anims.explosion = 'art/ammo/tomato/tomato_explode'

	a.sounds.launch = '02_tomato.wav'
	a.sounds.explosion = '01_tomato.wav'

	a.speed = 1200
	a.transition.rotation =-0
	a.transition.startScale = 0.8
	a.physics.mass = 50.0
	
	a.physics.bounce = 0.0001
	a.transition.startScale = 0.02
	a.cooldown = 0.04

	return a
end



-- Don't put anything after this line or it won't work!
return Ammos
