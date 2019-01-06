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
    found = set.containsKey(clayPoints, point.new{x, currentPoint.y}, hashFct)

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
    found = set.containsKey(clayPoints, point.new{x, currentPoint.y}, hashFct)

    --print("FOUND2", found)
    --print("X2 =", x, currentPoint.y)
    --print("X2 =", thresholdBorneD.x)
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

  --print(point.toString(currentPoint))

  -- Find the left limit
  local x = currentPoint.x

  while set.containsKey(clayPoints, point.new{x, currentPoint.y}, hashFct) do
    x = x - 1
  end
  thresholdBorneG = point.new{x+1, currentPoint.y}

  -- Find the right limit
  local x = currentPoint.x
  while set.containsKey(clayPoints, point.new{x, currentPoint.y}, hashFct) do
    x = x + 1
  end
  thresholdBorneD = point.new{x-1, currentPoint.y}

  return thresholdBorneG, thresholdBorneD
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function hashFct (point)
  return point.x .. "-" .. point.y
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

  -- for input / input0 / input2 / input3
  --local firstPoint = point.new{500, 0}
  -- for input1
  --local firstPoint = point.new{9, 0}
  -- for input4
  --local firstPoint = point.new{5, 0}
  -- for input5
  local firstPoint = point.new{11, 0}

  -- Using a (Hash)Set avoid to call list.contains every time which is heavier than an access with an set..
  local clayPoints = Set{}
  local visitedWaterSprings = Set{}
  local squaresWithWater = Set{}

  local waterSprings = stack.new{}

  local maxY = nil
  local minY = nil

  print("Point equals", point.equals(point.new{"7", 16.0}, point.new{7.0, 16}))

  local fileLines = helper.saveLinesToArray(inputFile);

  for linesIndex = 1, #fileLines do
    if fileLines[linesIndex]:sub(1,1) == "x" then
      local x, borneMinY, borneMaxY = string.match(fileLines[linesIndex],  fileLines[linesIndex]:sub(1,1) .. "=(%d+).*=(%d+)..(%d+)")
      x = math.floor(tonumber(x))

      for y = borneMinY, borneMaxY do
        y = math.floor(tonumber(y))
        if minY == nil or y < tonumber(minY) then
          minY = y
        end
        if maxY == nil or y > tonumber(maxY) then
          maxY = y
        end

        local newClayPoint = point.new{x, y}
        if not set.containsKey(clayPoints, newClayPoint, hashFct) then
          set.addKey(clayPoints, newClayPoint, hashFct)
        end
      end

    elseif fileLines[linesIndex]:sub(1,1) == "y" then
      local y, borneMinX, borneMaxX = string.match(fileLines[linesIndex],  fileLines[linesIndex]:sub(1,1) .. "=(%d+).*=(%d+)..(%d+)")
      y = math.floor(tonumber(y))

      if minY == nil or y < tonumber(minY) then
        minY = y
      end
      if maxY == nil or y > tonumber(maxY) then
        maxY = y
      end

      for x = borneMinX, borneMaxX do
        x = math.floor(tonumber(x))

        local newClayPoint = point.new{x, y}
        if not set.containsKey(clayPoints, newClayPoint, hashFct) then
          set.addKey(clayPoints, newClayPoint, hashFct)
        end
      end
    else
      print("Lines can't be recognized")
    end
  end

  -- TODO maybe
  --drawClay()

  -- Add the first spring of water
  stack.pushleft(waterSprings, firstPoint)
  minY = math.min(firstPoint.y, minY)

  -- DEBUG
  keys = set.getValues(clayPoints)
  print("ClayPoints = ", #keys)
  for i = 1, #keys do
    print(point.toString(keys[i].key))
  end
  print("MinY = ", minY)
  print("MaxY = ", maxY)
  print()

  io.write("... ")
  io.flush()
  io.read()

  -- Retrieve the first water spring
  local currentWaterSpring = stack.popright(waterSprings)

  local nbTurn = 0
  repeat
    print("current water spring = ", point.toString(currentWaterSpring))

    local currentX = currentWaterSpring.x
    local currentY = currentWaterSpring.y

    local currentPoint = nil

    --------
    -- 1) Fall in straight line until the water hits the first clay point
    --------
    print("=== STEP 1 ===")
    repeat
      -- Create the new point
      currentPoint = point.new{currentX, currentY}
      currentY = currentY + 1
    until currentY > maxY + 1 or currentY < minY + 1 or set.containsKey(clayPoints, currentPoint, hashFct)

    currentY = currentY - 1

    -- Add the step 1) score
    finalResult = finalResult + tonumber(currentPoint.y-1) - tonumber(currentWaterSpring.y)
    print("added value = ", tonumber(currentPoint.y-1) - tonumber(currentWaterSpring.y))
    print("NEW RESULT", finalResult)

    local previousBorneG = currentPoint
    local previousBorneD = currentPoint
    local thresholdBorneG = nil
    local thresholdBorneD = nil

    print("current point =", point.toString(currentPoint))

    if not (currentY > maxY or currentY < minY) then
      -------
      -- 2) Fill the current spaces by going up until at least one border isn't found
      -------
      print("=== STEP 2 ===")
      repeat
        local borneG = nil
        local borneD = nil

        print("final point =", point.toString(currentPoint))

        -- Compute both side of the PREVIOUS floor
        -- Should ALWAYS give two int !
        thresholdBorneG, _ = findPreviousBorder(previousBorneG, clayPoints)
        _, thresholdBorneD = findPreviousBorder(previousBorneD, clayPoints)

        print("thresholdBorneG = ", point.toString(thresholdBorneG))
        print("thresholdBorneD = ", point.toString(thresholdBorneD))

        -- Lift up one step
        currentPoint.y =  currentPoint.y - 1

        if thresholdBorneG == nil or thresholdBorneD == nil then
          print("ERROR with thresholdBorne !!")
        end

        borneG, borneD = fillLine(currentPoint, clayPoints, thresholdBorneG, thresholdBorneD)

        if borneG ~= nil then
          print("borneG", point.toString(borneG))
        end
        if borneD ~= nil then
          print("borneD", point.toString(borneD))
        end

        previousBorneG = borneG
        previousBorneD = borneD

        if not set.containsKey(squaresWithWater, currentPoint, hashFct) then
          -- Add the step 2) score
          if borneG ~= nil and borneD ~= nil then
            -- MAKE SURE WE DIDN'T ALREADY COUNT THEM
            -- left side
            if not set.containsKey(squaresWithWater, point.new{borneG.x + 1, currentPoint.y}, hashFct) then
              -- The -2 mean we convert a dry square into a water square AND from the difference
              finalResult = finalResult + (tonumber(currentPoint.x) - tonumber(borneG.x)) - 1
              print("added left side = ", (tonumber(currentPoint.x) - tonumber(borneG.x)) - 1)
              print("NEW RESULT", finalResult)
            end
            -- right side
            if not set.containsKey(squaresWithWater, point.new{borneD.x - 1, currentPoint.y}, hashFct) then
              -- The -2 mean we convert a dry square into a water square AND from the difference
              finalResult = finalResult + (tonumber(borneD.x) - tonumber(currentPoint.x)) - 1
              print("added right side = ", (tonumber(borneD.x) - tonumber(currentPoint.x)) - 1)
              print("NEW RESULT", finalResult)
            end

            -- Tag those squares
            for x = borneG.x+1, borneD.x-1  do
              set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
            end
          end
        else
          -- Remove the one step that we count in the straight down line part.
          finalResult = finalResult - 1
          print("LINE ALREADY ADDED ! SKIP IT !")
        end

        print("NEW RESULT", finalResult)
        --io.write("PRESSED FOR DEBUG : ")
        --io.flush()
        --io.read()
      until previousBorneG == nil or previousBorneD == nil

      print("=== STEP 3 ===")
      -- Add the score if both side are empty (if needed)
      if previousBorneG == nil and previousBorneD == nil then
        if not set.containsKey(visitedWaterSprings, point.new{thresholdBorneG.x - 1, thresholdBorneG.y - 1}, hashFct) then
          -- add the left side to the score
          finalResult = finalResult + (tonumber(currentPoint.x + 1) - tonumber(thresholdBorneG.x - 1)) - 2

          print("added value both side (left) = ", (tonumber(currentPoint.x + 1) - tonumber(thresholdBorneG.x - 1)) - 2)
          print("NEW RESULT", finalResult)
        end
        if not set.containsKey(visitedWaterSprings, point.new{thresholdBorneD.x + 1, thresholdBorneD.y - 1}, hashFct) then
          -- add the right side to the score
          finalResult = finalResult + (tonumber(thresholdBorneD.x + 1) - tonumber(currentPoint.x - 1)) - 2

          print("added value both side (right) = ", (tonumber(thresholdBorneD.x + 1) - tonumber(currentPoint.x - 1)) - 2)
          print("NEW RESULT", finalResult)
        end
      end

      -- 3) Add new water spring that will fill more squares.
      local newWaterSpring = nil
      if previousBorneG == nil then
        newWaterSpring = point.new{thresholdBorneG.x - 1, thresholdBorneG.y - 1}

        if not set.containsKey(visitedWaterSprings, newWaterSpring, hashFct) then
          print("Add new left water spring ", point.toString(newWaterSpring))
          stack.pushleft(waterSprings, newWaterSpring)
          set.addKey(visitedWaterSprings, newWaterSpring, hashFct)

          if previousBorneD ~= nil then
            -- Add the score that come from the right until the previousBorneD, IF not already added before
            if not set.containsKey(visitedWaterSprings, point.new{previousBorneD.x - 1, previousBorneD.y}, hashFct) then

              finalResult = finalResult + (tonumber(previousBorneD.x - 1) - tonumber(currentPoint.x))

              print("added value right only = ", (tonumber(previousBorneD.x - 1) - tonumber(currentPoint.x)))
              print("result ", finalResult)

              -- Add the path until the next water spring on this side
              finalResult = finalResult + (tonumber(currentPoint.x) - tonumber(newWaterSpring.x + 1))

              print("added value left waterSpring = ", (tonumber(currentPoint.x) - tonumber(newWaterSpring.x + 1)))
              print("Result", finalResult)

              -- Tag those new squares
              for x = currentPoint.x, previousBorneD.x-1  do
                set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
              end
            end
          end
        end
      end
      if previousBorneD == nil then
        newWaterSpring = point.new{thresholdBorneD.x + 1, thresholdBorneD.y - 1}
        if not set.containsKey(visitedWaterSprings, newWaterSpring, hashFct) then
          print("Add new right water spring ", point.toString(newWaterSpring))
          stack.pushleft(waterSprings, newWaterSpring)
          set.addKey(visitedWaterSprings, newWaterSpring, hashFct)

          if previousBorneG ~= nil then
            -- Add the score that come from the left until the previousBorneG, IF not already added before
            if not set.containsKey(visitedWaterSprings, point.new{previousBorneG.x + 1, previousBorneG.y}, hashFct) then

              finalResult = finalResult + (tonumber(currentPoint.x) - tonumber(previousBorneG.x + 1))

              print("added value left only = ", (tonumber(currentPoint.x) - tonumber(previousBorneG.x + 1)))
              print("Result", finalResult)

              -- Add the path until the next water spring on this side
              finalResult = finalResult + (tonumber(newWaterSpring.x - 1) - tonumber(currentPoint.x))

              print("added value right waterSpring = ", (tonumber(newWaterSpring.x - 1) - tonumber(currentPoint.x)))
              print("Result", finalResult)

              -- Tag those squares
              for x = previousBorneG.x+1, currentPoint.x  do
                set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
              end
            end
          end
        end
      end

      print("NEW RESULT END", finalResult)
    end

    -- Retrieve the next water spring
    currentWaterSpring = stack.popright(waterSprings)

    if currentWaterSpring ~= nil then
      finalResult = finalResult + 1
    end

    nbTurn = nbTurn + 1

    print("===========")

    io.write("PRESSED FOR NEXT TURN : ")
    io.flush()
    io.read()

  until currentWaterSpring == nil or currentWaterSpring.y > maxY or currentWaterSpring.y < minY or nbTurn > 100

  -- TODO

  return finalResult;
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
