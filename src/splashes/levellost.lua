local gamestate = require "src.gamestate"
local splash = require "src.splash"
local s = splash.Create()

function s:createScene(event)
	self:MakeBackground("art/menu/logo.jpg")
	self:MakeLogo("art/menu/logo2.jpg")

	local splashText = "Level Lost"
	local targetState = "LevelIntro"
	if (gamestate.IsHardcore() == true) then
		splashText = "Game Over"
		targetState = "Menu"
	end

	self:MakeButton(splashText, display.contentWidth * 0.5, display.contentHeight - 125,
		function() gamestate.ChangeState(targetState) end)
end

return s.scene
