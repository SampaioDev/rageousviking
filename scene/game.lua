-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")
local scene = composer.newScene()
local backgroundMusic = audio.loadStream("soundtrack/epic.mp3")
local steps = audio.loadStream("soundtrack/steps.mp3")
local textScore
local score = 0
local warriorTable = {}
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
	audio.setVolume( 0.1, { channel = 3 } )
	
	local count = 0

	local background = display.newImageRect( "ui/background.png", 2600, 1100 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	backgroundGroup:insert(background)
	
	local sheetOptions = {
		width =  196.33, 
		height = 200, 
		numFrames = 36
	}
	local sheet = graphics.newImageSheet("ui/BronzeKnight.png", sheetOptions)
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

	textScore = display.newText("Score:" ..score , 100, 200, native.systemFont, 100 )
	textScore:setFillColor( 1	, 1, 1 )
	textScore.x = display.contentCenterX
	textScore.y = display.contentCenterY - 450
	
	local viking = display.newImageRect( "ui/viking.png", 220, 280)
	viking.x = display.contentCenterX - 820
	viking.y = display.contentCenterY + 130
	physics.addBody( viking, "static", { radius=70} )
	viking.name = "viking"
	mainGroup:insert(viking)

	local sword = display.newImageRect( "ui/sword.png", 200, 220 )
	sword.x = 1000; 
	sword.y = 900;
	uiGroup:insert(sword)

	local left = display.newImageRect( "ui/arrowL.png", 200, 280 )
	left.x = -360; left.y = 900;
	uiGroup:insert(left)

	local right = display.newImageRect( "ui/arrowR.png", 200, 280 )
	right.x = _W - 900; right.y = 900;
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
	Runtime:addEventListener("enterFrame", movePlayer)

	local function stop (event)
		if event.phase =="ended" then
			audio.stop(2)
			motionx = 0;
		end
		local X, Y = viking:localToContent( 0, 0 )
	end
	Runtime:addEventListener("touch", stop )

	local function onCollision( event )
		print(event.target.name)
		if ( event.phase == "began" ) then			
			if (event.other.name == "viking") then
				score = score + 100
				textScore.text = "Score: " .. score
				event.target:removeSelf()
				event.other:removeSelf()
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
		newWarrior.Name = "newWarrior"
		newWarrior:addEventListener( "collision", onCollision )
		
		local whereFrom = math.random(1)
		
		if ( whereFrom == 1 ) then
			newWarrior:setLinearVelocity(-350, 0)
		end
	end
	criarInimigoLoop = timer.performWithDelay(1000, createWarrior, -1)
	
	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		audio.pause()
	elseif ( phase == "did" ) then
 	
	end
end


scene:addEventListener( "create" )
-- scene:addEventListener( "show" )
scene:addEventListener( "hide" )
-- scene:addEventListener( "destroy" )

return scene