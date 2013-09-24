-- Buildings
-- Remember to add this building to the level

local BuildingType = require "src.actors.buildingType"
local Building = require "src.actors.building"
local Buildings = {}
local Vector2 = require "src.vector2"
local Vector4 = require 'src.vector4'
local Util = require "src.util"

function createNewBuilding(group,gridX,gridY,w,h)
    w = w or sun.tileWidth
    h = h or sun.tileHeight
    local b = Building:init(group,gridX,gridY)
    b:createRectangleSprite(w, h)
    return b
end

Buildings["wall"] = function(group,gridX,gridY)
	local b = createNewBuilding(group,gridX,gridY)
	b.sprite:setFillColor(145,32,32)
	b.sprite:setStrokeColor(200, 200, 200)
	
	return b
end

Buildings["generic-expanding"] = function(group,gridX,gridY, w, h)
    local p = createNewBuilding(group, gridX,gridY, w, h)
    p.sprite:setFillColor(255,255,255)
	p.sprite:setStrokeColor(0, 0, 0)
    p.age = -1 -- increments each step 
    p.currentlyDyingNodes={p:gridPos()}
    p.deadNodes={} --nodes done being infected
    p.newlyDeadNodes = {}
    p.pollutionRate = 3
    p.expansionLimit = 4*p.pollutionRate
    p.bleedColor = Vector4:init(255,255,255) --white default
    
    p.updateFunc = function(self,...)
        local grid = self.grid
        local pollutionRate = self.pollutionRate
        self.age = self.age+1
        local removals = {}
        --all infected nodes should decrement health every step
        for i=1, #self.currentlyDyingNodes do
            local tile = grid:getTileAt(self.currentlyDyingNodes[i])
            if tile.health>0 then 
                tile.health = tile.health - 1 
                local healthRatio = (1-(tile.health / 
                    tile.originalHealth)*0.75+0.25)
                tile.currentColor = tile.currentColor or 
                                    Vector4:init(tile.originalColor)
                tile.currentColor:set(Util.mixColors( 
                        tile.currentColor, self.bleedColor ) )
                tile.sprite:setFillColor( tile.currentColor:xyz() )
            else 
                table.insert(removals,i)
            end
        end
        
        for i=#removals, 1, -1 do
            local deadNode = self.currentlyDyingNodes[removals[i]]
            --Add removals to dead lists
            table.insert(self.deadNodes, deadNode)
            table.insert(self.newlyDeadNodes, deadNode)
            --Loop in reverse so removing doesn't shift indices around
            table.remove(self.currentlyDyingNodes, removals[i])
        end
        
        --infection should grow each 3 steps
        if self.age < self.expansionLimit and 
           self.age % pollutionRate == 0 then
            local gridPos = self:gridPos()
            
            local potentialNodesToInfect = {} --ooo scary
            --Populate table with possible new nodes to infect with PETROLEUM SLIME
            for i = 1, #self.newlyDeadNodes do
                Util.arrayConcatUnique(potentialNodesToInfect, grid:getConnections(self.newlyDeadNodes[i]))
            end
            self.newlyDeadNodes = {} --clear it!
            
            --Util.arrayConcat(potentialNodesToInfect,self.deadNodes)
            --Add all nodes not already dead or not currently infected
            local newNodesToInfect = Util.arrayNot(potentialNodesToInfect,self.deadNodes)
            Util.arrayConcatUnique(self.currentlyDyingNodes, newNodesToInfect)
        end
    end
    
    return p
end


Buildings["petroleum"] = function(group,gridX,gridY)
    local p = Buildings["generic-expanding"](group,gridX,gridY,
        sun.tileWidth/1.5,sun.tileHeight/1.5)
    p.sprite:setFillColor(0,0,0)
	p.sprite:setStrokeColor(0, 0, 0)
    p.pollutionRate = 3
    p.expansionLimit = 5*p.pollutionRate
    p.bleedColor:set(90,50,0) --white default
    return p
end

Buildings["microgrid"] = function(group,gridX,gridY)
    
    local p = Buildings["generic-expanding"](group,gridX,gridY,
        sun.tileWidth/1.8,sun.tileHeight/1.8)
    p.sprite:setFillColor(0,41,239)
	p.sprite:setStrokeColor(255,255,255)
    p.pollutionRate = 2 --must be greater than 1
    p.expansionLimit = 5*p.pollutionRate
    p.bleedColor:set(102,204,255) --sky blue
    
    return p
end


return Buildings