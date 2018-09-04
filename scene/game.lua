-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")

local scene = composer.newScene()

function scene:create( event )
	
	local count = 0

	local message = "Clique no lugar para onde você quer se mover"

	local background = display.newImageRect( "scene/game/img/background.png", 1900, 1050 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
	local viking = display.newImageRect( "scene/game/img/viking.png", 280, 350 )
	viking.x = display.contentCenterX
	viking.y = display.contentCenterY + 80
	

	local function dragShip( event )

		local viking = event.target
		local phase = event.phase

		if ( "began" == phase ) then
			display.currentStage:setFocus( viking )
			
			viking.touchOffsetX = event.x - viking.x

		elseif ( "moved" == phase ) then

			viking.x = event.x - viking.touchOffsetX

		elseif ( "ended" == phase or "cancelled" == phase ) then

			display.currentStage:setFocus( nil )
		end

		return true 
	end
	viking:addEventListener( "touch", dragShip )
end

scene:addEventListener( "create" )
-- scene:addEventListener( "show" )
-- scene:addEventListener( "hide" )
-- scene:addEventListener( "destroy" )

return scene