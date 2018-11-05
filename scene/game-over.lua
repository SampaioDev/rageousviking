local composer = require("composer")
local scene = composer.newScene()
local mainGroup = display.newGroup()

function scene:create( event )
	local backgroundMusic = audio.loadStream( "soundtrack/menu.mp3" )
	local buttonAudio = audio.loadStream( "soundtrack/start-button.mp3")
	audio.play(backgroundMusic, {channel = 1, loops =-1})
	
	local background = display.newImageRect( "ui/game-over.png", 1900, 1050 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	mainGroup:insert(background)

	local voltar = display.newImageRect( "ui/voltar.png", 600, 280 )
	voltar.x = display.contentCenterX + 300
	voltar.y = display.contentCenterY + 200 
    mainGroup:insert(voltar)

	local jogar = display.newImageRect( "ui/start-button.png", 560, 135 )
	jogar.x = display.contentCenterX - 300
	jogar.y = display.contentCenterY + 265
    mainGroup:insert(jogar)

    local function playAgain()
        composer.gotoScene("scene.game")
    end
    jogar:addEventListener( "tap", playAgain)

	local function goToMenu()
        composer.gotoScene("scene.menu")
    end
    voltar:addEventListener( "tap", goToMenu)

	local sound = display.newImageRect( "ui/soundon.png", 100, 100 )
	sound.x = display.contentCenterX + 800
	sound.y = display.contentCenterY - 420
	mainGroup:insert(sound)

	
	local status = "ON"
	local function toggleSound()
		if(status == "ON") then
			sound = display.newImageRect( "ui/soundoff.png", 100, 100 )
			sound.x = display.contentCenterX + 800
			sound.y = display.contentCenterY - 420
			audio.pause()
			status = "OFF"	
		else
			sound = display.newImageRect( "ui/soundon.png", 100, 100 )
			sound.x = display.contentCenterX + 800
			sound.y = display.contentCenterY - 420
			audio.resume()
			status = "ON"	
		end	
	end
	sound:addEventListener( "tap", toggleSound)

end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		audio.stop(1)
		display.remove(mainGroup)
		--audio.pause()
	elseif ( phase == "did" ) then
 	
	end
end


function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		composer.removeScene("scene.game")
		composer.removeScene("scene.menu")
		-- Code here runs when the scene is still off screen (but is about to come on screen)
 
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
 
	end
end

-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
 
end

scene:addEventListener( "create" )
scene:addEventListener( "show" )
scene:addEventListener( "hide" )
scene:addEventListener( "destroy" )

return scene