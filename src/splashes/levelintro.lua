local gamestate  = require "src.gamestate"
local splash = require "src.splash"
local s = splash.Create()

function s:createScene(event)
	local levelData = gamestate.GetCurrentLevelData()
	print ("Level intro for \"" .. levelData.title .. "\": " .. levelData.titleImage)
	self:MakeBackground(levelData.titleImage,
		function(event)
			if (event.phase == "ended") then
				gamestate.ChangeState("LevelPlaying")
				return true
			end
		end)
end

return s.scene
