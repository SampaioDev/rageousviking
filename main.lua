-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")

local isSimulator = "simulator" == system.getInfo( "environment" )
local isMobile = ( "ios" == system.getInfo("platform") ) or ( "android" == system.getInfo("platform") )
system.activate( "multitouch" )

-- If we are running in the Corona Simulator, enable debugging keys
-- "F" key shows a visual monitor of our frame rate and memory usage
if isSimulator then 

	-- Show FPS
	local visualMonitor = require( "com.davisampaio.visualMonitor" )
	local visMon = visualMonitor:new()
	visMon.isVisible = false

	local function debugKeys( event )
		local phase = event.phase
		local key = event.keyName
		if phase == "up" then
			if key == "f" then
				visMon.isVisible = not visMon.isVisible 
			end
		end
	end
	-- Listen for key events in Runtime
	-- See the "key" event documentation for more details:
	-- https://docs.coronalabs.com/api/event/key/index.html
	Runtime:addEventListener( "key", debugKeys )
end

composer.gotoScene("scene.game-over")