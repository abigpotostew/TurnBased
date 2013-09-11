--Tile.lua
-- Data structure for tiles on the map

local actor = require "src.actors.actor"

local Tile = actor:makeSubclass("Tile")

local tile =
	{
    PIPE = 1, --possible need pipe id's as 1+
	NO_PIPE = -1, --can't build pipes on grid locations here
	ENERGY = -2,
	TOWER = -3,
    CITY = -4,
    BUILDING = -5, --debug
	EMPTY = -6 --a grid position that has no pipe yet
    --anything greater is a pipe ID
}

local pipe = {NONE = -1, LEFT = 0, UP = 1, RIGHT = 2, DOWN = 3}


Tile:makeInit(function(class, self, x, y, gridX, gridY)
    class.super:initWith(self)
    self.typeName 	= "tile"
    self.type       = tile.EMPTY --the type occupying this tile
    self.actor      = nil  --actor is any tyle object in this tile
    --self.sprite     = nil --SPRITE is the background on this tile
    --self.In         = nil --reference to a tile connected by pipe
    --self.Out        = nil --reference to tile connected by pipe
    self.gridX      = gridX
    self.gridY      = gridY
    
    self.sprite = self:createSprite("grass",x,y) --default background for the level
    self.sprite.tile = self
    return self
end)

Tile.canStartPipe = Tile:makeMethod(function(self,outDirection)
	--assert(outDirection,"Please provide an out direction when calling this method")
    local out = false
	--local grid = currTile.grid
	--You can start dragging a pipe when the initial touch begins on an energy source
	--or on the end of a pipe
	if (self.actor.typeName == "energy" and 
		self.actor.canStartPipe(outDirection))
		or 
		(self.type > tile.EMPTY and 
		 self.Out == nil 
		 and self.In ~= nil ) then
		out = true
	end
	return out
end)

Tile.canContinuePipe = Tile:makeMethod(function(self)
    return ( self.actor.typeName == "pipe" and
           self.actor:canContinuePipe() )
end)

Tile.canBuildHere = Tile:makeMethod(function(self)
    return self:isEmpty()
end)

Tile.x = Tile:makeMethod(function(self)
    return self.sprite.x
end)

Tile.y = Tile:makeMethod(function(self)
    return self.sprite.y
end)

Tile.isEmpty = Tile:makeMethod(function(self)
    local out = (self.type == tile.EMPTY and self.actor == nil)
    return out
end)

--assumes you've already checked whether or not this tile is empty
Tile.insert = Tile:makeMethod(function(self, tileActor)
    assert(tileActor, "You must provide an actor to insert")
    if tileActor.typeName == "building" then
        self.type = tile.BUILDING
    elseif tileActor.typeName == "energy" then
        self.type = tile.ENERGY
    elseif tileActor.typeName == "city" then
        self.type = tile.CITY
    elseif tileActor.typeName == "tower" then
        self.type = tile.TOWER
	else
        self.type = 0 --- a pipe
		--set the pipe ID here
    end
    self.actor = tileActor
	tileActor.tile = self
	--Grid should always add things to group. make sure!!
	--self.group:insert(tileActor.sprite)
end)

Tile.directionTo = Tile:makeMethod(function(self, destinationTile)
	assert(destinationTile,"Provide destination tile for this method")
	--assert(destinationTile:isA(self),"destinationTile must be a tile")
	if self:x() > destinationTile:x() then
		return pipe.LEFT
	elseif self:x() < destinationTile:x() then
		return pipe.RIGHT
	elseif self:y() > destinationTile:y() then
		return pipe.UP
	elseif self:y() < destinationTile:y() then
		return pipe.DOWN
	else
		return pipe.NONE
	end
end)

return Tile