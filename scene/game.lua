local composer = require("composer")
local paused = false
local scene = composer.newScene()
local textScore
local attacking
local score = 0
local warriorTable = {}
local arrowTable = {}
local waveTable = {}
local lifes = 3
local backgroundGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()
local physics = require( "physics" )
local position = "R"
--physics.setDrawMode("hybrid")
physics.start()
physics.setGravity( 0, 0 )
local collisionFilter1 = {groupIndex = -1}

_W = display.contentWidth; -- Get the width of the screen
_H = display.contentHeight; -- Get the height of the screen
motionx = 0; -- Variable used to move character along x axis
speed = 10; -- Set Walking Speed
system.activate( "multitouch" )

function scene:create( event )

	local backgroundMusic = audio.loadStream("soundtrack/epic.mp3")
	audio.play(backgroundMusic, {channel = 2, loops =-1})
	
	local count = 0

	local leftBlock = display.newRect(-550, 700, 5, 200)
	physics.addBody(leftBlock, "static",{density = 3.0 , filter = collisionFilter1})
	backgroundGroup:insert(leftBlock)

	local rightBlock = display.newRect(1280, 700, 5, 200)
	physics.addBody(rightBlock, "static",{density = 3.0 , filter = collisionFilter1})
	backgroundGroup:insert(rightBlock)

	local background = display.newImageRect( "ui/background-game.png", 2000, 1050 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	backgroundGroup:insert(background)

	local sheetOptions1 = {
		width =  144, 
		height = 161, 
		numFrames = 5
	}
	local sheet = graphics.newImageSheet("ui/enemie-sprite.png", sheetOptions1)
	local sequences = {
		{
			name = "attacking",
			start = 1,
			count = 5,
			time = 400,
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

	local sheetOptions3 = {
		width =  99, 
		height = 161, 
		numFrames = 8
	}

	local vikingWalking = graphics.newImageSheet("ui/viking-walking.png", sheetOptions3)
	local sequences3 = {
		{
			name = "walking",
			start = 1,
			count = 8,
			time = 400,
			loopCount = 0
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
	physics.addBody( viking, "dynamic", { density = 3.0 } )
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
	pause.x = display.contentCenterX + 820
	pause.y = display.contentCenterY - 430
	uiGroup:insert(pause)

	local resume = display.newImageRect( "ui/resume.png", 100, 100 )
	resume.x = display.contentCenterX + 820
	resume.y = display.contentCenterY - 430
	resume.isVisible = false
	uiGroup:insert(resume)

	local sound = display.newImageRect( "ui/soundon.png", 100, 100 )
	sound.x = display.contentCenterX + 820
	sound.y = display.contentCenterY - 300
	uiGroup:insert(sound)

	local status = "ON"
	local function toggleSound()
		if(status == "ON") then
			sound = display.newImageRect( "ui/soundoff.png", 100, 100 )
			sound.x = display.contentCenterX + 820
			sound.y = display.contentCenterY - 300
			uiGroup:insert(sound)
			audio.pause()
			status = "OFF"	
		else
			sound = display.newImageRect( "ui/soundon.png", 100, 100 )
			sound.x = display.contentCenterX + 820
			sound.y = display.contentCenterY - 300
			uiGroup:insert(sound)
			audio.resume()
			status = "ON"	
		end	
	end
	sound:addEventListener( "tap", toggleSound)

	local function stopAttack()
		if(paused == false) then
			if(position == "R") then
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
			else if(position == "L") then
				attacking = 0
				local playerx = viking.x
				local playery = viking.y
				viking:removeSelf()
				viking = display.newSprite(vikingSheet, sequences2)
				viking.x = playerx
				viking.y = playery
				physics.addBody( viking, "static", { radius=70} )
				viking.xScale = -1.4
				viking.yScale = 1.4
				viking:setSequence("idle")
				viking:play()
				viking.name = "viking"
				mainGroup:insert(viking)
				physics.addBody(viking, "static", { radius=70} )
			end
			end
		end
	end

	local function attack()
		if(position == "R") then
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
		else if(position == "L") then
			attacking = 1
			local playerx = viking.x
			local playery = viking.y
			viking:removeSelf()
			viking = display.newSprite(vikingSheet, sequences2)
			viking.x = playerx
			viking.y = playery
			physics.addBody( viking, "static", { radius=70} )
			viking.xScale = -1.4
			viking.yScale = 1.4
			viking:setSequence("attacking")
			viking:play()
			viking.name = "viking"
			mainGroup:insert(viking)
			stopAtk = timer.performWithDelay(500, stopAttack)
		end
		end	
	end
	attackButton:addEventListener( "tap", attack)

	local left = display.newImageRect( "ui/arrowL.png", 220, 220 )
	left.x = -360; left.y = 880;
	uiGroup:insert(left)

	local right = display.newImageRect( "ui/arrowR.png", 220, 220 )
	right.x = _W - 840; right.y = 880;
	uiGroup:insert(right)

	function left:touch()
		if(paused == false) then 
			position = "L"
			local playerx = viking.x
			local playery = viking.y
			viking:removeSelf()
			viking = display.newSprite(vikingSheet, sequences2)
			viking.x = playerx
			viking.y = playery
			physics.addBody( viking, "static", { radius=70} )
			viking.xScale = -1.4
			viking.yScale = 1.4
			viking:setSequence("idle")
			viking:play()
			viking.name = "viking"
			mainGroup:insert(viking)
			motionx = -speed;
		end
	end
	left:addEventListener("touch",left)

	function right:touch()
		if(paused == false) then
			position = "R"
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
			motionx = speed;
		end
	end
	right:addEventListener("touch",right)

	local function movePlayer (event)
		viking.x = viking.x + motionx;	
	end
	movePlayerLoop = timer.performWithDelay(1, movePlayer, -1)

	local function stop (event)
		if event.phase =="ended" then		
			motionx = 0;
		end
	end
	Runtime:addEventListener("touch", stop )

	local function onCollision( event )
		print(event.other.name)
		if ( event.phase == "began" ) then			
			if (event.other.name == "viking" and event.target.name == "newWarrior" or event.other.name == "viking" and event.target.name == "flecha") then
				if(attacking == 1 and event.target.name == "newWarrior" and position == "R") then
					score = score + 100
					textScore.text = "Score: " .. score
					event.target:removeSelf()
					for i = #warriorTable, 1, -1 do
						if ( warriorTable[i] == event.target or warriorTable[i] == event.other ) then
							table.remove( warriorTable, i )
							break
						end
					end
				else	
					event.target:removeSelf()
					for i = #warriorTable, 1, -1 do
						if ( warriorTable[i] == event.target or warriorTable[i] == event.other ) then
							table.remove( warriorTable, i )
							break
						end
					end
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
					composer.setVariable( "finalScore", score )
					composer.gotoScene("scene.highscore")	
				end
			else if(event.other.name == "viking" and event.target.name == "newWarrior2") then
				if(attacking == 1 and event.target.name == "newWarrior2" and position == "L") then
					score = score + 100
					textScore.text = "Score: " .. score
					event.target:removeSelf()
					for i = #warriorTable, 1, -1 do
						if ( warriorTable[i] == event.target or warriorTable[i] == event.other ) then
							table.remove( warriorTable, i )
							break
						end
					end
				else	
					event.target:removeSelf()
					for i = #warriorTable, 1, -1 do
						if ( warriorTable[i] == event.target or warriorTable[i] == event.other ) then
							table.remove( warriorTable, i )
							break
						end
					end
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
					composer.setVariable( "finalScore", score )
					composer.gotoScene("scene.highscore" )	
				end
			end
			end
		end
	end	

	local function createWarrior()
		newWarrior = display.newSprite(sheet, sequences)
		newWarrior:play()
		newWarrior.x = display.contentCenterX + 900
		newWarrior.y = display.contentCenterY + 170
		newWarrior.xScale = -1.1
		newWarrior.yScale = 1.3
		table.insert( warriorTable, newWarrior)
		physics.addBody( newWarrior, "dynamic", { radius=70, filter = collisionFilter1} )
		newWarrior.name = "newWarrior"
		newWarrior:addEventListener( "collision", onCollision )
		mainGroup:insert(newWarrior)
		
		local whereFrom = math.random(1)
		
		if ( whereFrom == 1 ) then
			newWarrior:setLinearVelocity(-350, 0)
			if(score >= 1000) then
				newWarrior:setLinearVelocity(-300, 0)
			end
		end
	end
	criarInimigoLoop = timer.performWithDelay(1200, createWarrior, -1)

	local function createWarrior2()
		if(score >= 2000) then 
			newWarrior2 = display.newSprite(sheet, sequences)
			newWarrior2:play()
			newWarrior2.x = display.contentCenterX - 900
			newWarrior2.y = display.contentCenterY + 170
			newWarrior2.xScale = 1.1
			newWarrior2.yScale = 1.3
			table.insert( warriorTable, newWarrior2)
			physics.addBody( newWarrior2, "dynamic", { radius=70, filter = collisionFilter1} )
			newWarrior2.name = "newWarrior2"
			newWarrior2:addEventListener( "collision", onCollision )
			mainGroup:insert(newWarrior2)
			
			local whereFrom = math.random(1)
			
			if ( whereFrom == 1 ) then
				newWarrior2:setLinearVelocity(300, 0)
			end
		end
	end
	criarInimigoLoop2 = timer.performWithDelay(2000, createWarrior2, -1)

	local function createArrow()
		if(score >= 1000 and score <= 2000) then
			local flecha = display.newImageRect("ui/flecha.png", 30, 140)
			flecha.x = math.random(_W)  
			flecha.y = display.contentCenterY - 440
			flecha.name = "flecha" 
			mainGroup:insert(flecha)
			table.insert( arrowTable, flecha)
			physics.addBody( flecha, "dynamic", {filter = collisionFilter1} )
			flecha:addEventListener( "collision", onCollision )
			
			local whereFrom = math.random(1)
			
			if ( whereFrom == 1 ) then
				flecha:setLinearVelocity(0, 400)
			end
		end
		if(score >= 3000) then
			local flecha = display.newImageRect("ui/flecha.png", 30, 140)
			flecha.x = math.random(_W)  
			flecha.y = display.contentCenterY - 440
			flecha.name = "flecha" 
			mainGroup:insert(flecha)
			table.insert( arrowTable, flecha)
			physics.addBody( flecha, "dynamic", {filter = collisionFilter1} )
			flecha:addEventListener( "collision", onCollision )
			
			local whereFrom = math.random(1)
			
			if ( whereFrom == 1 ) then
				flecha:setLinearVelocity(0, 400)
			end
		end
	end
	createArrowLoop = timer.performWithDelay(400, createArrow, -1)

	local function createWave()
		wave = display.newImageRect("ui/wave.png", 140, 40)
		wave.x = display.contentCenterX + 890 
		wave.y = display.contentCenterY + 40
		wave.name = "wave" 
		mainGroup:insert(wave)
		table.insert( waveTable, wave)
		physics.addBody( wave, "dynamic", {filter = collisionFilter1} )
		local count = math.random(1)
		if ( count == 1) then
			wave:setLinearVelocity(-280, 0)
		end
	end
	createWaveLoop = timer.performWithDelay(1300, createWave, -1)

	local function createWave2()
		wave = display.newImageRect("ui/wave.png", 140, 40)
		wave.x = display.contentCenterX + 880 
		wave.y = display.contentCenterY - 15 
		wave.name = "wave" 
		mainGroup:insert(wave)
		table.insert( waveTable, wave)
		physics.addBody( wave, "dynamic", {filter = collisionFilter1} )
		local count = math.random(1)
		if ( count == 1) then
			wave:setLinearVelocity(-200, 0)
		end
	end
	createWaveLoop2 = timer.performWithDelay(2000, createWave2, -1)

	local function createCloud()
		cloud = display.newImageRect("ui/cloud.png", 250, 100)
		cloud.x = display.contentCenterX + 880 
		cloud.y = display.contentCenterY -460 
		cloud.name = "cloud" 
		uiGroup:insert(cloud)
		table.insert( waveTable, cloud)
		physics.addBody( cloud, "dynamic", {filter = collisionFilter1} )
		local count = math.random(1)
		if ( count == 1) then
			cloud:setLinearVelocity(-200, 0)
		end
	end
	createCloudLoop = timer.performWithDelay(3500, createCloud, -1)

	local function createCloud2()
		cloud = display.newImageRect("ui/cloud.png", 250, 100)
		cloud.x = display.contentCenterX + 880 
		cloud.y = display.contentCenterY - 360 
		cloud.name = "cloud" 
		uiGroup:insert(cloud)
		table.insert( waveTable, cloud)
		physics.addBody( cloud, "dynamic", {filter = collisionFilter1} )
		local count = math.random(1)
		if ( count == 1) then
			cloud:setLinearVelocity(-220, 0)
		end
	end
	createCloudLoop2 = timer.performWithDelay(2300, createCloud2, -1)
		
	local function pauseGame()
		if (paused == false) then
			physics.pause()
			transition.pause()
			pause.isVisible = false
			resume.isVisible = true
			for i = #warriorTable, 1, -1 do
				warriorTable[i]:pause()
			end
			if(newWarrior2) then
				for i = #warriorTable, 1, -1 do
					warriorTable[i]:pause()
				end
			end
			timer.pause(criarInimigoLoop)
			timer.pause(criarInimigoLoop2)
			timer.pause(movePlayerLoop)
			timer.pause(createArrowLoop)
			timer.pause(createWaveLoop)
			timer.pause(createWaveLoop2)
			timer.pause(createCloudLoop)
			timer.pause(createCloudLoop2)			
			paused = true
		else
			physics.start()
			transition.resume()
			pause.isVisible = true
			resume.isVisible = false
			for i = #warriorTable, 1, -1 do
				warriorTable[i]:play()
			end
			if(newWarrior2) then
				for i = #warriorTable, 1, -1 do
					warriorTable[i]:pause()
				end
			end	
			timer.resume(criarInimigoLoop)
			timer.resume(criarInimigoLoop2)
			timer.resume(movePlayerLoop)
			timer.resume(createArrowLoop)
			timer.resume(createWaveLoop)
			timer.resume(createWaveLoop2)
			timer.resume(createCloudLoop)
			timer.resume(createCloudLoop2)
			paused = false
		end	
	end

	resume:addEventListener( "tap", pauseGame )
	pause:addEventListener( "tap", pauseGame )
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		audio.stop(2)
		if(stopAtk) then
			timer.cancel(stopAtk)
		end
		timer.cancel(criarInimigoLoop)
		timer.cancel(criarInimigoLoop2)
		timer.cancel(movePlayerLoop)
		timer.cancel(createArrowLoop)
		timer.cancel(createWaveLoop)
		timer.cancel(createWaveLoop2)
		timer.cancel(createCloudLoop)
		timer.cancel(createCloudLoop2)
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
		composer.removeScene("scene.highscore")
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