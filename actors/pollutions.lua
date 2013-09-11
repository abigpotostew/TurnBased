--pollutions.lua
--Spawns pollution types

local pollutionType = require "src.actors.pollutionType"
local pollution = require "src.actors.pollution"
local Pollutions = {}

Pollutions["basic"] = function()
	local pType = pollutionType:init()
    pType.anims.normal = "pollution"
	pType.element = "basic"
	pType.speed = 10
	return pType
end

Pollutions["wind"] = function()
	local pType = pollutionType:init()
    pType.anims.normal = "pollution"
	pType.element = "wind"
	pType.speed = 5
	return pType
end

Pollutions["water"] = function()
	local pType = pollutionType:init()
    pType.anims.normal = "pollution"
	pType.speed = 5
	pType.element = "water"
	return pType
end

Pollutions["solar"] = function()
	local pType = pollutionType:init()
    pType.anims.normal = "pollution"
	pType.speed = 5
	pType.element = "solar"
	return pType
end

Pollutions["geothermal"] = function()
	local pType = pollutionType:init()
    pType.anims.normal = "pollution"
	pType.speed = 5
	pType.element = "geothermal"
	return pType
end

Pollutions["radiation"] = function()
	local pType = pollutionType:init()
    pType.anims.normal = "pollution"
	pType.speed = 5
	pType.element = "radiation"
	return pType
end

Pollutions["Hybrid"] = function()
	local pType = pollutionType:init()
    pType.anims.normal = "pollution"
	pType.speed = 5
	return pType
end


return Pollutions