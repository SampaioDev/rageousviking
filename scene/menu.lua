-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")
local scene = composer.newScene()
local menugroup = display.newGroup()

function scene:create( event )
	local backgroundMusic = audio.loadStream( "soundtrack/menu.mp3" )
	local buttonAudio = audio.loadStream( "soundtrack/start-button.mp3")
	audio.play(backgroundMusic, {channel = 1, loops =-1})
	
	local background = display.newImageRect( "ui/background.jpg", 1900, 1050 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	menugroup:insert(background)

	local start = display.newImageRect( "ui/start-button.png", 500, 200 )
	start.x = display.contentCenterX + 650
	start.y = display.contentCenterY - 300
	menugroup:insert(start)

	local function startGame()
		composer.gotoScene("scene.game")
		audio.play(buttonAudio)
	end

	start:addEventListener( "tap", startGame )
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		audio.stop(1)
		--audio.pause()
	elseif ( phase == "did" ) then
		display.remove(menugroup)
 	
	end
end

scene:addEventListener( "create" )
-- scene:addEventListener( "show" )
scene:addEventListener( "hide" )
--scene:addEventListener( "destroy" )

return scene