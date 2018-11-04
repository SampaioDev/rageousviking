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
	
	local background = display.newImageRect( "ui/background.png", 1900, 1050 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	menugroup:insert(background)
	
	
	local wave1 = display.newImageRect( "ui/onda2.png", 1900, 300)
	wave1.x = display.contentCenterX
	wave1.y = display.contentCenterY + 390
	menugroup:insert(wave1)
	
	local haste = display.newImageRect( "ui/haste.png", 450, 400)
	haste.x = display.contentCenterX + 640
	haste.y = display.contentCenterY + 100
	menugroup:insert(haste)
	
	local viking = display.newImageRect( "ui/viking.png", 140, 200)
	viking.x = display.contentCenterX + 480
	viking.y = display.contentCenterY + 190
	menugroup:insert(viking)
	
	local ship = display.newImageRect( "ui/ship-2.png", 750, 400)
	ship.x = display.contentCenterX + 520
	ship.y = display.contentCenterY + 220
	menugroup:insert(ship)

	local wave2 = display.newImageRect( "ui/onda1.png", 1900, 400)
	wave2.x = display.contentCenterX 
	wave2.y = display.contentCenterY + 550
	menugroup:insert(wave2)

	local title = display.newImageRect( "ui/title.png", 600, 500)
	title.x = display.contentCenterX - 500
	title.y = display.contentCenterY - 150
	menugroup:insert(title)

	local start = display.newImageRect( "ui/start-button.png", 480, 100 )
	start.x = display.contentCenterX
	start.y = display.contentCenterY + 380
	menugroup:insert(start)

	local sound = display.newImageRect( "ui/soundon.png", 100, 100 )
	sound.x = display.contentCenterX + 800
	sound.y = display.contentCenterY - 380
	menugroup:insert(sound)

	
	local status = "ON"
	local function toggleSound()
		if(status == "ON") then
			sound = display.newImageRect( "ui/soundoff.png", 100, 100 )
			sound.x = display.contentCenterX + 800
			sound.y = display.contentCenterY - 380
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

	local contador = 0 
	local function moveWaves()
		if(contador >=  0 and contador < 5) then
			wave2.y = wave2.y + 4
			wave1.y = wave1.y - 1
			wave1.rotation = wave1.rotation + 0.5
			ship.rotation = ship.rotation + 0.5
			haste.rotation = haste.rotation + 0.5
			contador = contador + 1
		else if(contador >=  5) then
			wave2.y = wave2.y - 4
			wave1.y = wave1.y + 1
			wave1.rotation = wave1.rotation - 0.5
			ship.rotation = ship.rotation - 0.5
			haste.rotation = haste.rotation - 0.5
			contador = contador + 1
			if(contador >= 10) then
				contador = 0
			end
		end
		end
	end
	moveWavesLoop = timer.performWithDelay(80, moveWaves, -1)

	local function buttonPulse()
		if(contador >=  0 and contador < 5) then
			start.xScale = 1.1
			start.yScale = 1.1
		else if(contador >=  5) then
			start.xScale = 1
			start.yScale = 1
		end
		end
	end

	buttonPulseLoop = timer.performWithDelay(20, buttonPulse, -1)

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
		timer.cancel(moveWavesLoop)
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