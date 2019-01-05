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
    --print("FOUND", found)
    --print("X =", x, currentPoint.y)
    --print("X =", thresholdBorneG.x)
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

    --print("FOUND2", found)
    --print("X2 =", x, currentPoint.y)
    --print("X2 =", thresholdBorneG.x)
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

  print(point.toString(currentPoint))

  -- Find the left limit
  local x = currentPoint.x

  --print("Point", point.toString(point.new{x, currentPoint.y}))
  --print(list.contains(clayPoints, point.new{x, currentPoint.y}, point.equals))

  while list.contains(clayPoints, point.new{x, currentPoint.y}, point.equals) do
    x = x - 1
    --print("Point", point.toString(point.new{x, currentPoint.y}))
    --print(list.contains(clayPoints, point.new{x, currentPoint.y}, point.equals))
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
  local finalResult = 0

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
  --print("ClayPoints = ", #clayPoints)
  --for i = 1, #clayPoints do
  --  print(point.toString(clayPoints[i]))
  --end
  --print("MinY = ", minY)
  --print("MaxY = ", maxY)

  -- Retrieve the first water spring
  local currentWaterSpring = stack.popright(waterSprings)

  local nbTurn = 0
  repeat
    print("START AGAIN !")
    print("CURRENT WATER SOURCE = ", point.toString(currentWaterSpring))

    local currentX = currentWaterSpring.x
    local currentY = currentWaterSpring.y

    local currentPoint = nil
    -- fall in straight line until the water hits the first clay
    repeat
      -- Create the new point
      currentPoint = point.new{currentX, currentY}

      -- Debug
      --print("new point =", point.toString(currentPoint))
      --print(list.contains(clayPoints, currentPoint, point.equals))
      --print(isClay(clayPoints, currentPoint))

      -- Update the currentY
      currentY = currentY + 1
    until currentY > maxY + 1 or currentY < minY + 1 or list.contains(clayPoints, currentPoint, point.equals)

    currentY = currentY - 1

    finalResult = finalResult + tonumber(currentPoint.y-1) - tonumber(currentWaterSpring.y)

    local previousBorneG = currentPoint
    local previousBorneD = currentPoint

    local thresholdBorneG = nil
    local thresholdBorneD = nil

    print("NEW RESULT", finalResult)

    --print(currentY)
    --print(maxY)
    --print(currentY > maxY)
    --print(currentY < minY)

    if not (currentY > maxY or currentY < minY) then

      repeat
        print("final point =", point.toString(currentPoint))

        -- DEBUG CLAY
        --print("ClayPoints = ", #clayPoints)
        --for i = 1, #clayPoints do
        --  print(point.toString(clayPoints[i]))
        --end

        -- Compute both side of the PREVIOUS floor
        -- Should ALWAYS give two int
        thresholdBorneG, _ = findPreviousBorder(previousBorneG, clayPoints)
        _, thresholdBorneD = findPreviousBorder(previousBorneD, clayPoints)

        print("thresholdBorneG = ", point.toString(thresholdBorneG))
        print("thresholdBorneD = ", point.toString(thresholdBorneD))

        -- Lift up one step
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

        previousBorneG = borneG
        previousBorneD = borneD

        if borneG ~= nil and borneD ~= nil then
          -- The -2 mean we convert a dry square into a water square AND from the difference
          finalResult = finalResult + tonumber(borneD.x) - tonumber(borneG.x) - 2
        end

        print("NEW RESULT", finalResult)

        --io.write("PRESSED FOR DEBUG : ")
        --io.flush()
        --io.read()

      until borneG == nil or borneD == nil

      if previousBorneG == nil then
        stack.pushleft(waterSprings, point.new{thresholdBorneG.x - 1, thresholdBorneG.y - 1})
        if previousBorneD ~= nil then
          finalResult = finalResult + tonumber(previousBorneD.x) - tonumber(thresholdBorneG.x - 1) - 2
        end
      end
      if previousBorneD == nil then
        stack.pushleft(waterSprings, point.new{thresholdBorneD.x + 1, thresholdBorneD.y - 1})
        if previousBorneG ~= nil then
          finalResult = finalResult + tonumber(thresholdBorneD.x + 1) - tonumber(previousBorneG.x) - 2
        end
      end

      if previousBorneG == nil and previousBorneD == nil  then
        finalResult = finalResult + tonumber(thresholdBorneD.x + 1) - tonumber(thresholdBorneG.x - 1) - 2
      end

      print("NEW RESULT", finalResult)
    end

    -- Retrieve the next water spring
    currentWaterSpring = stack.popright(waterSprings)

    if currentWaterSpring ~= nil then
      finalResult = finalResult + 1
    end

    nbTurn = nbTurn + 1

    --io.write("PRESSED FOR NEXT TURN : ")
    --io.flush()
    --io.read()

  until currentWaterSpring == nil or currentWaterSpring.y > maxY or currentWaterSpring.y < minY or nbTurn > 100

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
