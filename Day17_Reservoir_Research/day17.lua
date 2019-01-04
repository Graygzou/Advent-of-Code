--#################################################################
--# @author: Grégoire Boiron                                      #
--# @date: 02/01/2019                                             #
--#                                                               #
--# Template used for every main script for the day X of the AoC  #
--#################################################################

local P = {} -- packages

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  day17 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function isClay(clayPoints, point)
  return list.contains(clayPoints, point, point.equals)
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function fillLine(currentPoint, clayPoints, thresholdBorneG, thresholdBorneD)
  local borneG = nil
  local borneD = nil

  -- Try to find the left limit
  local x = currentPoint.x
  local found = false
  repeat
    x = x - 1
    found = list.contains(clayPoints, point.new{x, currentPoint.y}, point.equals)
    print("FOUND", found)
    print("X =", x, currentPoint.y)
    print("X =", thresholdBorneG.x)
  until x < (tonumber(thresholdBorneG.x) - 1) or found
  if found then
    borneG = point.new{x, currentPoint.y}
  end

  -- Try to find the right limit
  local x = currentPoint.x
  local found = false
  repeat
    x = x + 1
    found = list.contains(clayPoints, point.new{x, currentPoint.y}, point.equals)
  until x > (tonumber(thresholdBorneD.x) + 1) or found
  if found then
    borneD = point.new{x, currentPoint.y}
  end

  return borneG, borneD
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function findPreviousBorder(currentPoint, clayPoints)
  local thresholdBorneG = nil
  local thresholdBorneD = nil

  -- Find the left limit
  local x = currentPoint.x
  while list.contains(clayPoints, point.new{x, currentPoint.y}, point.equals) do
    x = x - 1
  end
  thresholdBorneG = point.new{x+1, currentPoint.y}

  -- Find the right limit
  local x = currentPoint.x
  while list.contains(clayPoints, point.new{x, currentPoint.y}, point.equals) do
    x = x + 1
  end
  thresholdBorneD = point.new{x-1, currentPoint.y}

  return thresholdBorneG, thresholdBorneD
end

------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (inputFile)
  local clayPoints = {}
  local waterSprings = stack.new{}

  local maxY = nil
  local minY = nil

  print("Point equals", point.equals(point.new{"7", 16.0}, point.new{7.0, 16}))

  local fileLines = helper.saveLinesToArray(inputFile);

  for linesIndex = 1, #fileLines do
    if fileLines[linesIndex]:sub(1,1) == "x" then
      print(fileLines[linesIndex]:sub(1,1))
      print(string.match(fileLines[linesIndex],  fileLines[linesIndex]:sub(1,1) .. "=(%d+).*=(%d+)..(%d+)"))

      local x, borneMinY, borneMaxY = string.match(fileLines[linesIndex],  fileLines[linesIndex]:sub(1,1) .. "=(%d+).*=(%d+)..(%d+)")

      for y = borneMinY, borneMaxY do
        if minY == nil or tonumber(y) < minY then
          minY = y
        end
        if maxY == nil or tonumber(y) > maxY then
          maxY = y
        end

        local newClayPoint = point.new{x, y}
        if not list.contains(clayPoints, newClayPoint, point.equals) then
          table.insert(clayPoints, newClayPoint)
        end
      end

      --point.new(tonumber())
    elseif fileLines[linesIndex]:sub(1,1) == "y" then
      print(fileLines[linesIndex]:sub(1,1))
      print(string.match(fileLines[linesIndex],  fileLines[linesIndex]:sub(1,1) .. "=(%d+).*=(%d+)..(%d+)"))

      local y, borneMinX, borneMaxX = string.match(fileLines[linesIndex],  fileLines[linesIndex]:sub(1,1) .. "=(%d+).*=(%d+)..(%d+)")

      if minY == nil or tonumber(y) < minY then
        minY = y
      end
      if maxY == nil or tonumber(y) > maxY then
        maxY = y
      end

      for x = borneMinX, borneMaxX do
        local newClayPoint = point.new{x, y}
        if not list.contains(clayPoints, newClayPoint, point.equals) then
          table.insert(clayPoints, newClayPoint)
        end
      end
    else
      print("Lines can't be recognized")
    end
  end

  -- TODO
  --drawClay()

  -- Add the first spring of water
  stack.pushleft(waterSprings, point.new{500, 0})
  minY = math.min(0, minY)

  -- DEBUG
  print("ClayPoints = ", #clayPoints)
  for i = 1, #clayPoints do
    print(point.toString(clayPoints[i]))
  end
  print("MinY = ", minY)
  print("MaxY = ", maxY)

  local nbTurn = 0
  repeat
    -- Retrieve the next water spring
    local currentWaterSpring = stack.popright(waterSprings)
    local currentX = currentWaterSpring.x
    local currentY = currentWaterSpring.y

    local currentPoint = nil
    -- fall in straight line until the water hits the first clay
    repeat
      -- Create the new point
      currentPoint = point.new{currentX, currentY}

      -- Debug
      print("new point =", point.toString(currentPoint))
      print(list.contains(clayPoints, currentPoint, point.equals))
      print(isClay(clayPoints, currentPoint))

      -- Update the currentY
      currentY = currentY + 1
    until currentY > maxY or currentY < minY or list.contains(clayPoints, currentPoint, point.equals)

    print("final point =", point.toString(currentPoint))

    repeat
      -- Compute both side of the PREVIOUS floor
      -- Should ALWAYS give two int
      local thresholdBorneG, thresholdBorneD = findPreviousBorder(currentPoint, clayPoints)

      print("thresholdBorneG = ", point.toString(thresholdBorneG))
      print("thresholdBorneD = ", point.toString(thresholdBorneD))

      -- Lift up one step
      --currentY = currentY + 1
      currentPoint.y =  currentPoint.y - 1

      if thresholdBorneG == nil or thresholdBorneD == nil then
        print("ERROR with thresholdBorne !!")
      end

      local borneG, borneD = fillLine(currentPoint, clayPoints, thresholdBorneG, thresholdBorneD)

      if borneG ~= nil then
        print("borneG", point.toString(borneG))
      end
      if borneD ~= nil then
        print("borneD", point.toString(borneD))
      end

      io.write("PRESSED FOR DEBUG : ")
      io.flush()
      io.read()

    until borneG == nil or borneD == nil

    io.write("PRESSED FOR NEXT TURN : ")
    io.flush()
    io.read()

    nbTurn = nbTurn + 1
  until currentY > maxY or currentY < minY or nbTurn > 100

  -- TODO

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

  -- TODO

  return 0;
end


--#################################################################
-- Main - Main function
--#################################################################
function day17Main (filename)

  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  local partOneResult = partOne(inputFile)

  -- Reset the file handle position to the beginning to use it again
  inputFile:seek("set");

  local partTwoResult = partTwo(inputFile)

  -- Finally close the file
  inputFile:close();

  print("Result part one :", partOneResult);
  print("Result part two :", partTwoResult);

end

--#################################################################
-- Package end
--#################################################################

day17 = {
  day17Main = day17Main,
}

return day17
