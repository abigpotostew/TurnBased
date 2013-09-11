local birdType = require "src.actors.birdType"

local Birds = {}

-------------------------------------------------------------------------------
-- Bird Defaults

local function SetDefaults(b)
	-- Anims: What the bird looks like
	b.anims.normal = ""										-- What the bird b.anims.normally looks like
	b.anims.hurt = ""										-- When the bird gets b.anims.hurt (hits anything for now)
	b.anims.hurtParticle = "art/explosions/sonar_explosion"	-- When the bird gets hurt spawn this particle
	b.anims.death = ""										-- When the bird dies (all causes of death for now)
	b.anims.deathParticle = "art/explosions/wings"			-- When the bird dies spawn this particle
	b.anims.hitHut = "art/explosions/sonar_explosion"		-- The graphic played when a bird hits a hut -> soon to be moved to huts

	-- Sounds: What the bird sounds like
	b.sounds.launch = "boink1.wav"		-- When a bird launches
	b.sounds.hitHut = "kung-fu.wav"	-- When a bird hits the player's base
	b.sounds.hurt = "kung-fu.wav"			-- When a bird hits something
	b.sounds.death = "kung-fu.wav"		-- When a bird dies (all causes of b.anims.death for now)

	-- Physics: How the bird acts in the physics simulator
	b.physics.mass = 2.0		-- How much b.physics.mass the bird has in kilograms
	b.physics.bounce = 0.3		-- How bouncy the bird is - 0.0 means no b.physics.bounce 1.0 means b.physics.bounce  away at full speed
	b.physics.friction = 0.3	-- How much friction the bird has when sliding on things


	-- General Bird Info
	b.scale = 0.4				-- How big the bird is compared to its normal anim size
	b.health = 13				-- How many physics hits a bird can take before it dies
	b.hurtDuration = 0.8 		-- How many seconds the b.anims.hurt anim should be held for before returning to b.anims.normal
	b.scoreScale = 1.0			-- How much to multiply scored points when hitting this bird

end

-------------------------------------------------------------------------------
-- bird1

Birds["bird1"] = function()
	local b = birdType:init()
	SetDefaults(b)

	b.anims.normal = "art/birds/bird_01"
	b.anims.hurt = "art/birds/bird_01_hit"
	b.anims.death = "art/birds/bird_01_death"

	b.sounds.hitHut = "smack_jaw.wav"	-- When a bird hits the player's base
	b.sounds.hurt = "smack_bird01.wav"			-- When a bird hits something
	
	b.physics.mass = 20.1
	b.physics.bounce = 0.9

	b.scale = 1.2
	b.health = 8 -- Holy Angry bird! (dont want to die right away)

	return b
end

-------------------------------------------------------------------------------
-- bird2

Birds["bird2"] = function()
	local b = birdType:init()
	SetDefaults(b)

	b.anims.normal = "art/birds/bird_02"
	b.anims.hurt = "art/birds/bird_02_hit"
	b.anims.death = "art/birds/bird_02_death"
	
	
	b.sounds.launch = "bird2_launch.wav"		-- When a bird launches
	b.sounds.hitHut = "smack_bird02.wav"	-- When a bird hits the player's base
	b.sounds.hurt = "smack_bird02.wav"			-- When a bird hits something
	b.sounds.death = "808_voo.wav"	
	

	b.physics.mass = 1.0
	b.physics.bounce = 0.61
	b.physics.friction = 0.0	
	b.hurtDuration = 0.5
	b.scale = 0.9
	b.health = 5

	return b
end

-------------------------------------------------------------------------------
-- bird3

Birds["bird3"] = function()
	local b = birdType:init()
	SetDefaults(b)

	b.anims.normal = "art/birds/bird_03"
	b.anims.hurt = "art/birds/bird_03_hit"
	b.anims.death = "art/birds/bird_03_death"

	b.physics.mass = 1.9
	b.physics.bounce = 0.83

	b.health = 6.9 -- silly fast die!

	b.scale = 0.4

	return b
end




-------------------------------------------------------------------------------
-- bird4

Birds["bird4"] = function()
	local b = birdType:init()
	SetDefaults(b)

	b.anims.normal = "art/birds/bird_04"
	b.anims.hurt = "art/birds/bird_04_hit"
	b.anims.death = "art/birds/bird_04_death"

	b.physics.mass = 10.0
	b.physics.bounce = 0.75
--	b.physics.bounce = 0.01
--	b.physics.friction = 0.21	
	b.scale = 1.2
	b.health = 8 -- Holy want to die after 3 hits)

	return b
end



-- bird5

Birds["bird5"] = function()
	local b = birdType:init()
	SetDefaults(b)

	b.anims.normal = "art/birds/bird_05"
	b.anims.hurt = "art/birds/bird_05_hit"
	b.anims.death = "art/birds/bird_05_death"

	b.sounds.hitHut = "smack_shock1.wav"	-- When a bird hits the player's base
--	b.sounds.hurt = "smack_bird01.wav"			-- When a bird hits something
	b.sounds.hurt = "smack_bird05.wav"			-- When a bird hits something	
	b.sounds.death = "smack_bird05.wav"	
	
	b.physics.mass = 123.0
	b.physics.bounce = 1.0

	b.scale = 1.5
	b.health = 3.2 -- Holy Angry bird! (dont want to die right away)

	return b
end



-------------------------------------------------------------------------------
-- boss

Birds["bossbird"] = function()
	local b = birdType:init()
	SetDefaults(b)

	b.anims.normal = "art/birds/bird_01"
	b.anims.hurt = "art/birds/bird_01_hit"
	b.anims.death = "art/birds/bird_01_death"

	b.physics.mass = 23.0 -- Heavy!
	b.physics.bounce = 0.9 -- Soft!

	b.scoreScale = 5.0 -- Valuable!
	b.scale = 2.7 -- Huge!
	b.health = 7 -- Strong!

	return b
end


-- Don't put anything after this line or it won't work!
return Birds

