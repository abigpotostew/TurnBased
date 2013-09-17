-- Buildings
-- Remember to add this building to the level

local BuildingType = require "src.actors.buildingType"
local Building = require "src.actors.building"
local Buildings = {}
local Vector2 = require "src.vector2"
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

Buildings["petroleum"] = function(group,gridX,gridY)
    local p = createNewBuilding(group, gridX,gridY, sun.tileWidth/1.5,sun.tileHeight/1.5)
    p.sprite:setFillColor(0,0,0)
	p.sprite:setStrokeColor(0, 0, 0)
    p.age = 0 -- increments each step 
    p.currentlyDyingNodes={p:gridPos()}
    p.deadNodes={} --nodes done being infected
    
    p.updateFunc = function(self,...)
        local grid = self.grid
        local pollutionRate = 3
        self.age = self.age+1
        local removals = {}
        --all infected nodes should decrement health every step
        for i=1, #self.currentlyDyingNodes do
            local tile = grid:getTileAt(self.currentlyDyingNodes[i])
            if tile.health>0 then 
                tile.health = tile.health-1 
                local healthRatio = (tile.health / tile.originalHealth)*0.5 + 0.5
                local newColor = tile.originalColor*healthRatio
                tile.sprite:setFillColor( newColor:xyz() )
            else 
                table.insert(removals,i)
            end
        end
        for i=1, #removals do
            table.insert(self.deadNodes,self.currentlyDyingNodes[removals[i]])
            table.remove(self.currentlyDyingNodes,removals[i])
        end
        
        --infection should grow each 3 steps
        if self.age % pollutionRate == 0 then
            local gridPos = self:gridPos()
            
            local potentialNodesToInfect = {} --ooo scary
            --Populate table with possible new nodes to infect with PETROLEUM SLIME
            for i = 1, #self.deadNodes do
                Util.arrayConcatUnique(potentialNodesToInfect, grid:getConnections(self.deadNodes[i]))
            end
            
            --Add all nodes not already dead or not currently infected
            local newNodesToInfect = Util.getUniqueArray(potentialNodesToInfect,self.deadNodes)
            Util.arrayConcatUnique(self.currentlyDyingNodes, newNodesToInfect)
        end
    end
    
    return p
end



return Buildings