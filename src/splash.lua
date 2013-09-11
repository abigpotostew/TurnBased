local storyboard = require "storyboard"
local widget = require "widget"
local util = require "src.util"

local Splash = setmetatable({}, nil)

function Splash.Create()
	local splash = setmetatable({}, {__index = Splash})

	splash.scene = storyboard.newScene()
	splash.scene:addEventListener("createScene", splash)

	return splash
end

function Splash:createScene(event)
	error("You must define a createScene function on your splash object!")
end

function Splash:MakeBackground(image, onTouch)
	local background = display.newImageRect(image, display.contentWidth, display.contentHeight)
	background:setReferencePoint(display.TopLeftReferencePoint)
	background.x = 0
	background.y = 0

	self.scene.view:insert(background)

	if (onTouch) then
		background:addEventListener("touch", onTouch)
	end

	return background
end

function Splash:MakeLogo(image)
	local logo = display.newImageRect(image, 256, 42)
	logo:setReferencePoint(display.CenterReferencePoint)
	logo.x = display.contentWidth * 0.5
	logo.y = 100

	self.scene.view:insert(logo)

	return logo
end

function Splash:MakeButton(text, x, y, onClick)

	if (not util.GlobalDeclared("widgetMod")) then
		util.DeclareGlobal("widgetMod")
	end

	local button = widget.newButton{
		label = text,
		labelColor = { default = {255}, over = {128} },
		default = "art/menu/button.png",
		over = "art/menu/button-over.png",
		width = 154, height = 40,
		onRelease = onClick	-- event listener function
	}
	button.view:setReferencePoint(display.CenterReferencePoint)
	button.view.x = x
	button.view.y = y

	self.scene.view:insert(button.view)
	self.scene:addEventListener("destroyScene", function(event) button:removeSelf() end)

	return button
end

return Splash
