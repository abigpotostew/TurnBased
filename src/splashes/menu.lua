local gamestate = require "src.gamestate"
local splash = require "src.splash"
local s = splash.Create()

function s:createScene(event)
	self:MakeBackground("art/menu/logo.jpg")
	self:MakeLogo("art/menu/logo2.jpg")
	if (gamestate.GetWinCount() == 0) then
		self:MakeButton("Play Now!", display.contentWidth * 0.5, display.contentHeight - 125,
			function() gamestate.ChangeState("LevelIntro") end)
	else
		self:MakeButton("Play Again!", display.contentWidth * 0.5, display.contentHeight - 175,
			function() gamestate.ChangeState("LevelIntro") end)
		self:MakeButton("Hardcore Mode!", display.contentWidth * 0.5, display.contentHeight - 125,
			function() gamestate.ChangeState("HardcoreStart") end)
	end
end

return s.scene
