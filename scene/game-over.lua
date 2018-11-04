local composer = require("composer")
local scene = composer.newScene()
local menugroup = display.newGroup()

function scene:create( event )
	local backgroundMusic = audio.loadStream( "soundtrack/menu.mp3" )
	local buttonAudio = audio.loadStream( "soundtrack/start-button.mp3")
	audio.play(backgroundMusic, {channel = 1, loops =-1})
	
	local background = display.newImageRect( "ui/game-over.png", 1900, 1050 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	menugroup:insert(background)

	local voltar = display.newImageRect( "ui/voltar.png", 600, 280 )
	voltar.x = display.contentCenterX + 300
	voltar.y = display.contentCenterY + 200 
    menugroup:insert(voltar)

	local jogar = display.newImageRect( "ui/start-button.png", 560, 135 )
	jogar.x = display.contentCenterX - 300
	jogar.y = display.contentCenterY + 265
    menugroup:insert(jogar)

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
	menugroup:insert(sound)

	
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
		display.remove(menugroup)
		--audio.pause()
	elseif ( phase == "did" ) then
 	
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
 	
	end
end

scene:addEventListener( "create" )
-- scene:addEventListener( "show" )
scene:addEventListener( "hide" )
--scene:addEventListener( "destroy" )

return scene