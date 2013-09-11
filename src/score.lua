local math = require "math"

local Score = setmetatable({}, nil)

local sScore = 0
local sText = nil

function Score.GetScore()
	return sScore
end

function Score.SetScore(score)
	sScore = score
	if (sText) then
		sText:Update()
	end
end

function Score.IncrementScore(amount)
	Score.SetScore(sScore + amount)
end

function Score.CreateScoreIndicator(group)
	sText = display.newText("0", -10, -10, "Helvetica", 32)
	sText:setTextColor(220, 220, 255)
	sText.Update = function(self)
		self.text = string.format("%i", sScore)
		self:setReferencePoint(display.TopRightReferencePoint)
		self.x = display.contentWidth - 5
		self.y = 0
	end

	sText:Update()
	return sText
end

function Score.IncrementAndShowPoints(x, y, amount, group)
	Score.IncrementScore(amount)

	local text = display.newText(string.format("%i", amount), 0, 0, "Helvetica", 09)
	text.x = x
	text.y = y

	local angle = math.random(0, 4*math.pi)

	transition.to(text, {
		time = 1500,
		x = x + math.cos(angle) * 50,
		y = y + math.sin(angle) * 50,
		alpha = 0,
		onComplete = function()
			text:removeSelf()
		end})

	group:insert(text)
	return text
end

return Score
