-- player class

-- Pipe 

local Vector2 = require "src.vector2"

local actor = require "src.actors.actor"

local Player = actor:makeSubclass("Player")


Player:makeInit(function(class, self, gridX, gridY)
    --assert(tile,"You must initialize this pipe with a tile in the constructor!")
    class.super:initWith(self, gridX, gridY)--pipes are 1x1 by default
    
    self.typeName = "player"
    --self.typeInfo =  {physics={category = self.typeName, colliders={"pipeOverlay"}}}
	
	self.sprite = self:createSprite('pollution_geothermal',sun.tileWidth*gridX,sun.tileHeight*gridY)
	
	self.sprite.actor = self
	
    self.movementFunc = function(a, grid, callback)
		if grid:isTileEmpty( Vector2:init( a.X + a.destX, a.Y + a.destY ) ) then
			--grid:moveActor(a.X,a.Y,a.X+a.destX,a.Y+a.destY)
			--transition.to(a.sprite,{onComplete=callback, x = grid:getPosX(a.X), y = grid:getPosY(a.Y), time=sun.moveTime } )
			--print("start:",a.X-a.destX,a.Y-a.destY,"destination:",a.X,a.Y)
			return true
		end
		return false
	end
	
	self.movements = 1
	
    return self
end)

return Player