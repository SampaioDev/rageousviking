-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")

local scene = composer.newScene()

function scene:create( event )
	local backgroundMusic = audio.loadStream( "soundtrack/menu.mp3" )
	local buttonAudio = audio.loadStream( "soundtrack/start-button.mp3")
	audio.play(backgroundMusic, {channel = 1, loops =-1})

	local background = display.newImageRect( "scene/menu/img/background.jpg", 1900, 1050 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local start = display.newImageRect( "scene/menu/img/start-button.png", 500, 200 )
	start.x = display.contentCenterX + 650
	start.y = display.contentCenterY - 300

	local function startGame()
		composer.gotoScene("scene.game")
		audio.play(buttonAudio)
	end

	start:addEventListener( "tap", startGame )
end

function scene:destroy( event )
	
end

scene:addEventListener( "create" )
-- scene:addEventListener( "show" )
-- scene:addEventListener( "hide" )
scene:addEventListener( "destroy" )

return scene