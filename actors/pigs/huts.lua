local hutType = require "src.actors.hutType"

local Huts = {}

-- The Straw Hut- 3 smacks to bash my chin in-
Huts["strawhut"] = function()
	local h = hutType:init()

	h.anims.start ="art/huts/strawhut_hold1"
	h.anims.death = "art/huts/strawhut_death"

	h.hitHoldAnims = {
		{ hit = "art/huts/strawhut_hit1", hold = "art/huts/strawhut_hold1" },
		{ hit = "art/huts/strawhut_hit2", hold = "art/huts/strawhut_hold2" },
	}

	return h
end


-- The Brick Hut- 5 smacks to bash my chin in-
Huts["BrickHut"] = function()
	local h = hutType:init()

	h.anims.start = "art/huts/brickhut_hold1"
	h.anims.death = "art/huts/brickhut_death"

	h.hitHoldAnims = {
		{ hit = "art/huts/brickhut_hit1", hold = "art/huts/brickhut_hold1" },
		{ hit = "art/huts/brickhut_hit2", hold = "art/huts/brickhut_hold2" },
	}

	return h
end


-- Don't put anything after this line or it won't work!
return Huts
