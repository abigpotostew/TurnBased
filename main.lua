
require("mobdebug").start()

sun = require 'src.sun'
local util = require("src.util")

print( system.getInfo( "maxTextureSize" ) )

--util.DeclareGlobal("Vector2")
--Vector2 = require "src.vector2"

-- Disable undeclared globals
--[[ setmetatable(_G, {
	__newindex = function(_ENV, var, val)
		if var ~= 'tableDict' then
			error(("attempt to set undeclared global \"%s\""):format(tostring(var)), 2)
		else
			rawset(_ENV, var, val)
		end
	end,
	__index = function(_ENV, var)
		if var ~= 'tableDict' then
			error(("attempt to read undeclared global \"%s\""):format(tostring(var)), 2)
		end
	end,
}) ]]--


-- Some globals set by various corona modules
-- Widget adds some globals
util.DeclareGlobal("sprite")
util.DeclareGlobal("physics")

--local pipe = {NONE = -1, LEFT = 0, UP = 1, RIGHT = 2, DOWN = 3}

--util.DeclareGlobal("pipe")
util.DeclareGlobal("debugTexturesSheetInfo")
util.DeclareGlobal("debugTexturesImageSheet")
debugTexturesSheetInfo = require("data.debug-textures")
debugTexturesImageSheet = graphics.newImageSheet( "data/debug-textures.png", debugTexturesSheetInfo:getSheet() )

--util.DeclareGlobal("debugTexturesImageSheet")
--util.DeclareGlobal("debugTexturesSheetInfo")

io.output():setvbuf('no') -- Allows print statements to appear on iOS console output
display.setStatusBar(display.HiddenStatusBar) -- hide the status bar


--Initialize screen orienation stuff
local screen = require("src.screen")

--local gamestate = require "src.gamestate"

--create our grid
local Level = require "src.level"
local level = Level:init()
level:createScene()


--print FPS info
--local prevTime = system.getTimer()
--local fps = display.newText( "30", 30, 47, nil, 24 )
--fps:setTextColor( 255 )
--fps.prevTime = prevTime

--local function enterFrame( event )
--	local curTime = event.time
--	local dt = curTime - prevTime
--	prevTime = curTime
--	if ( (curTime - fps.prevTime ) > 100 ) then
--		-- limit how often fps updates
--		fps.text = string.format( '%.2f', 1000 / dt )
--		--print(string.format("<%8.02f, %8.02f>", grid.group.x ,grid.group.y))
--	end
--end
--Runtime:addEventListener( "enterFrame", enterFrame )
--end print FPS info


local launchArgs = ...

local function printURL( url )
	print( url ) -- output: coronasdkapp://mycustomstring
end

if launchArgs and launchArgs.url then
	printURL( launchArgs.url )
end

local function onSystemEvent( event )
	if event.type == "applicationOpen" and event.url then
		printURL( event.url )
	end
end

Runtime:addEventListener( "system", onSystemEvent )

io.output():setvbuf('no') -- Allows print statements to appear on iOS console output

