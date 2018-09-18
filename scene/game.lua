-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")
local scene = composer.newScene()
local textScore
local score = 0
local timerCount
local warriorTable = {}
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

 _W = display.contentWidth; -- Get the width of the screen
 _H = display.contentHeight; -- Get the height of the screen
 motionx = 0; -- Variable used to move character along x axis
 speed = 10; -- Set Walking Speed

function scene:create( event )
	
	local count = 0

	local message = "Clique no lugar para onde você quer se mover"

	local background = display.newImageRect( "scene/game/img/background.png", 2600, 1100 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
	local sheetOptions = {
	width =  196.33, 
	height = 200, 
	numFrames = 36
	}
	local sheet = graphics.newImageSheet("scene/game/img/BronzeKnight.png", sheetOptions)
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
	
	local viking = display.newImageRect( "scene/game/img/viking.png", 220, 280)
	viking.x = display.contentCenterX - 820
	viking.y = display.contentCenterY + 130
	physics.addBody( viking, "static", { radius=70} )
	viking.myName = "viking"

	local sword = display.newImageRect( "scene/game/img/sword.png", 200, 220 )
	sword.x = 1000; 
	sword.y = 900;

	local left = display.newImageRect( "scene/game/img/arrowL.png", 200, 280 )
	left.x = -360; left.y = 900;

	local right = display.newImageRect( "scene/game/img/arrowR.png", 200, 280 )
	right.x = _W - 900; right.y = 900;
	
	function left:touch()
			motionx = -speed;
	end
	left:addEventListener("touch",left)

	function right:touch()
		motionx = speed;
	end
	right:addEventListener("touch",right)

	local function movePlayer (event)
		viking.x = viking.x + motionx;
	end
	Runtime:addEventListener("enterFrame", movePlayer)

	local function stop (event)
		if event.phase =="ended" then
			motionx = 0;
		end
		local X, Y = viking:localToContent( 0, 0 )
	end
	Runtime:addEventListener("touch", stop )

	local function createWarrior()
		local newWarrior = display.newSprite(sheet, sequences)
		newWarrior:play()
		newWarrior.x = display.contentCenterX + 800
		newWarrior.y = display.contentCenterY + 130
		newWarrior.xScale = 1.1
		newWarrior.yScale = 1.1
	   	table.insert( warriorTable, newWarrior)
	   	physics.addBody( newWarrior, "dynamic", { radius=70} )
		newWarrior.myName = "newWarrior"

	   	local whereFrom = math.random(1)

		    if ( whereFrom == 1 ) then
				newWarrior.x = display.contentCenterX + 900
				newWarrior.y = display.contentCenterY + 150
				newWarrior:setLinearVelocity(-500, 0)
			end
	end

	sword:addEventListener("tap", createWarrior)
end

	local function loop()
		createWarrior()
	end

local function onCollision( event )
	score = score + 1
	textScore.text = "Score: " .. score
	if ( event.phase == "began" ) then
		local obj1 = event.object1
		local obj2 = event.object2

		if ( ( obj1.myName == "viking" and obj2.myName == "newWarrior" ) or
			 ( obj1.myName == "newWarrior" and obj2.myName == "viking" ) )
		then
			if(obj1.myName == "newWarrior") then
				display.remove(obj1)
			else
				display.remove(obj2)
			end
		end
	end
end

Runtime:addEventListener( "collision", onCollision )
scene:addEventListener( "create" )
-- scene:addEventListener( "show" )
-- scene:addEventListener( "hide" )
-- scene:addEventListener( "destroy" )

return scene