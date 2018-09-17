-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")
local scene = composer.newScene()
local score = 0
local timerCount
local warriorTable = {}
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
physics.start()

 _W = display.contentWidth; -- Get the width of the screen
 _H = display.contentHeight; -- Get the height of the screen
 motionx = 0; -- Variable used to move character along x axis
 speed = 10; -- Set Walking Speed

function scene:create( event )
	
	local count = 0

	local message = "Clique no lugar para onde você quer se mover"

	local background = display.newImageRect( "scene/game/img/background.png", 1900, 1050 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
	-- local sheetOptions = {
	-- 	width =  196.33, 
	-- 	height = 200, 
	-- 	numFrames = 36
	-- }
	-- local sheet = graphics.newImageSheet("scene/game/img/BronzeKnight.png", sheetOptions)

	-- local sequences = {
	-- 	{
	-- 		name = "attacking",
	-- 		start = 22,
	-- 		count = 30,
	-- 		time = 1400,
	-- 		loopCount = 0,
		
	-- 	}
	-- }
	
	-- local running = display.newSprite(sheet, sequences)
	-- running.x = display.contentCenterX + 800
	-- running.y = display.contentCenterY + 130
	-- running.xScale = 1.2
	-- running.yScale = 1.2
	local myText = display.newText( score , 100, 200, native.systemFont, 120 )
	myText:setFillColor( 1	, 1, 1 )
	myText.x = display.contentCenterX
	myText.y = display.contentCenterY - 400
	
	local viking = display.newImageRect( "scene/game/img/viking.png", 220, 280)
	viking.x = display.contentCenterX - 820
	viking.y = display.contentCenterY + 130

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
		print( "White square's center position in screen coordinates: ", X, Y )
	end
	Runtime:addEventListener("touch", stop )

	local function createWarrior()
		score = score + 1
		myText.text = score
		local newWarrior = display.newImageRect("scene/game/img/viking2.png", 200, 240)
	   	table.insert( warriorTable, newWarrior)
	   	physics.addBody( newWarrior, "dynamic", { radius=70, bounce=0.8 } )

	   	local whereFrom = math.random(1)

		    if ( whereFrom == 1 ) then
				newWarrior.x = display.contentCenterX + 900
				newWarrior.y = display.contentCenterY + 150
				newWarrior:setLinearVelocity(-500, 0)
			end
	end

	local function loop()
		createWarrior()
	end

	sword:addEventListener("tap", createWarrior)
end

scene:addEventListener( "create" )
-- scene:addEventListener( "show" )
-- scene:addEventListener( "hide" )
-- scene:addEventListener( "destroy" )

return scene