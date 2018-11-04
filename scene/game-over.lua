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
	
	local background = display.newImageRect( "ui/game-over.png", 1900, 1050 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	menugroup:insert(background)

	local voltar = display.newImageRect( "ui/voltar.png", 600, 280 )
	voltar.x = display.contentCenterX
	voltar.y = display.contentCenterY + 200 
    menugroup:insert(voltar)

    local function goToMenu()
        composer.goToScene("scene.menu")
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
			sound.y = display.contentCenterY - 380
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

scene:addEventListener( "create" )
-- scene:addEventListener( "show" )
scene:addEventListener( "hide" )
--scene:addEventListener( "destroy" )

return scene