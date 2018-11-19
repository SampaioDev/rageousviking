local composer = require( "composer" )
local scene = composer.newScene()
local mainGroup = display.newGroup()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Initialize variables
local json = require( "json" )

local scoresTable = {}

local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )


local function loadScores()

	local file = io.open( filePath, "r" )

	if file then
		local contents = file:read( "*a" )
		io.close( file )
		scoresTable = json.decode( contents )
	end

	if ( scoresTable == nil or #scoresTable == 0 ) then
		scoresTable = { 0, 0, 0, 0}
	end
end


local function saveScores()

	for i = #scoresTable, 11, -1 do
		table.remove( scoresTable, i )
	end

	local file = io.open( filePath, "w" )

	if file then
		file:write( json.encode( scoresTable ) )
		io.close( file )
	end
end


local function gotoMenu()
	composer.gotoScene( "scene.menu" )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	local backgroundMusic = audio.loadStream( "soundtrack/gameover.ogg" )
	audio.play(backgroundMusic, {channel = 3, loops =-1})

	local voltar = display.newImageRect( "ui/voltar.png", 540, 220 )
	voltar.x = display.contentCenterX + 400
	voltar.y = display.contentCenterY + 200 
    mainGroup:insert(voltar)

	local jogar = display.newImageRect( "ui/start-button.png", 500, 110 )
	jogar.x = display.contentCenterX - 400
	jogar.y = display.contentCenterY + 265
    mainGroup:insert(jogar)

    local function playAgain()
        composer.gotoScene("scene.game", { time=800, effect="crossFade" })
    end
    jogar:addEventListener( "tap", playAgain)

	local function goToMenu()
        composer.gotoScene("scene.menu", { time=800, effect="crossFade" })
    end
	voltar:addEventListener( "tap", goToMenu)
	
    -- Load the previous scores
    loadScores()

    -- Insert the saved score from the last game into the table, then reset it
    table.insert( scoresTable, composer.getVariable( "finalScore" ) )
    composer.setVariable( "finalScore", 0 )

    -- Sort the table entries from highest to lowest
    local function compare( a, b )
        return a > b
    end
    table.sort( scoresTable, compare )

    -- Save the scores
    saveScores()

    local background = display.newImageRect( sceneGroup, "ui/game-over.png", 1900, 1050 )
    background.x = display.contentCenterX
	background.y = display.contentCenterY
	
	local highScoresHeader = display.newText( sceneGroup, "High Scores", display.contentCenterX, 240, native.systemFont, 60 )
	
	for i = 1, 4 do
        if ( scoresTable[i] ) then
            local yPos = 220 + ( i * 100 )

            local rankNum = display.newText( sceneGroup, i .. ") ", display.contentCenterX - 30 , yPos, native.systemFont, 60 )
            rankNum:setFillColor( 0.8, 2 )
            rankNum.anchorX = 1
 
            local thisScore = display.newText( sceneGroup, scoresTable[i], display.contentCenterX - 30, yPos, native.systemFont, 60 )
            thisScore.anchorX = 0
        end
    end
	local sound = display.newImageRect( "ui/soundon.png", 100, 100 )
	sound.x = display.contentCenterX + 800
	sound.y = display.contentCenterY - 420
	mainGroup:insert(sound)

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
			sound.y = display.contentCenterY - 420
			audio.resume()
			status = "ON"	
		end	
	end
	sound:addEventListener( "tap", toggleSound)

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		composer.removeScene("scene.game")
		composer.removeScene("scene.menu")
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		audio.stop(3)
		display.remove(mainGroup)
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene( "highscores" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene