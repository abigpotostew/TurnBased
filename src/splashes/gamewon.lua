local score = require "src.score"
local gamestate = require "src.gamestate"
local splash = require "src.splash"
local s = splash.Create()

function s:createScene(event)
	self:MakeBackground("art/menu/logo.jpg")
	self:MakeLogo("art/menu/logo2.jpg")
	self:MakeButton("Game Won", display.contentWidth * 0.5, display.contentHeight - 125,
		function() gamestate.ChangeState("Menu") end)

	local scoreText = string.format("Your Score: %i", score.GetScore())
	local scoreDisplay = display.newText(scoreText, 0, 0, "Helvetica", 32)
	scoreDisplay.x = display.contentWidth / 2
	scoreDisplay.y = display.contentHeight / 2 - 18
	scoreDisplay:setTextColor(220, 220, 220)
	self.scene.view:insert(scoreDisplay)
end

return s.scene
