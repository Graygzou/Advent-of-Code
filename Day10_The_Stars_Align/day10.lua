--#################################################################
--# @author: Grégoire Boiron                                      #
--# @date: 12/XX/2018                                             #
--#                                                               #
--# Template used for every main script for the day X of the AoC  #
--#################################################################
-- Note:
-- To use it Press Ctrl + F and replace "day10" by "Day" and the associated number.
--

local P = {} -- packages

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  day10 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function findBoundingBox (positions)
  MinPositionX = tonumber(positions[1][1])
  MaxPositionX = tonumber(positions[1][1])

  MinPositionY = tonumber(positions[1][2])
  MaxPositionY = tonumber(positions[1][2])

  for i = 2,#positions do
    currentPositionX = tonumber(positions[i][1])
    currentPositionY = tonumber(positions[i][2])

    if currentPositionX < MinPositionX then
      MinPositionX = currentPositionX
    end
    if currentPositionX > MaxPositionX then
      MaxPositionX = currentPositionX
    end
    if currentPositionY < MinPositionY then
      MinPositionY = currentPositionY
    end
    if currentPositionY > MaxPositionY then
      MaxPositionY = currentPositionY
    end
  end
  return MinPositionX, MaxPositionX, MinPositionY, MaxPositionY
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function forwardNSeconds(oldPositions, velocities)
  local newPosition = {}
  for i = 1,#oldPositions do
    newPosition[i] = {}
    newPosition[i][1] = oldPositions[i][1] + velocities[i][1]
    newPosition[i][2] = oldPositions[i][2] + velocities[i][2]
  end
  return newPosition
end


function pointInsidePosition(coordX, coordY, positions)
  found = false

  local i = 1
  while i < #positions and found do
    found = positions[i][1] == coordX and positions[i][2] == coordY
    i = i + 1
  end

  return found
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function printFrame(positions, minPositionX, maxPositionX, minPositionY, maxPositionY)
  -- Create the matrix to store all points
  local finalMatrix = {}
  for j = 1,(maxPositionY-minPositionY)+1 do
    finalMatrix[j] = {}
    for i = 1, (maxPositionX-minPositionX)+1 do
      finalMatrix[j][i] = "."
    end
  end

  -- Iterate over all the points to add them to the matrix
  for i = 1,#positions do
    x = tonumber(positions[i][1]) - tonumber(minPositionX) + 1
    y = tonumber(positions[i][2]) - tonumber(minPositionY) + 1
    finalMatrix[y][x] = "#"
  end

  for j = 1,#finalMatrix do
    local string = ""
    for i = 1,#finalMatrix[j] do
      string = string .. finalMatrix[j][i]
    end
    print(string)
  end
end


------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (inputFile)

  local daysStruct = helper.saveLinesToArray(inputFile);

  local positions = {}
  local velocities = {}

  for i = 1,#daysStruct do
    temp = helper.splitString(daysStruct[i], {"a-z", "=<", ", ", ">"})
    table.insert(positions, {temp[1], temp[2]})
    table.insert(velocities, {temp[3], temp[4]})
  end

  minPositionX, maxPositionX, minPositionY, maxPositionY = findBoundingBox(positions)

  local initialMaxX = maxPositionX
  local initialMinX = minPositionX
  local initialMaxY = maxPositionY
  local initialMinY = minPositionY

  -- For every time frame
  found = false
  currentTimeFrame = 0
  while not found and currentTimeFrame < 100000 do
    -- Increment the time frame
    currentTimeFrame = currentTimeFrame + 1

    -- Apply the velocity to the set of position
    local newPositions = forwardNSeconds(positions, velocities)

    currentMinPositionX, currentMaxPositionX, currentMinPositionY, currentMaxPositionY = findBoundingBox(newPositions)

    verticalExpansion = minPositionY > currentMinPositionY or maxPositionY < currentMaxPositionY  --bool
    horizontalExpansion = minPositionX > currentMinPositionX or maxPositionX < currentMaxPositionX  --bool
    found = verticalExpansion or horizontalExpansion

    if not found then
      -- Update all the values for the next iteration
      positions = newPositions
      minPositionX = currentMinPositionX
      maxPositionX = currentMaxPositionX
      minPositionY = currentMinPositionY
      maxPositionY = currentMaxPositionY
    end
  end

  print("Time frame : " .. currentTimeFrame)
  printFrame(positions, minPositionX, maxPositionX, minPositionY, maxPositionY)

  return 0;
end

------------------------------------------------------------------------
-- partTwo - function used for the part 2
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 2.
------------------------------------------------------------------------
local function partTwo (inputFile)

  -- nothing

  return 0;
end


--#################################################################
-- Main - Main function
--#################################################################
function day10Main (filename)
  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  -- Launch and print the final result
  print("Result part one :", partOne(inputFile));

  -- Reset the file handle position to the beginning to use it again
  inputFile:seek("set");

  -- Launch and print the final result
  print("Result part two :", partTwo(inputFile));

  -- Finally close the file
  inputFile:close();
end

--#################################################################
-- Package end
--#################################################################

day10 = {
  day10Main = day10Main,
}

return day10
