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
function isLineFullOfWater(currentPoint, clayPoints, squaresWithWater)
  local isFull = true
  local y = currentPoint.y
  local done = false

  -- Left side
  local x = currentPoint.x
  while isFull and not set.containsKey(clayPoints, point.new{x, y}, hashFct) do
    isFull = isFull and set.containsKey(squaresWithWater, point.new{x, y}, hashFct)
    x = x - 1
  end

  -- Right side
  local x = currentPoint.x
  while isFull and not set.containsKey(clayPoints, point.new{x, y}, hashFct) do
    isFull = isFull and set.containsKey(squaresWithWater, point.new{x, y}, hashFct)
    x = x + 1
  end

  return isFull
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function draw30x30Square(currentPoint, clayPoints, visitedWaterSprings, squaresWithWater, wetSquares)

  local string = ""
  for y = currentPoint.y-15, currentPoint.y+15 do
    for x = currentPoint.x-15, currentPoint.x+15 do
      local currentPoint = point.new{x, y}

      if set.containsKey(visitedWaterSprings, currentPoint, hashFct) then
        string = string .. "+"
      elseif set.containsKey(squaresWithWater, currentPoint, hashFct) then
        string = string .. "~"
      elseif set.containsKey(clayPoints, currentPoint, hashFct) then
        string = string .. "#"
      elseif set.containsKey(wetSquares, currentPoint, hashFct) then
        string = string .. "|"
      else
        string = string .. "."
      end
    end
    string = string .. "\n"
  end

  print(string)
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
  until x <= (tonumber(thresholdBorneG.x) - 1) or found
  if found then
    borneG = point.new{x, currentPoint.y}
  end

  -- Try to find the right limit
  x = currentPoint.x
  found = false
  repeat
    x = x + 1
    found = set.containsKey(clayPoints, point.new{x, currentPoint.y}, hashFct)

    --print("FOUND2", found)
    --print("X2 =", x, currentPoint.y)
    --print("X2 =", thresholdBorneD.x)
  until x >= (tonumber(thresholdBorneD.x) + 1) or found
  if found then
    borneD = point.new{x, currentPoint.y}
  end

  return borneG, borneD
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function findPreviousBorder(currentPoint, y, clayPoints)
  local thresholdBorneG = nil
  local thresholdBorneD = nil

  --print(point.toString(currentPoint))
  print(y)

  -- Find the left limit
  local x = currentPoint.x
  while set.containsKey(clayPoints, point.new{x, y}, hashFct) do
    x = x - 1
  end
  thresholdBorneG = point.new{x+1, y}

  -- Find the right limit
  x = currentPoint.x
  while set.containsKey(clayPoints, point.new{x, y}, hashFct) do
    x = x + 1
  end
  thresholdBorneD = point.new{x-1, y}

  return thresholdBorneG, thresholdBorneD
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function findBorder(currentPoint, y, clayPoints)
  local thresholdBorneG = nil
  local thresholdBorneD = nil

  -- Find the left limit
  local x = currentPoint.x
  while not set.containsKey(clayPoints, point.new{x, y}, hashFct) do
    x = x - 1
  end
  thresholdBorneG = point.new{x, y}

  -- Find the right limit
  x = currentPoint.x
  while not set.containsKey(clayPoints, point.new{x, y}, hashFct) do
    x = x + 1
  end
  thresholdBorneD = point.new{x, y}

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

  -- for input / input0 (57) / input2 / input3
  local firstPoint = point.new{500, 0}
  -- for input1
  --local firstPoint = point.new{9, 0}
  -- for input4
  --local firstPoint = point.new{5, 0}
  -- for input5 ()
  local firstPoint = point.new{11, 0}
  -- for input50 / 500
  --local firstPoint = point.new{8, 0}

  -- Using a (Hash)Set avoid to call list.contains every time which is heavier than an access with an set..
  local clayPoints = Set{}
  local visitedWaterSprings = Set{}
  local squaresWithWater = Set{}
  local wetSquares = Set{}

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

  -- Retrieve the first water spring
  local currentWaterSpring = stack.popright(waterSprings)
  set.addKey(visitedWaterSprings, currentWaterSpring, hashFct)
  set.addKey(squaresWithWater, currentWaterSpring, hashFct)

  -- Debug function
  draw30x30Square(currentWaterSpring, clayPoints, visitedWaterSprings, squaresWithWater, wetSquares)

  io.write("... ")
  io.flush()
  io.read()

  local nbTurn = 0
  repeat
    print("current water spring = ", point.toString(currentWaterSpring))

    local currentX = currentWaterSpring.x
    local currentY = currentWaterSpring.y

    local currentPoint = nil
    local thresholdBorneG = nil
    local thresholdBorneD = nil

    local step0 = false

    --------
    -- 0) Check if the new water spring isn't on a "full of water" line
    --------
    if isLineFullOfWater(currentWaterSpring, clayPoints, squaresWithWater) then
      -- Remove the water spring from the result
      finalResult = finalResult - 1

      step0 = true
      currentPoint = currentWaterSpring

      thresholdBorneG, _ = findBorder(point.new{currentWaterSpring.x, currentWaterSpring.y}, currentWaterSpring.y-1, clayPoints)
      _, thresholdBorneD = findBorder(point.new{currentWaterSpring.x, currentWaterSpring.y}, currentWaterSpring.y-1, clayPoints)


      print(point.toString(thresholdBorneG))
      print(point.toString(thresholdBorneD))

      io.write("FULL WATER LINE : ")
      io.flush()
      io.read()
    else
      -- Tag it in order to trigger condition 0)
      set.addKey(squaresWithWater, currentWaterSpring, hashFct)

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
      -- Tag those new squares
      for y = currentWaterSpring.y, currentPoint.y-1  do
        set.addKey(wetSquares, point.new{currentWaterSpring.x, y}, hashFct)
      end
      print("added value = ", tonumber(currentPoint.y-1) - tonumber(currentWaterSpring.y))
      print("NEW RESULT", finalResult)

      io.write("REGULAR : ")
      io.flush()
      io.read()
    end

    print("current point =", point.toString(currentPoint))

    local previousBorneG = currentPoint
    local previousBorneD = currentPoint

    -------
    -- 2) Fill the current spaces by going up until at least one border isn't found
    -------
    if not (currentY > maxY or currentY < minY) then
      print("=== STEP 2 ===")
      repeat
        local borneG = nil
        local borneD = nil

        print("final point =", point.toString(currentPoint))

        -- Compute both side of the PREVIOUS floor
        -- Should ALWAYS give two int !
        if not step0 then
          thresholdBorneG, _ = findPreviousBorder(previousBorneG, previousBorneG.y, clayPoints)
        end
        if not step0 then
          _, thresholdBorneD = findPreviousBorder(previousBorneD, previousBorneD.y, clayPoints)
        end
        step0 = false

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

        if set.containsKey(visitedWaterSprings, currentPoint, hashFct) then
          -- left side
          if borneG ~= nil then
            finalResult = finalResult + (tonumber(currentPoint.x-1) - tonumber(borneG.x))
            -- Tag those squares
            for x = borneG.x+1, currentPoint.x do
              set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
            end
            print("added left side spring = ", (tonumber(currentPoint.x-1) - tonumber(borneG.x)))
            print("NEW RESULT", finalResult)
          end
          -- right side
          if borneD ~= nil then
            finalResult = finalResult + (tonumber(borneD.x-1) - tonumber(currentPoint.x))
            -- Tag those squares
            for x = currentPoint.x, borneD.x-1  do
              set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
            end
            print("added right side spring = ", (tonumber(borneD.x-1) - tonumber(currentPoint.x)))
            print("NEW RESULT", finalResult)
          end
        elseif not set.containsKey(squaresWithWater, currentPoint, hashFct) then
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

      -- Debug function
      if currentWaterSpring ~= nil then
        draw30x30Square(currentWaterSpring, clayPoints, visitedWaterSprings, squaresWithWater, wetSquares)
      end
      io.write("PRESSED FOR NEXT TURN : ")
      io.flush()
      io.read()

      print("=== STEP 3 ===")
      -- Basically, if the current point is the starting water source..
      if not set.containsKey(visitedWaterSprings, currentPoint, hashFct) and not set.containsKey(wetSquares, currentPoint, hashFct) then
        finalResult = finalResult + 1
      end

      -- Add the score if both side are empty (if needed)
      if previousBorneG == nil and previousBorneD == nil then
        if not set.containsKey(visitedWaterSprings, point.new{thresholdBorneG.x - 1, thresholdBorneG.y - 1}, hashFct) then
          -- add the left side to the score
          finalResult = finalResult + (tonumber(currentPoint.x + 1) - tonumber(thresholdBorneG.x - 1)) - 2
          -- Tag those new squares
          for x = thresholdBorneG.x-1, currentPoint.x+1  do
            set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
          end
          print("added value both side (left) = ", (tonumber(currentPoint.x + 1) - tonumber(thresholdBorneG.x - 1)) - 2)
          print("NEW RESULT", finalResult)

        end
        if not set.containsKey(visitedWaterSprings, point.new{thresholdBorneD.x + 1, thresholdBorneD.y - 1}, hashFct) then
          -- add the right side to the score
          finalResult = finalResult + (tonumber(thresholdBorneD.x + 1) - tonumber(currentPoint.x - 1)) - 2
          -- Tag those new squares
          for x = thresholdBorneD.x+1, currentPoint.x-1  do
            set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
          end
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

              if not set.containsKey(squaresWithWater, point.new{currentWaterSpring.x+1, currentWaterSpring.y}, hashFct) then
                finalResult = finalResult + (tonumber(previousBorneD.x - 1) - tonumber(currentPoint.x))
                -- Tag those new squares
                for x = currentPoint.x, previousBorneD.x-1  do
                  set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
                end
                print("added value right only = ", (tonumber(previousBorneD.x - 1) - tonumber(currentPoint.x)))
                print("result ", finalResult)
              end

              -- Add the path until the next water spring on this side (if needed)
              if not set.containsKey(squaresWithWater, point.new{currentWaterSpring.x-1, currentWaterSpring.y}, hashFct) then
                finalResult = finalResult + (tonumber(currentPoint.x) - tonumber(newWaterSpring.x + 1))
                -- Tag those new squares
                for x = newWaterSpring.x+1, currentPoint.x  do
                  set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
                end
                print("added value left waterSpring = ", (tonumber(currentPoint.x) - tonumber(newWaterSpring.x + 1)))
                print("Result", finalResult)
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

              if not set.containsKey(squaresWithWater, point.new{currentWaterSpring.x-1, currentWaterSpring.y}, hashFct) then
                finalResult = finalResult + (tonumber(currentPoint.x) - tonumber(previousBorneG.x + 1))
                -- Tag those squares
                for x = previousBorneG.x+1, currentPoint.x  do
                  set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
                end
                print("added value left only = ", (tonumber(currentPoint.x) - tonumber(previousBorneG.x + 1)))
                print("Result", finalResult)
              end

              -- Add the path until the next water spring on this side
              if not set.containsKey(squaresWithWater, point.new{currentWaterSpring.x+1, currentWaterSpring.y}, hashFct) then
                finalResult = finalResult + (tonumber(newWaterSpring.x - 1) - tonumber(currentPoint.x))
                -- Tag those squares
                for x = currentPoint.x, newWaterSpring.x-1  do
                  set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
                end
                print("added value right waterSpring = ", (tonumber(newWaterSpring.x - 1) - tonumber(currentPoint.x)))
                print("Result", finalResult)
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

    -- Debug function
    if currentWaterSpring ~= nil then
      draw30x30Square(currentWaterSpring, clayPoints, visitedWaterSprings, squaresWithWater, wetSquares)
    end

    io.write("PRESSED FOR NEXT TURN : ")
    io.flush()
    io.read()

  until currentWaterSpring == nil or currentWaterSpring.y > maxY or currentWaterSpring.y < minY or nbTurn > 100

  -- Debug function
  if firstPoint ~= nil then
    draw30x30Square(firstPoint, clayPoints, visitedWaterSprings, squaresWithWater, wetSquares)
  end

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
