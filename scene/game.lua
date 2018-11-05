local composer = require("composer")
local scene = composer.newScene()
local backgroundMusic = audio.loadStream("soundtrack/epic.mp3")
local steps = audio.loadStream("soundtrack/steps.mp3")
local textScore
local attacking
local score = 0
local warriorTable = {}
local lifes = 3
local backgroundGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

_W = display.contentWidth; -- Get the width of the screen
_H = display.contentHeight; -- Get the height of the screen
motionx = 0; -- Variable used to move character along x axis
speed = 10; -- Set Walking Speed
system.activate( "multitouch" )

function scene:create( event )
	audio.play(backgroundMusic, {channel = 3, loops =-1})
	audio.setVolume( 0.5, { channel = 3 } )
	
	local count = 0

	local background = display.newImageRect( "ui/background-game.png", 2000, 1050 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	backgroundGroup:insert(background)
	
	local sheetOptions1 = {
		width =  196.33, 
		height = 200, 
		numFrames = 36
	}
	local sheet = graphics.newImageSheet("ui/BronzeKnight.png", sheetOptions1)
	local sequences = {
		{
			name = "attacking",
			start = 3,
			count = 25,
			time = 800,
			loopCount = 0,	
			speed = speed - 20
			
		}
	}

	local sheetOptions2 = {
		width =  144, 
		height = 161, 
		numFrames = 5
	}

	local vikingSheet = graphics.newImageSheet("ui/viking-sheet.png", sheetOptions2)
	local sequences2 = {
		{
			name = "idle",
			start = 1,
			count = 1,
			loopCount = 0
		},
		{
			name = "attacking",
			start = 2,
			count = 4,
			time = 200,
			loopCount = 0,
			speed = speed - 20
		}
	}
	textScore = display.newText("Score:" ..score , 100, 200, native.systemFont, 100 )
	textScore:setFillColor( 1	, 1, 1 )
	textScore.x = display.contentCenterX
	textScore.y = display.contentCenterY - 450
	uiGroup:insert(textScore)

	local viking = display.newSprite(vikingSheet, sequences2)
	viking.x = display.contentCenterX - 800
	viking.y = display.contentCenterY + 160
	physics.addBody( viking, "static", { radius=70} )
	viking.xScale = 1.4
	viking.yScale = 1.4
	viking:setSequence("idle")
	viking:play()
	viking.name = "viking"
	mainGroup:insert(viking)

	local attackButton = display.newImageRect( "ui/attack-button.png", 200, 220 )
	attackButton.x = 1100; 
	attackButton.y = 880;
	uiGroup:insert(attackButton)

	life = display.newImageRect( "ui/3-lifes.png", 370, 130 )
	life.x = display.contentCenterX - 700
	life.y = display.contentCenterY - 420
	uiGroup:insert(life)

	local pause = display.newImageRect( "ui/pause.png", 100, 100 )
	pause.x = display.contentCenterX + 800
	pause.y = display.contentCenterY - 420
	uiGroup:insert(pause)

	local sound = display.newImageRect( "ui/soundon.png", 100, 100 )
	sound.x = display.contentCenterX + 800
	sound.y = display.contentCenterY - 300
	uiGroup:insert(sound)

	local status = "ON"
	local function toggleSound()
		if(status == "ON") then
			sound = display.newImageRect( "ui/soundoff.png", 100, 100 )
			sound.x = display.contentCenterX + 800
			sound.y = display.contentCenterY - 300
			audio.pause()
			status = "OFF"	
		else
			sound = display.newImageRect( "ui/soundon.png", 100, 100 )
			sound.x = display.contentCenterX + 800
			sound.y = display.contentCenterY - 300
			audio.resume()
			status = "ON"	
		end	
	end
	sound:addEventListener( "tap", toggleSound)

	local function stopAttack()
		attacking = 0
		local playerx = viking.x
		local playery = viking.y
		viking:removeSelf()
		viking = display.newSprite(vikingSheet, sequences2)
		viking.x = playerx
		viking.y = playery
		physics.addBody( viking, "static", { radius=70} )
		viking.xScale = 1.4
		viking.yScale = 1.4
		viking:setSequence("idle")
		viking:play()
		viking.name = "viking"
		mainGroup:insert(viking)
		physics.addBody(viking, "static", { radius=70} )
	end

	local function attack()
		attacking = 1
		local playerx = viking.x
		local playery = viking.y
		viking:removeSelf()
		viking = display.newSprite(vikingSheet, sequences2)
		viking.x = playerx
		viking.y = playery
		physics.addBody( viking, "static", { radius=70} )
		viking.xScale = 1.4
		viking.yScale = 1.4
		viking:setSequence("attacking")
		viking:play()
		viking.name = "viking"
		mainGroup:insert(viking)
		stopAtk = timer.performWithDelay(500, stopAttack)
	end
	attackButton:addEventListener( "tap", attack)

	local left = display.newImageRect( "ui/arrowL.png", 220, 220 )
	left.x = -360; left.y = 880;
	uiGroup:insert(left)

	local right = display.newImageRect( "ui/arrowR.png", 220, 220 )
	right.x = _W - 840; right.y = 880;
	uiGroup:insert(right)

	function left:touch()
		audio.play(steps, {channel = 2, loops =-1})
		audio.setVolume(1, {channel = 2})
		motionx = -speed;
	end
	left:addEventListener("touch",left)

	function right:touch()
		audio.play(steps, {channel = 2, loops =-1})
		audio.setVolume(1, {channel = 2})
		motionx = speed;
	end
	right:addEventListener("touch",right)

	local function movePlayer (event)
		viking.x = viking.x + motionx;	
	end
	movePlayerLoop = timer.performWithDelay(1, movePlayer, -1)

	local function stop (event)
		if event.phase =="ended" then
			audio.stop(2)			
			motionx = 0;
		end
	end
	Runtime:addEventListener("touch", stop )

	local function onCollision( event )
		print(event.other.name)
		if ( event.phase == "began" ) then			
			if (event.other.name == "viking") then
				if(attacking == 1) then
					score = score + 100
					textScore.text = "Score: " .. score
					event.target:removeSelf()
				else	
					event.target:removeSelf()
					lifes = lifes -1
					if(lifes < 2) then
						life = display.newImageRect( "ui/1-life.png", 370, 130 )
						life.x = display.contentCenterX - 700
						life.y = display.contentCenterY - 420
						uiGroup:insert(life)
					else if(lifes < 3) then
						life = display.newImageRect( "ui/2-lifes.png", 370, 130 )
						life.x = display.contentCenterX - 700
						life.y = display.contentCenterY - 420
						uiGroup:insert(life)
					end
					end
				end
				if(lifes <= 0) then
					life = display.newImageRect( "ui/0-life.png", 370, 130 )
					life.x = display.contentCenterX - 700
					life.y = display.contentCenterY - 420
					uiGroup:insert(life)
					composer.gotoScene("scene.game-over")	
				end
			end
		end
	end	

	local function createWarrior()
		local newWarrior = display.newSprite(sheet, sequences)
		newWarrior:play()
		newWarrior.x = display.contentCenterX + 900
		newWarrior.y = display.contentCenterY + 150
		newWarrior.xScale = 1.1
		newWarrior.yScale = 1.1
		table.insert( warriorTable, newWarrior)
		physics.addBody( newWarrior, "dynamic", { radius=70} )
		newWarrior.name = "newWarrior"
		newWarrior:addEventListener( "collision", onCollision )
		
		local whereFrom = math.random(1)
		
		if ( whereFrom == 1 ) then
			newWarrior:setLinearVelocity(-350, 0)
		end
	end
	criarInimigoLoop = timer.performWithDelay(1200, createWarrior, -1)
		
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		audio.pause()
		timer.cancel(criarInimigoLoop)
		timer.cancel(movePlayerLoop)
		Runtime:removeEventListener("touch", stop )
		display.remove(backgroundGroup)
		display.remove(uiGroup)
		display.remove(mainGroup)
		composer.removeScene("game")
	elseif ( phase == "did" ) then
		
	end
end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		composer.removeScene("scene.menu")
		composer.removeScene("scene.game-over")
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