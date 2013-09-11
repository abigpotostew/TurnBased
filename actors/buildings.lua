-- Buildings

local buildingType = require "src.actors.buildingType"
local building = require "src.actors.building"
local Buildings = {}


Buildings["city"] = function()
	local bType = buildingType:init()
    bType.anims.normal = "city"
	bType.typeName = "city"
    bType.width = 2
    bType.height = 2
	return bType
end

Buildings["tower"] = function()
	local bType = buildingType:init()
    bType.anims.normal = "tower"
	bType.typeName = "tower"
    bType.width = 2
    bType.height = 2
	return bType
end

Buildings["coal"] = function()
	local bType = buildingType:init()
    bType.anims.normal = "energy"
	bType.typeName = "coal"
    --bType.width = 10 * 64
    --bType.height = 8 * 64
	bType.radius = 100
	
	return bType
end

Buildings["wind"] = function()
	local bType = buildingType:init()
    bType.anims.normal = "pollution_wind"
	bType.typeName = "wind"
    bType.width = 1
    bType.height = 1
	
	return bType
end

Buildings["water"] = function()
	local bType = buildingType:init()
    bType.anims.normal = "pollution_water"
	bType.typeName = "water"
    bType.width = 1
    bType.height = 1
	
	return bType
end

Buildings["solar"] = function()
	local bType = buildingType:init()
    bType.anims.normal = "pollution_solar"
	bType.typeName = "solar"
    bType.width = 1
    bType.height = 1
	
	return bType
end

Buildings["geothermal"] = function()
	local bType = buildingType:init()
    bType.anims.normal = "pollution_geothermal"
	bType.typeName = "geothermal"
    bType.width = 1
    bType.height = 1
	
	return bType
end

Buildings["radiation"] = function()
	local bType = buildingType:init()
    bType.anims.normal = "pollution_radiation"
	bType.typeName = "radiation"
    bType.width = 1
    bType.height = 1
	
	return bType
end

Buildings["hybrid"] = function()
	local bType = buildingType:init()
    bType.anims.normal = "energy" -- change later please!
	bType.typeName = "hybrid"
    bType.width = 1
    bType.height = 1
	
	return bType
end


return Buildings