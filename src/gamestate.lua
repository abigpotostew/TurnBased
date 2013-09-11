local Gamestate = setmetatable({}, nil)

local storyboard = require "storyboard"
local score = require "src.score"
local stateMachine = require "src.stateMachine"
local levelSequence = require "levels.sequence"
--local assetManager = require "src.assetManager"

local sLevelData = levelSequence();
local sCurrentLevel = 1
local sStateMachine = stateMachine.Create()
local sLastSuccessfulScore = 0
local sWinCount = 0
local sScore = 0
--local sHardcore = false
--local sBarnData = nil

function Gamestate.GetCurrentLevelData()
	--return sLevelData[sCurrentLevel]
end

function Gamestate.GetSplashData(splashName)
	--return sSplashData[splashName]
end

function Gamestate.IncrementScore(amount)
	sScore = sScore + amount
end

function Gamestate.SetScore(amount)
	sScore = amount
end

function Gamestate.GetScore(amount)
	return sScore
end

function Gamestate.DebugSetLevel(level)
	sCurrentLevel = level
end

function Gamestate.GetWinCount()
	return sWinCount
end

function Gamestate.IsHardcore()
	return sHardcore
end

function Gamestate.CacheBarnData(data)
	sBarnData = data
end

function Gamestate.FetchBarnData(data)
	return sBarnData
end

function Gamestate.ChangeState(state)
	sStateMachine:GoToState(state)
end

local function GoToSceneRemoveFirst(file)
	print ("GoToSceneRemoveFirst: " .. file)
	assetManager.popAssets()
	assetManager.pushAssets()
	storyboard.removeScene(file)
	storyboard.gotoScene(file, "fade", 500)
end

sStateMachine:SetState('Menu', {
	enter = function()
		sCurrentLevel = 1
		sHardcore = 0
		score.SetScore(0)
		GoToSceneRemoveFirst("src.splashes.menu")
	end
})

sStateMachine:SetState('HardcoreStart', {
	enter = function()
		sHardcore = 1
		sBarnData = nil
		Gamestate.ChangeState("LevelIntro")
	end
})

sStateMachine:SetState('LevelIntro', {
	enter = function()
		GoToSceneRemoveFirst("src.splashes.levelintro")
	end
})


sStateMachine:SetState('LevelPlaying', {
	enter = function()
		GoToSceneRemoveFirst(Gamestate.GetCurrentLevelData().file)
	end
})

sStateMachine:SetState('LevelPaused', {} )

sStateMachine:SetState('LevelWon', {
	enter = function()
		sLastSuccessfulScore = score.GetScore()
		sCurrentLevel = sCurrentLevel + 1

		if (sLevelData[sCurrentLevel] == nil) then
			Gamestate.ChangeState('GameWon')
		else
			Gamestate.ChangeState('LevelIntro')
		end
	end
})

sStateMachine:SetState('LevelLost', {
	enter = function()
		GoToSceneRemoveFirst("src.splashes.levellost")
	end,
	exit = function()
		score.SetScore(sLastSuccessfulScore)
	end
})

sStateMachine:SetState('GameWon', {
	enter = function()
		print("Game Won")
		sWinCount = sWinCount + 1
		GoToSceneRemoveFirst("src.splashes.gamewon")
	end
})

return Gamestate
