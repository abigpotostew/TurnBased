--------------------------------------------------
-- sun.lua 
-- Holds global constants and variables
-- (and is the local gravity system 'round here)
--------------------------------------------------

local Sun = {
	pipeLength 					= 100,
	pipeLength2					= 10000,
	pipeInset 					= 13,
	newPipeDistance 			= 90,
	removePipeTouchDistance2 	= 1/16,
	pipeRotationOffset			= 180, 		--So pipe is oriented correctly
	doubleTapTime				= 500,
    doubleTapMaxDist            = 20, --px
	
    gridColumns = 7, -- number of grid tiles across
    gridRows = 7, -- number of grid tiles down
    moveTime = 250, --milliseconds to move one grid space
	
}
	Sun.tileSize = display.contentHeight/Sun.gridColumns * 0.85
    Sun.tileWidth = Sun.tileSize --we have square tiles
    Sun.tileHeight = Sun.tileSize --we have square tiles

return Sun