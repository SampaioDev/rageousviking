-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")

local scene = composer.newScene()

local physics = require("physics")
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
	
	local viking = display.newImageRect( "scene/game/img/viking.png", 220, 280)
	viking.x = display.contentCenterX
	viking.y = display.contentCenterY + 100

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
end

scene:addEventListener( "create" )
-- scene:addEventListener( "show" )
-- scene:addEventListener( "hide" )
-- scene:addEventListener( "destroy" )

return scene