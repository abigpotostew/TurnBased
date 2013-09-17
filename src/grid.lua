-- A grid system for our levels. Also impliments multitouch

--http://developer.coronalabs.com/content/pinch-zoom-gesture
--Go there for multitouch (pinch, zoom) once ready.

local class = require "src.class"
local Actor = require("src.actors.actor")
--local Pollution = require "src.actors.pollution"
--local pollutionType = require "src.actors.pollutionType"
--local Building = require "src.actors.building"
--local Buildings = require "actors.buildings"
--local Energy = require "src.actors.energy"
--local Pollutions = require "actors.pollutions"

local Vector2 = require "src.vector2"
local Vector4 = require "src.vector4"

local Util = require "src.util"
local Heap = require "src.libs.heap"

local Grid = class:makeSubclass("Grid")


local tileSheetWidth = 256 --width of sheet image
local tileSheetHeight = 256 --height of sheet image

local IN = 0
local OUT = 1

Grid:makeInit(function(class, self)
	class.super:initWith(self)

	self.typeName = "grid"
    
    --Navigation stuff
    self.doubleTapMark = 0
    self.zoomState = IN
    self.zoomAmt = 0.5

	--states for touch stuff
    self.isDragging = false
    self.isZooming = false
    self.isBadPiping = false

    self.grid = {} --a 2D array of pipe informations

    self.w = sun.tileSize
    self.h = sun.tileSize
    self.halfW = self.w*0.5
    self.halfH = self.h*0.5

    --For dragging pipes
    self.startTile = nil
    self.prevTile = nil
    
    local nx = 2
    local ny = 2
    self:createTileGroup( nx, ny )
    --until multitouch zoom is implemented, just zoom out all the way.
    self.group:scale(1,1)
	self.pollutionGroup = display.newGroup( )


	self._timers = {}
	self._listeners = {}

	return self
end)

--Begin grid stuff
--TODO this should account for powerups that affect whether an actor can move to it
Grid.isTileEmpty = Grid:makeMethod(function(self, node)
	assert(Vector2:isVector2(node),"Grid:isTileEmpty() Must provide a vector2 with the grid position.")
	if node.x<=0 or node.x>sun.gridColumns or node.y<=0 or node.y>sun.gridRows then return false end
	local out = (self.grid[node.x][node.y].actor == nil)
	return out
end)

Grid.moveActor = Grid:makeMethod(function(self, oldX, oldY, newX, newY)
	assert(oldX, oldY, newX, newY, "Grid:moveActor() requires 4 parameters")
	assert(oldX>0 and oldX<=sun.gridColumns and newX>0 and newX<=sun.gridColumns and
		oldY>0 and oldY<=sun.gridRows and newY>0 and newY<=sun.gridRows, "Grid:moveActor() given out of bounds indices")
	self:boundCheck(Vector2:init(oldX,oldY),Vector2:init(newX,newY))
	if oldX==newX and oldY==newY then return end
	local a = self.grid[oldX][oldY].actor
	self.grid[newX][newY].actor=a
	self.grid[oldX][oldY].actor=nil
	self.grid[newX][newY].actor.X = newX
	self.grid[newX][newY].actor.Y = newY
end)

--Bresenhams line algorithm
Grid.bresenhams = Grid:makeMethod(function (self,start,dest)
	assert(Vector2:isVector2(start),Vector2:isVector2(dest),
		"Grid:bresenhams() requires 2 vectors")
	local x0 = start.x
	local y0 = start.y
	local x1 = dest.x
	local y1 = dest.y
	local dx = math.abs(x1-x0)
	local dy = math.abs(y1-y0) 
	local sx, sy
	if x0 < x1 then sx = 1 else sx = -1 end
	if y0 < y1 then sy = 1 else sy = -1 end
	local err = dx-dy
	local path = {}
 
	while true do
		--setPixel(x0,y0)
		table.insert(path,Vector2:init(x0,y0))
	    if x0 == x1 and y0 == y1 then
			break
		end
	    local e2 = 2*err
	    if e2 > -dy then 
	    	err = err - dy
	       	x0 = x0 + sx
	    end
	    if e2 <  dx then 
	       err = err + dx
	       y0 = y0 + sy 
	    end
	end
	return path
end)

local function distance(tileA,tileB)
	return math.sqrt((tileB.gridX-tileA.gridX)*(tileB.gridX-tileA.gridX)
        + (tileB.gridY-tileA.gridY)*(tileB.gridY-tileA.gridY)) * tileSize --mult by pixels per tile
end

Grid.createTiles = Grid:makeMethod(function(self,  x, y, xMax, yMax, group )
	local xStart = x
	local j = 0
	
    ----------------------------------
    -- Create grid sprites!!
    ----------------------------------
	
	local startX = -sun.tileWidth/2
	local startY = -sun.tileHeight/2
	for X = 1, sun.gridColumns do
        self.grid[X] = {}
		for Y = 1, sun.gridRows do
			local rect = display.newRect(self.group, X*sun.tileSize+startX, Y*sun.tileSize+startY, sun.tileWidth, sun.tileHeight)
			
            local fillColor = Vector4:init(22,168,34)
			rect.strokeWidth = 3
			--if((X+Y)%2 == 1) then 
				rect:setFillColor(fillColor:xyz())--204, 255, 255
			--else
			--	rect:setFillColor(0,153,153)
			--end
			rect:setStrokeColor(22, 103, 34)
			self.grid[X][Y] = {tile=Actor:init(),actor=nil}
            self.grid[X][Y].tile.group = self.group
            self.grid[X][Y].tile.sprite = rect
            self.grid[X][Y].tile.originalHealth = 3
            self.grid[X][Y].tile.health = 3
            self.grid[X][Y].tile.originalColor = fillColor
			rect.actor = self.grid[X][Y].tile
            self.group:insert(self.grid[X][Y].tile.sprite)
		end
	end
    
    ----------------------------------
    -- Set grid touch listener here!
    ----------------------------------

    --self.group:addEventListener('touch', tileTouchEvent)
end)


-- Place this actor into this grid group
Grid.insert = Grid:makeMethod(function(self, actor, insertIndex)
    assert(actor, "You must provide an actor when inserting an actor, ya doofus!")

    if insertIndex then
        self.group:insert(insertIndex, actor.sprite)
    else
        self.group:insert(actor.sprite)
    end
    actor.group = self.group
    actor.grid = self
end)

Grid.getActorAt = Grid:makeMethod(function(self,node)
	--self:boundCheck(node)
	if self:isWithinGrid(node) then
		return self.grid[node.x][node.y].actor
	end
	return nil
end)

Grid.getTileAt = Grid:makeMethod(function(self,node)
	--self:boundCheck(node)
	if self:isWithinGrid(node) then
		return self.grid[node.x][node.y].tile
	end
	return nil
end)

Grid.setActorAt = Grid:makeMethod(function(self,actor,gridPos)
	self:boundCheck(gridPos)
	self.grid[gridPos.x][gridPos.y].actor = actor
end)

Grid.createTileGroup = Grid:makeMethod(function(self)
	self.group = display.newGroup( ) --debugTexturesImageSheet )--self.sheet )

	self.group.xMin = -display.contentWidth
	self.group.yMin = -display.contentHeight
	self.group.xMax = sun.tileWidth
	self.group.yMax =  sun.tileWidth
	-- Groups are top left reference point by default
    
    --print('min:'..self.group.xMin..', '..self.group.yMin)
    --print('max:'..self.group.xMax..', '..self.group.yMax)
	
	----------------------------------
    -- Camera starting point
    ----------------------------------
	self.group.x = 0
	self.group.y = 0
	
	self:createTiles( self.group.xMin, self.group.yMin, self.group.xMax, self.group.yMax, self.group )
	
    
end)


Grid.dispose = Grid:makeMethod(function(self)
	self.group:removeSelf()
	self.group = nil
	self.informationText = nil
	self.selectedTileOverlay = nil
	
	for i = 1, gridColumns do
        for j = 1, gridRows do
            self.grid[i][j]:removeSelf()
			self.grid[i][j] = nil
        end
		self.grid[i] = nil
    end
	self.grid = nil
end)

-----------------------------------------------------
-- Convert touch coordinates to in game position
-- returns vector2
-----------------------------------------------------
Grid.unproject = Grid:makeMethod(function(self, screenX, screenY)
	assert(screenX and screenY,'Please provide coordinates to unproject')
    local targetx = (screenX*(1/self.group.xScale) - self.group.x + self.group.xMax)
    local targety = (screenY*(1/self.group.yScale) - self.group.y + self.group.xMax)
    return Vector2:init(targetx,targety)
end)


Grid.getPosX = Grid:makeMethod(function(self,gridX )
	return gridX*sun.tileWidth
end)

Grid.getPosY = Grid:makeMethod(function(self,gridY )
	return gridY*sun.tileWidth
end)

--More for debug purposes
Grid.boundCheck = Grid:makeMethod(function(self,...)
	for i=1, arg.n do
		local v = arg[i]
		assert(v.x>0 and v.x <= sun.gridColumns 
			and v.y>0 and v.y <= sun.gridRows,
			"Grid:boundCheck() given out of bounds indices on parameter "..i.. " with ".. v.x .. ", " .. v.y)
    end
end)

Grid.isWithinGrid = Grid:makeMethod(function(self,node)
	return ( node.x>0 and node.x <= sun.gridColumns 
		and  node.y>0 and node.y <= sun.gridRows )
end)


Grid.Astar = Grid:makeMethod(function(self,start,goal,heuristic, actor)
	--heuristic is a function that takes in this grid, the start node, and the goal node
	local function NodeRecord(connect,costsofar,estTotCost)
		return {
			--node = n, --vector2 with grid position
			connection=connect, --vector2 representing connection grid position
			costSoFar=costsofar, --number
			estimatedTotalCost=estTotCost --heuristic
		}
	end
	
	local records = self:createGridArray() --2D array for storing NodeRecords
	
	local startRecord = NodeRecord(nil,0,heuristic(self,start,goal))
	records[start.x][start.y] = startRecord
	
	local open = Heap.new(false)
	--we use estimated total cost as the key in the priority heap
	--TODO NodeRecords doesn't need estimated totalCost, that is stored as the key
	open:insert(startRecord.estimatedTotalCost,start) --TODO: careful it's not deep copying start
	local closed = Heap.new(false)
	
	--loop vairables
	local currentNode, currentRecord
	local iteration = 0
	while open:size()>0 do
		iteration=iteration+1
		currentNode = open:minimum().v -- v is the node vector
		currentRecord = records[currentNode.x][currentNode.y]
		
		if currentNode == goal then
			break 
		end
		
		if currentNode == Vector2:init(2,2) then
			local shit = true
		end
		local connections = self:getConnections(currentNode,actor)
		
		
		for i = 1, #connections do
			local endNode = connections[i]
			local connectionCost = 1
			local endNodeCost = currentRecord.costSoFar + connectionCost
			local endNodeHeuristic = 0
			local endNodeRecord = records[endNode.x][endNode.y]
			local skip = false
			
			if closed:findValue(endNode) then
				if (endNodeRecord.costSoFar <= endNodeCost) then
					skip = true
				else
					closed:removeValue(endNode)
					endNodeHeuristic = endNodeRecord.estimatedTotalCost -
						endNodeRecord.costSoFar
				end

			elseif open:findValue(endNode) then
				if (endNodeRecord.costSoFar <= endNodeCost) then 
					skip = true 
				else
					endNodeHeuristic = endNodeRecord.estimatedTotalCost -
						endNodeRecord.costSoFar
				end
				
			else
				endNodeRecord = NodeRecord()
				records[endNode.x][endNode.y] = endNodeRecord
				endNodeHeuristic = heuristic(self,endNode,goal)
			end
			
			if not skip then
				--Update the node
				endNodeRecord.costSoFar = endNodeCost
				endNodeRecord.connection = currentNode
				endNodeRecord.estimatedTotalCost = endNodeCost + endNodeHeuristic
				
				local index,kv = open:findValue(endNode)
				if not index then
					open:insert(endNodeRecord.estimatedTotalCost, endNode)
				--elseif kv.k < endNodeRecord.estimatedTotalCost then
					--open:decreaseKey(index, endNodeRecord.estimatedTotalCost)
				--	open:updateKeyByValue( endNode, endNodeRecord.estimatedTotalCost )
				end
			end
		end
		--Remove current from open and add to closed, using k as estimated total cost
		closed:insert(open:removeValue(currentNode).k,currentNode)
	end
	
	--We've found goal, or no more nodes to search
	if currentNode ~= goal then
		return nil
	else
		local reversePath = {}
		table.insert(reversePath,currentNode)
		while currentNode ~= start do
			table.insert(reversePath,currentRecord.connection)
			currentNode = currentRecord.connection
			currentRecord = records[currentNode.x][currentNode.y]
		end
		local path = {}
		for i=#reversePath-1, 1, -1 do --skip the first, actor already knows where it is
			table.insert(path,reversePath[i])
		end
		local out = ""
		for j=1, #path do
			out = out .. "[" .. path[j].x .. ", " .. path[j].y .. "] => "
		end
		--print(out)
		return path
	end
end)

Grid.createGridArray = Grid:makeMethod(function(self)
	local gridArray = {}
	for i = 1, sun.gridColumns do
        gridArray[i] = {}
	end
	return gridArray
end)

--Mainly used by Astar
Grid.getConnections = Grid:makeMethod(function(self,node,actor)
	local connections = {}
	local potentialConnections = {}
	table.insert(potentialConnections,Vector2:init(node.x,  node.y-1))--up
	table.insert(potentialConnections,Vector2:init(node.x,  node.y+1))--down
	table.insert(potentialConnections,Vector2:init(node.x-1,node.y  ))--left
	table.insert(potentialConnections,Vector2:init(node.x+1,node.  y))--right
	for i=1, #potentialConnections do
		if self:isWithinGrid(potentialConnections[i]) and 
		    ( (actor and ( 
                ( self:isTileEmpty(potentialConnections[i]) or
                self:canActorMoveHere(actor,potentialConnections[i]) ) 
                )  )
            or not actor) then 
			table.insert( connections,potentialConnections[i] ) 
		end
	end
	return connections
end)


Grid.canActorMoveHere = Grid:makeMethod(function(self, actor, nodeTo)
	assert(actor,"Grid:canActorMoveHere(): Must provide actor parameter.")
	local actorOther = self:getActorAt(nodeTo)
	return actor:canOverlapWith(actorOther)
end)


return Grid
--end grid stuff
