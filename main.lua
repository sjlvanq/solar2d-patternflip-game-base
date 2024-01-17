-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local COLOR_ACTIVE = {1, 0, 0}
local COLOR_INACTIVE = {0, 0, 1}

local panelSize = 6
local squareSize = 30
local padding = 5

local squaresGroup = display.newGroup()
local squares = {}

local function createSquare(x, y, i, j)
    local square = display.newRect(squaresGroup, x, y, squareSize, squareSize)
    square:setFillColor(unpack(COLOR_INACTIVE))
	square.active = false
	square.isDiagonal = i == j or i + j == panelSize + 1
	square.isDiagonalM = i == j
	square.isDiagonalS = i + j == panelSize + 1
	square.i = i
	square.j = j
    local function onTouch(event)
        local square = event.target
		if event.phase == "began" or event.phase == "moved" then
			if square.isDiagonalM then
				for i = 1, panelSize do
					squares[i][i].active = not squares[i][i].active
				end
			elseif square.isDiagonalS then
				for i = 1, panelSize do
					squares[i][panelSize-i+1].active = not squares[i][panelSize-i+1].active
				end
			else
				square.active = not square.active
				if square.i > 1 		then squares[square.i-1][square.j].active = 
					not squares[square.i-1][square.j].active end
				if square.i < panelSize then squares[square.i+1][square.j].active = 
					not squares[square.i+1][square.j].active end
				if square.j > 1			then squares[square.i][square.j-1].active = 
					not squares[square.i][square.j-1].active end
				if square.j < panelSize then squares[square.i][square.j+1].active = 
					not squares[square.i][square.j+1].active end									
			end
			
			-- Re-dibuja el tablero
			for i, row in ipairs(squares) do
				for j, s in ipairs(row) do
					if squares[i][j].active then
						squares[i][j]:setFillColor(unpack(COLOR_ACTIVE))
					else
						squares[i][j]:setFillColor(unpack(COLOR_INACTIVE))
					end
				end
			end
		end
        return true
    end

    square:addEventListener("touch", onTouch)

    return square
end

for i = 1, panelSize do
	squares[i] = {}
    for j = 1, panelSize do
        local x = (i - 1) * (squareSize + padding)
        local y = (j - 1) * (squareSize + padding)

        squares[i][j] = createSquare(x, y, i, j)
    end
end

squaresGroup.anchorChildren = true
squaresGroup.x = display.contentCenterX
squaresGroup.y = display.contentCenterY
