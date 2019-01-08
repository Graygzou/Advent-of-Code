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

  local finalScore = 0

  local string = ""
  for y = currentPoint.y-30, currentPoint.y+30 do
    for x = currentPoint.x-45, currentPoint.x+45 do
      local currentPoint = point.new{x, y}

      --if set.containsKey(wetSquares, currentPoint, hashFct) and set.containsKey(squaresWithWater, currentPoint, hashFct) then
      --  string = string .. "X"
      --else
      if set.containsKey(wetSquares, currentPoint, hashFct) then
        string = string .. "|"
        finalScore = finalScore + 1
      elseif set.containsKey(squaresWithWater, currentPoint, hashFct) then
        string = string .. "~"
        finalScore = finalScore + 1
      elseif set.containsKey(visitedWaterSprings, currentPoint, hashFct) then
        string = string .. "+"
      elseif set.containsKey(clayPoints, currentPoint, hashFct) then
        string = string .. "#"
      else
        string = string .. "."
      end
    end
    string = string .. "\n"
  end

  print("FINAL SCORE 2", finalScore)

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
function findPreviousBorder(currentPoint, y, clayPoints, waterPoints)
  local thresholdBorneG = nil
  local thresholdBorneD = nil

  --print(point.toString(currentPoint))
  --print(y)

  -- Find the left limit
  local x = currentPoint.x
  while set.containsKey(clayPoints, point.new{x, y}, hashFct) or set.containsKey(waterPoints, point.new{x, y}, hashFct) do
    x = x - 1
  end
  thresholdBorneG = point.new{x+1, y}

  -- Find the right limit
  x = currentPoint.x
  while set.containsKey(clayPoints, point.new{x, y}, hashFct) or set.containsKey(waterPoints, point.new{x, y}, hashFct) do
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
local function partOne (inputFile, initialPoint)
  local finalResult = 0

  -- for input / input0 (57) /-- input2 / input3
  local firstPoint = point.new{500, 0}
  if initialPoint ~= nil then
    firstPoint = initialPoint
  end

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

  -- Add another for the test
  --stack.pushleft(waterSprings, point.new{8, 0})
  --stack.pushleft(waterSprings, point.new{7, 0})
  --stack.pushleft(waterSprings, point.new{9, 0})

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
    --print("current water spring = ", point.toString(currentWaterSpring))

    local currentX = currentWaterSpring.x
    local currentY = currentWaterSpring.y

    local currentPoint = nil
    local thresholdBorneG = nil
    local thresholdBorneD = nil

    local step0 = false

    --------
    -- 0) Check if the new water spring isn't on a "full of water" line
    --------
    --if isLineFullOfWater(currentWaterSpring, clayPoints, squaresWithWater) then
      -- Remove the water spring from the result
      --finalResult = finalResult - 1

      --step0 = true
      --currentPoint = currentWaterSpring

      --thresholdBorneG, _ = findBorder(point.new{currentWaterSpring.x, currentWaterSpring.y}, currentWaterSpring.y-1, clayPoints, squaresWithWater)
      --_, thresholdBorneD = findBorder(point.new{currentWaterSpring.x, currentWaterSpring.y}, currentWaterSpring.y-1, clayPoints, squaresWithWater)


      --print(point.toString(thresholdBorneG))
      --print(point.toString(thresholdBorneD))

      --io.write("FULL WATER LINE : ")
      --io.flush()
      --io.read()
    --else
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
      for y = currentWaterSpring.y+1, currentPoint.y-1  do
        set.addKey(wetSquares, point.new{currentWaterSpring.x, y}, hashFct)
      end
      print("added value = ", tonumber(currentPoint.y-1) - tonumber(currentWaterSpring.y))
      print("NEW RESULT", finalResult)

      io.write("REGULAR : ")
      io.flush()
      io.read()
    --end

    --print("current point =", point.toString(currentPoint))

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

        --print("final point =", point.toString(currentPoint))

        -- Compute both side of the PREVIOUS floor
        -- Should ALWAYS give two int !
        if not step0 then
          thresholdBorneG, _ = findPreviousBorder(previousBorneG, previousBorneG.y, clayPoints, squaresWithWater)
        end
        if not step0 then
          _, thresholdBorneD = findPreviousBorder(previousBorneD, previousBorneD.y, clayPoints, squaresWithWater)
        end
        step0 = false

        --print("thresholdBorneG = ", point.toString(thresholdBorneG))
        --print("thresholdBorneD = ", point.toString(thresholdBorneD))

        -- Lift up one step
        currentPoint.y =  currentPoint.y - 1

        if thresholdBorneG == nil or thresholdBorneD == nil then
          print("ERROR with thresholdBorne !!")
        end

        borneG, borneD = fillLine(currentPoint, clayPoints, thresholdBorneG, thresholdBorneD)

        if borneG ~= nil then
          --print("borneG", point.toString(borneG))
        end
        if borneD ~= nil then
          --print("borneD", point.toString(borneD))
        end

        previousBorneG = borneG
        previousBorneD = borneD

        -- Try to find a wet square
        local existWetSquare = false
        local nbWetSquare = 0
        if previousBorneG ~= nil and previousBorneD ~= nil then
          for x = previousBorneG.x, previousBorneD.x do
            --print(point.toString(point.new{x, currentPoint.y}))
            --print(set.containsKey(wetSquares, point.new{x, currentPoint.y}, hashFct))
            if set.containsKey(wetSquares, point.new{x, currentPoint.y}, hashFct) then
              existWetSquare = true
              if not set.containsKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct) then
                nbWetSquare = nbWetSquare + 1
              end
            end
          end
        else
          existWetSquare = true
        end

        -- If the current line contains a wet square
        if existWetSquare then
          -- Remove the surplus of wetSquare
          if nbWetSquare > 1 then
            --finalResult = finalResult - (nbWetSquare - 1)
            --print("removed extra wetSquare = ", nbWetSquare-1)

            --io.write("PRESSED FOR DEBUG : ")
            --io.flush()
            --io.read()
          end

          -- Add one to the score if the current point is not a wet square or water square
          if previousBorneG ~= nil and previousBorneD ~= nil then
            -- Add one to the score if the current line is reached for the first time (no wet or watered square)
            -- Test if it exists a wet or watered squares
            found = false
            --for x = thresholdBorneG.x, thresholdBorneD.x do
            for x = previousBorneG.x, previousBorneD.x do
              --print(point.toString(point.new{x, currentPoint.y}, hashFct))
              --print(set.containsKey(wetSquares, point.new{x, currentPoint.y}, hashFct))
              --print(set.containsKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct) and not set.containsKey(visitedWaterSprings, point.new{x, currentPoint.y}, hashFct))
              found = found or (set.containsKey(wetSquares, point.new{x, currentPoint.y}, hashFct) or
              (set.containsKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct) and not set.containsKey(visitedWaterSprings, point.new{x, currentPoint.y}, hashFct)))
            end
            if not found then
              finalResult = finalResult + 1
              print("added value not wet = +1")
              print("NEW RESULT", finalResult)

              io.write("NOT WATERED SQUARE : ")
              io.flush()
              io.read()
            end
          end
          if set.containsKey(visitedWaterSprings, currentPoint, hashFct) then
            -- Center + Left side
            -- Iterate on all the square and add them individually
            local tempRes = 0
            for x = thresholdBorneG.x+1, currentPoint.x do
              if not set.containsKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct) and
                 not set.containsKey(wetSquares, point.new{x, currentPoint.y}, hashFct) and
                 not set.containsKey(visitedWaterSprings, point.new{x, currentPoint.y}, hashFct) then
                tempRes = tempRes + 1
              end
              set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
            end
            finalResult = finalResult + tempRes
            print("** added value left side = ", tempRes)
            print("NEW RESULT", finalResult)

            -- Right side
            -- Iterate on all the square and add them individually
            local tempRes = 0
            for x = currentPoint.x+1, thresholdBorneD.x-1 do
              if not set.containsKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct) and
                 not set.containsKey(wetSquares, point.new{x, currentPoint.y}, hashFct) and
                 not set.containsKey(visitedWaterSprings, point.new{x, currentPoint.y}, hashFct) then
                tempRes = tempRes + 1
              end
              set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
            end
            finalResult = finalResult + tempRes
            print("** added value right side = ", tempRes)
            print("NEW RESULT", finalResult)
          elseif not set.containsKey(squaresWithWater, currentPoint, hashFct) then
            -- Add the step 2) score
            if borneG ~= nil and borneD ~= nil then
              -- MAKE SURE WE DIDN'T ALREADY COUNT THEM
              -- left side
              -- Iterate on all the square and add them individually
              local tempRes = 0
              for x = borneG.x+1, currentPoint.x-1 do
                if not set.containsKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct) and
                   not set.containsKey(wetSquares, point.new{x, currentPoint.y}, hashFct) and
                   not set.containsKey(visitedWaterSprings, point.new{x, currentPoint.y}, hashFct) then
                  tempRes = tempRes + 1
                end
                set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
              end
              finalResult = finalResult + tempRes
              print("@@ added value left side = ", tempRes)
              print("NEW RESULT", finalResult)

              -- right side
              -- Iterate on all the square and add them individually
              local tempRes = 0
              for x = currentPoint.x, borneD.x-1 do
                if not set.containsKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct) and
                   not set.containsKey(wetSquares, point.new{x, currentPoint.y}, hashFct) and
                   not set.containsKey(visitedWaterSprings, point.new{x, currentPoint.y}, hashFct) then
                  tempRes = tempRes + 1
                end
                set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
              end
              finalResult = finalResult + tempRes
              print("@@ added value right side = ", tempRes)
              print("NEW RESULT", finalResult)
            end
          else
            print(currentPoint.y)
            print(currentWaterSpring.y)
            if currentPoint.y > currentWaterSpring.y then
              -- Remove the one step that we count in the straight down line part.
              finalResult = finalResult - 1
              print("LINE ALREADY ADDED ! SKIP IT !")
            end
          end
        else
          print("CAN'T GO UP ! Need to change the currentPoint !")
          found = false
          local currentX = thresholdBorneG.x
          while not found and currentX < thresholdBorneD.x do
            --print(point.toString(point.new{currentX, currentPoint.y}))
            --print(set.containsKey(wetSquares, point.new{currentX, currentPoint.y}, hashFct))
            found = found or (set.containsKey(wetSquares, point.new{currentX, currentPoint.y}, hashFct))
            currentX = currentX + 1
          end
          currentPoint = point.new{currentX-1, currentPoint.y+1}

          --print("NEW POINT =", point.toString(currentPoint))

          previousBorneG = currentPoint
          previousBorneD = currentPoint
        end

        --print("NEW RESULT", finalResult)
        --io.write("PRESSED FOR DEBUG : ")
        --io.flush()
        --io.read()
      until previousBorneG == nil or previousBorneD == nil

      ----------
      -- 3) Add new water spring that will fill more squares.
      -----------
      -- Add possible scores
      if currentPoint.y <= maxY and currentPoint.y >= minY then
        print("=== STEP 3 ===")
        -- Add score if both side are empty
        if previousBorneG == nil and previousBorneD == nil then
          -- Add one to the score if the current line is reached for the first time (no wet or watered square)
          -- Test if it exists a wet or watered squares
          found = false
          for x = thresholdBorneG.x, thresholdBorneD.x do
            found = found or (set.containsKey(wetSquares, point.new{x, currentPoint.y}, hashFct) or
            (set.containsKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct) and not set.containsKey(visitedWaterSprings, point.new{x, currentPoint.y}, hashFct)))
          end
          if not found then
            finalResult = finalResult + 1
            print("added value not wet = +1")
            print("NEW RESULT", finalResult)

            io.write("NOT WATERED SQUARE : ")
            io.flush()
            io.read()
          end

          --if not set.containsKey(visitedWaterSprings, point.new{thresholdBorneG.x - 1, thresholdBorneG.y - 1}, hashFct) then
          -- Center + left side to the score
          -- Iterate on all the square and add them individually
          local tempRes = 0
          for x = thresholdBorneG.x, currentPoint.x do
            if not set.containsKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct) and
               not set.containsKey(wetSquares, point.new{x, currentPoint.y}, hashFct) and
               not set.containsKey(visitedWaterSprings, point.new{x, currentPoint.y}, hashFct) then
              tempRes = tempRes + 1
            end
            set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
          end
          finalResult = finalResult + tempRes
          print("// added value both side (left) = ", tempRes)
          print("NEW RESULT", finalResult)

          -- add the right side to the score
          -- Iterate on all the square and add them individually
          local tempRes = 0
          for x = currentPoint.x+1, thresholdBorneD.x do
            if not set.containsKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct) and
               not set.containsKey(wetSquares, point.new{x, currentPoint.y}, hashFct) and
               not set.containsKey(visitedWaterSprings, point.new{x, currentPoint.y}, hashFct) then
              tempRes = tempRes + 1
            end
            set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
          end
          finalResult = finalResult + tempRes
          print("// added value both side (right) = ", tempRes)
          print("NEW RESULT", finalResult)

        end

        -- Step 3) a)
        local newWaterSpring = nil
        if previousBorneG == nil then
          -- Test if we can add a new water spring
          newWaterSpring = point.new{thresholdBorneG.x - 1, thresholdBorneG.y - 1}
          if not set.containsKey(visitedWaterSprings, newWaterSpring, hashFct) then
            print("Add new left water spring ", point.toString(newWaterSpring))
            stack.pushleft(waterSprings, newWaterSpring)
            set.addKey(visitedWaterSprings, newWaterSpring, hashFct)
          end

          -- Test if we should score when the water will only flow on the left (G)
          if previousBorneD ~= nil then
            local tempRes = 0
            for x = currentPoint.x+1, previousBorneD.x-1 do
              --print(point.toString(point.new{x, currentPoint.y}))
              --print(set.containsKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct))
              if not set.containsKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct) and
                 not set.containsKey(wetSquares, point.new{x, currentPoint.y}, hashFct) and
                 not set.containsKey(visitedWaterSprings, point.new{x, currentPoint.y}, hashFct) then
                tempRes = tempRes + 1
                --print("+1")
              end
              set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
            end
            finalResult = finalResult + tempRes
            print("== added value right only = ", tempRes)
            print("NEW RESULT", finalResult)

            -- Center + Left side until next water spring, IF not already added before
            -- Iterate on all the square and add them individually
            local tempRes = 0
            for x = thresholdBorneG.x, currentPoint.x do
              if not set.containsKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct) and
                 not set.containsKey(wetSquares, point.new{x, currentPoint.y}, hashFct) and
                 not set.containsKey(visitedWaterSprings, point.new{x, currentPoint.y}, hashFct) then
                tempRes = tempRes + 1
              end
              set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
            end
            finalResult = finalResult + tempRes
            print("== added value left only = ", tempRes)
            print("NEW RESULT", finalResult)
          end
        end

        -- Step 3) b)
        newWaterSpring = nil
        if previousBorneD == nil then
          -- Test if we can add a new water spring
          newWaterSpring = point.new{thresholdBorneD.x + 1, thresholdBorneD.y - 1}
          if not set.containsKey(visitedWaterSprings, newWaterSpring, hashFct) then
            print("Add new right water spring ", point.toString(newWaterSpring))
            stack.pushleft(waterSprings, newWaterSpring)
            set.addKey(visitedWaterSprings, newWaterSpring, hashFct)
          end

          -- Test if we should score when the water will only flow on the right (D)
          if previousBorneG ~= nil then

            -- Left side
            local tempRes = 0
            for x = previousBorneG.x+1, currentPoint.x-1 do
              --print(point.toString(point.new{x, currentPoint.y}))
              --print(set.containsKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct))
              if not set.containsKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct) and
                 not set.containsKey(wetSquares, point.new{x, currentPoint.y}, hashFct) and
                 not set.containsKey(visitedWaterSprings, point.new{x, currentPoint.y}, hashFct) then
                tempRes = tempRes + 1
                print("+1")
              end
              set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
            end
            finalResult = finalResult + tempRes
            print("-- added value left only = ", tempRes)
            print("NEW RESULT", finalResult)

            -- Center + Right side until new water spring, IF not already added before
            -- Iterate on all the square and add them individually
            local tempRes = 0
            for x = currentPoint.x, thresholdBorneD.x do
              --print(point.toString(point.new{x, currentPoint.y}))
              --print(set.containsKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct))
              if not set.containsKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct) and
                 not set.containsKey(wetSquares, point.new{x, currentPoint.y}, hashFct) and
                 not set.containsKey(visitedWaterSprings, point.new{x, currentPoint.y}, hashFct) then
                tempRes = tempRes + 1
                --print("+1")
              end
              set.addKey(squaresWithWater, point.new{x, currentPoint.y}, hashFct)
            end
            finalResult = finalResult + tempRes
            print("-- added value right only = ", tempRes)
            print("NEW RESULT", finalResult)
          end
        end

        -- Debug function
        if currentWaterSpring ~= nil then
          draw30x30Square(currentPoint, clayPoints, visitedWaterSprings, squaresWithWater, wetSquares)
        end
        io.write("PRESSED FOR NEXT TURN : ")
        io.flush()
        io.read()

        print("NEW RESULT END", finalResult)
      end
    end

    -- Retrieve the next water spring
    -- MAKE SURE WE RETRIEVE ALL THE WATER SPRING.
    repeat
      currentWaterSpring = stack.popright(waterSprings)
    until currentWaterSpring == nil or currentWaterSpring ~= nil and (currentWaterSpring.y <= maxY or currentWaterSpring.y >= minY)

    if currentWaterSpring ~= nil then
      finalResult = finalResult + 1
      print("ADD SCORE BECAUSE new spring water = +1")
      print("NEW RESULT", finalResult)
    end

    nbTurn = nbTurn + 1

    print("===========")

    -- Debug function
    --if currentWaterSpring ~= nil then
    --  draw30x30Square(currentPoint, clayPoints, visitedWaterSprings, squaresWithWater, wetSquares)
    --end

    io.write("PRESSED FOR NEXT TURN : ")
    io.flush()
    io.read()

  until currentWaterSpring == nil or nbTurn > 1000000

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
function day17Main (filename, initialPoint)

  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  local partOneResult = nil
  if initialPoint ~= nil then
    partOneResult = partOne(inputFile, initialPoint)
  else
    partOneResult = partOne(inputFile)
  end

  -- Reset the file handle position to the beginning to use it again
  inputFile:seek("set");

  local partTwoResult = partTwo(inputFile)

  -- Finally close the file
  inputFile:close();

  print("Result part one :", partOneResult);
  print("Result part two :", partTwoResult);

  return partOneResult
end
----------------------------------------------------
-- Tests
----------------------------------------------------
tests = {}

---[[
table.insert(tests, day17Main("Day17_Reservoir_Research/input0.txt", point.new{500, 0}) == 57)
table.insert(tests, day17Main("Day17_Reservoir_Research/input1.txt", point.new{9, 0}) == 26)

-- table.insert(tests, day17Main("Day17_Reservoir_Research/input4.txt", point.new{5, 0}) == 27) Old one
table.insert(tests, day17Main("Day17_Reservoir_Research/input4.txt", point.new{5, 0}) == 122)
table.insert(tests, day17Main("Day17_Reservoir_Research/input4invert.txt", point.new{11, 0}) == 27)

table.insert(tests, day17Main("Day17_Reservoir_Research/input5.txt", point.new{8, 0}) == 57)
table.insert(tests, day17Main("Day17_Reservoir_Research/input5.txt", point.new{8, -5}) == 61)
table.insert(tests, day17Main("Day17_Reservoir_Research/input6.txt", point.new{8, 0}) == 237)
table.insert(tests, day17Main("Day17_Reservoir_Research/input6.txt", point.new{8, -5}) == 241)

table.insert(tests, day17Main("Day17_Reservoir_Research/input6.txt", point.new{8, -5}) == 241)
table.insert(tests, day17Main("Day17_Reservoir_Research/input5invert.txt", point.new{6, 0}) == 57)

table.insert(tests, day17Main("Day17_Reservoir_Research/input7.txt", point.new{12, 0}) == 231)
table.insert(tests, day17Main("Day17_Reservoir_Research/input8.txt", point.new{12, 0}) == 219)

table.insert(tests, day17Main("Day17_Reservoir_Research/inputfillTopBug.txt", point.new{0, 0}) == 206)
table.insert(tests, day17Main("Day17_Reservoir_Research/inputfillTopBugInvert.txt", point.new{15, 0}) == 206)

table.insert(tests, day17Main("Day17_Reservoir_Research/inputInceptionBug.txt", point.new{6, 0}) == 132)
table.insert(tests, day17Main("Day17_Reservoir_Research/inputInceptionBug2.txt", point.new{6, 0}) == 237)
---]]
for i = 1, #tests do
  print("Test " .. i, tests[i])
end


--#################################################################
-- Package end
--#################################################################

day17 = {
  day17Main = day17Main,
}

return day17
