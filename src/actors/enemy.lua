-- Enemy Generic!!
local actor = require("src.actors.actor")
local Vector2 = require ("src.vector2")
local Enemy = actor:makeSubclass("Enemy")

Enemy:makeInit(function(class, self, group, gridX, gridY)
	assert(group,gridX,gridY,"Please provide all parameters!")
	class.super:initWith(self, gridX, gridY)
	self.typeInfo = {}
	
	self.typeName = "enemy"
	
	local  posX, posY = self.X*sun.tileWidth, self.Y*sun.tileHeight
	
	--self.sprite = self:createSprite(self.typeInfo.anims.normal,x,y)
	self.sprite = display.newRect(group, posX-sun.tileWidth/3, posY-sun.tileHeight/3, 2*sun.tileWidth/3, 2*sun.tileHeight/3)
	self.sprite.actor = self
	self.sprite:setFillColor(200,10,50)
	self.sprite:setStrokeColor(10, 200, 10)
	
	self.movementFunc = function(a, grid, callback)
		local heuristicManhattens = function(grid,start,goal)
			local path = grid:bresenhams(start,goal)
			return #path - 1 --subtract one because bresenhams includes the start position
		end
		
		local path = grid:Astar(a:gridPos(),grid.player:gridPos(),heuristicManhattens, self)
		local dest = path[1] - self:gridPos()
		self.destX = dest.x
		self.destY = dest.y
		return true
	end
	
	return self
end)

return Enemy