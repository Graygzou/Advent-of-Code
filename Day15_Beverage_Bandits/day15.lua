--#################################################################
--# @author: Grégoire Boiron                                      #
--# @date: 12/XX/2018                                             #
--#                                                               #
--# Template used for every main script for the day X of the AoC  #
--#################################################################
-- Note:
-- To use it Press Ctrl + F and replace "day15" by "Day" and the associated number.
--

local P = {} -- packages

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  day15 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function mapToString(map)
  finalString = ""
  for j=1,#map do
    for i=1,#map[j] do
      finalString = finalString .. "" .. map[j][i]
    end
  end
  return finalString
end

------------------------------------------------------------------------
-- Exist at least one path to that square !
------------------------------------------------------------------------
function canBeReached(currentTargetPos)
  local isReachable = false
  local finalPoints = {}
  -- for each side (top, bottom, left, right)
  adjacentSquares = {{type=map[(currentTargetPos.y-1)+1][(currentTargetPos.x)+1], position=point.new{currentTargetPos.x, currentTargetPos.y-1}},
                     {type=map[(currentTargetPos.y)+1][(currentTargetPos.x+1)+1], position=point.new{currentTargetPos.x+1, currentTargetPos.y}},
                     {type=map[(currentTargetPos.y+1)+1][(currentTargetPos.x)+1], position=point.new{currentTargetPos.x, currentTargetPos.y+1}},
                     {type=map[(currentTargetPos.y)+1][(currentTargetPos.x-1)+1], position=point.new{currentTargetPos.x-1, currentTargetPos.y}}}
  print(adjacentSquares[1].type);  print(point.toString(adjacentSquares[1].position))
  print(adjacentSquares[2].type);  print(point.toString(adjacentSquares[2].position))
  print(adjacentSquares[3].type);  print(point.toString(adjacentSquares[3].position))
  print(adjacentSquares[4].type);  print(point.toString(adjacentSquares[4].position))

  for i=1,4 do
    if adjacentSquares[i].type ~= "E" and adjacentSquares[i].type ~= "G" and adjacentSquares[i].type ~= "#" then
      table.insert(finalPoints, adjacentSquares[i])
      isReachable = true
    end
  end
  return isReachable, finalPoints
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function findfirstPosInRO (position1, position2, indexPosition1, indexPosition2)
  local finalPosition = position1
  local finalIndex = indexPosition1

  if finalPosition.y == position2.y then
    if finalPosition.x > position2.x then
      finalPosition = position2
      finalIndex = indexPosition2
    end
  elseif finalPosition.y > position2.y then
    finalPosition = position2
    finalIndex = indexPosition2
  end

  return finalPosition, finalIndex
end
--print("|-------------------------------------------|")
--print("| Tests findfirstPosInRO function :         |")
--print("|-------------------------------------------|")
--print(point.equals(findfirstPosInRO({x=1, y=3},{x=2, y=2}, 0, 0), {x=, y=}))


------------------------------------------------------------------------
--
------------------------------------------------------------------------
function findNextPlayingUnit (units)
  local nextUnit = units[1]
  local finalIndex = 1

  for i=2,#units do
    print(point.toString(nextUnit.position))
    print(point.toString(units[i].position))
    local _, tempIndex = findfirstPosInRO(nextUnit.position, units[i].position, finalIndex, i)
    if finalIndex ~= tempIndex then
      nextUnit = units[i]
      finalIndex = i
    end
  end

  return nextUnit, finalIndex
end
print("|-------------------------------------------|")
print("| Tests findNextPlayingUnit function :      |")
print("|-------------------------------------------|")
print(point.equals(findNextPlayingUnit({{position={x=4, y=2}}, {position={x=2, y=1}}}), {position={x=2,y=1}}, 2))
print(point.equals(findNextPlayingUnit({{position={x=2, y=1}}, {position={x=4, y=2}}}), {position={x=2,y=1}}, 2))
print(point.equals(findNextPlayingUnit({{position={x=2, y=1}}, {position={x=3, y=1}}}), {position={x=2,y=1}}, 2))
print(point.equals(findNextPlayingUnit({{position={x=3, y=2}}, {position={x=3, y=1}}}), {position={x=3,y=1}}, 2))
print(point.equals(findNextPlayingUnit({{position={x=0, y=2}}, {position={x=3, y=2}}, {position={x=9, y=1}}, {position={x=20, y=10}}}), {position={x=9,y=1}}, 2))

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function mergeUnitLists (nbUnits, ...)
  local unitList = {}

  local nbTeam = select("#",...)

  -- Create an index of each team
  local teamIndexes = {}
  for i = 1,nbTeam do
    table.insert(teamIndexes, 1)
  end

  local arg = {...}
  while #unitList < nbUnits do

    -- Find the next playing unit among all separate lists of units
    competingUnit = {}
    for i = 1, nbTeam do
      table.insert(competingUnit, arg[i][teamIndexes[i]])
    end
    nextPlayingUnit, UnitTeamIndex = findNextPlayingUnit(competingUnit)
    print("FINDED UNIT Type = " .. nextPlayingUnit.type .. ", Health = " .. nextPlayingUnit.health .. ", Attack =" .. nextPlayingUnit.attack .. ", Position = " .. point.toString(nextPlayingUnit.position))
    print("INDEX" .. UnitTeamIndex)
    -- Insert the unit
    table.insert(unitList, nextPlayingUnit)

    -- Update the index of the list of that unit to "remove" unit
    teamIndexes[UnitTeamIndex] = teamIndexes[UnitTeamIndex] + 1
  end

  return unitList
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function closestPointHeuristique( point1, point2, target)
  --print("POINT1", point.toString(point1))
  --print("POINT2", point.toString(point2))
  local distancePoint1ToTarget = math.abs(target.x - point1.x) + math.abs(target.y - point1.y)
  local distancePoint2ToTarget = math.abs(target.x - point2.x) + math.abs(target.y - point2.y)
  if distancePoint1ToTarget == distancePoint2ToTarget then
    --print("DEBUG" .. point.toString(findfirstPosInRO(point1, point2)))
    --print(point.equals(point2, findfirstPosInRO(point1, point2)))
    return point.equals(point2, findfirstPosInRO(point1, point2))
  elseif distancePoint1ToTarget < distancePoint2ToTarget then
    --print("FALSE")
    return false
  elseif distancePoint1ToTarget > distancePoint2ToTarget then
    --print("TRUE")
    return true
  else
    print("ERROR in closestPointHeuristique : This case should be taken by the first condition (equality)")
  end
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function chooseNextPoint(currentPoint, endingPoint, heuristique)
  --local finalPosition = nil

  -- Get all the adjacent squares around the current point
  _, possibleNextPoints = canBeReached(currentPoint)

  -- check if we can explore that the adjacent points
  --local found = #possibleNextPoints > 1
  --if found then

  possibleNextPoints = point.bubbleSortPoints(possibleNextPoints, heuristique, endingPoint)
    --[[
    finalPosition = possibleNextPoints[1].position
    for i=2,#possibleNextPoints do
      finalPosition = heuristique(finalPosition, possibleNextPoints[i].position, endingPoint)
    end
    print(point.toString(finalPosition))
    --]]
  --end
  return possibleNextPoints
end

------------------------------------------------------------------------
-- Return the square that the rootUnit should go toward FOR THE CURRENT TARGET
-- and the total length of the path
-- (number of steps we need to reach it)
------------------------------------------------------------------------
function findClosestReachablePos(rootUnit, targetPositions, map)
  local totalLength = 0
  local finalTarget = nil

  for i = 1,#targetPositions do
    print("NEXT TARGET ADJACENT = ", point.toString(targetPositions[i].position))

    -- Settings
    startingPoint = rootUnit.position
    endingPoint = targetPositions[i].position

    -- Create a queue to iterate on possible points
    local possibleSquares = stack.new()

    local nextPoint = startingPoint
    repeat
      -- Update the length for each iteration
      totalLength = totalLength + 1

      -- Select all possible points (order by the given heuristique)
      possiblePoints = chooseNextPoint(nextPoint, endingPoint, closestPointHeuristique)

      -- Debug
      print("YOYO", point.toString(nextPoint))
      --print(point.toString(endingPoint))

      -- Add all the points to the existing queue.
      for j = 1,#possiblePoints do
        --print("HUMM", point.toString(possiblePoints[j].position))
        stack.pushright(possibleSquares, possiblePoints[j])
      end
      -- Debug
      stack.printstack(possibleSquares)

      -- Take the next point in the stack (nil if empty)
      nextPoint = stack.popleft(possibleSquares).position

      print(point.toString(nextPoint))

    until stack.getSize(possibleSquares) <= 0 or totalLength > 50 or (nextPoint ~= nil and point.equals(nextPoint, endingPoint))

    print(stack.getSize(possibleSquares) <= 0)
    print((nextPoint ~= nil and point.equals(nextPoint, endingPoint)))
    print("FINISHED !")
  end


  print("FINAL LENGTH", totalLength)
  print("FINAL finalTarget", finalTarget)

  -- Error in purpose to debug
  print(t[1])

  return finalTarget, totalLength
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function findNextPositionToReach(rootUnit, targets, map)
  lengthShorestPath = nil
  chosenPosition = nil

  for i = 1,#targets do
    local currentTargetPosition = targets[i].position

    print("NEXT TARGET = " .. point.toString(currentTargetPosition))

      -- Study if the target can be in range
      isReachable, availableSpots = canBeReached(currentTargetPosition)
      if isReachable then

        -- if it is, find the closest reachable position (top, bottom, right, left)
        -- This step will also compute the length to that closest reachable position
        closestReachablePos, length = findClosestReachablePos(rootUnit, availableSpots, map)

        print(closestReachablePos)
        if closestReachablePos ~= nil then
          if lengthShorestPath == nil or lengthShorestPath > length then
            lengthShorestPath = length
            chosenPosition = closestReachablePos
          end
        else
          print("NOT REACHABLE SQUARE !")
        end





        -- REMOVE ?
        local res = studyPathLength(chosenPosition, closestReachablePos)

        -- If the new position found is closest or equals to the
        if res == 0 then
          -- Replace the position cause it is closer than the previous one
          chosenPosition = closestReachablePos
        elseif res == 1 then
          -- Find the closest position in the reading order
          chosenPosition = findfirstPosInRO(chosenPosition, closestReachablePos)
        else
          -- no update.
        end
        --END REMOVE
      end
  end
  return closestReachablePos
end

function canAttack(unit, targets)
  return false
end

------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (nbUnits, elfs, goblins, map)

  -- Game Loop
  done = false
  nbTurn = 0
  while not done and nbTurn < 2 do

    -- Merge all the unit list into one big ordered by playing turn !
    unitList = mergeUnitLists(nbUnits, elfs, goblins)

    -- PLay one turn for each unit
    for unitIndex = 1,#unitList do
      -- Retrieve the current unit
      currentUnit = unitList[unitIndex]

      print(currentUnit.type)
      print(point.toString(currentUnit.position))

      -- Select the right targets
      targets = nil
      if currentUnit.type == "E" then
        targets = goblins
      elseif currentUnit.type == "G" then
        targets = elfs
      end

      -- Iterate over all targets left
      --findCells(currentUnit, targets)
      local inRangeCells = {}
      for i = 1,#targets do
        -- Tag (Add) all adjacent cells (up, down, left, right) that are not wall or unit.
        if canAttack(nextPlayingUnit, targets) then
          -- ATTACK
          -- TODO

        else
          -- TRY TO MOVE
          local chosenPosition = findNextPositionToReach(currentUnit, targets, map)

          -- If the unit can move
          if chosenPosition ~= nil then
            -- MOVE
            print("CHOSEN POSITION ", point.toString(chosenPosition))

          end
          -- END TURN
        end
      end

    end

    -- Sort each unit in their respective list

    nbTurn = nbTurn + 1
  end

  return 0;

end

------------------------------------------------------------------------
-- partTwo - function used for the part 2
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 2.
------------------------------------------------------------------------
local function partTwo (inputFile, map)

  -- TODO

  return 0;
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function preProcessing(inputFile)
  local fileLines = helper.saveLinesToArray(inputFile);

  -- Stock all the point in a matrix
  local map = {}
  for j=1,#fileLines do
    map[j] = {}
    for i=1,#fileLines[1] do
      map[j][i] = fileLines[j]:sub(i,i)
    end
  end

  local nbUnits = 0
  local elfs = {}
  local goblins = {}

  -- For each lines in the file
  for i = 1, #fileLines do
    local index = 1
    local previousXPos = 0
    local currentLine = fileLines[i]
    repeat
      print(index)
      local nextXPos = helper.findNextSymbolInString(currentLine, index, #currentLine, {"G", "E"})

      if nextXPos ~= nil then
        nextXPos = nextXPos + previousXPos
        previousXPos = nextXPos
        print("RES =" .. nextXPos)
        --nextXPos = nextXPos + index
        index = index + nextXPos

        print(currentLine:sub(nextXPos, nextXPos))

        -- Create the unit
        local newUnit = {type=currentLine:sub(nextXPos, nextXPos), position=point.new{nextXPos-1, i-1}, attack=3, health=200}

        -- Add it to the right team
        if newUnit.type == "G" then
          table.insert(goblins, newUnit)
        elseif newUnit.type == "E" then
          table.insert(elfs, newUnit)
        else
          print("Unknown unit...")
        end
        nbUnits = nbUnits + 1

      end
    until nextXPos == nil or index >= #currentLine
  end
  return nbUnits, elfs, goblins, map
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function preProcessing2 (inputFile)
  local firstnode = nil
  local nbUnits = 0
  local elfs = {}
  local goblins = {}

  local fileLines = helper.saveLinesToArray(inputFile);

  -- Stock all the point in a matrix
  matrix = {}
  for j=1,#fileLines do
    matrix[j] = {}
    for i=1,#fileLines[1] do
      matrix[j][i] = fileLines[j]:sub(i,i)
    end
  end

  -- Debug

  print(mapToString(map))

  -- Retrieve the first line usefull (the first one contains only walls)
  firstLine = fileLines[2]

  print(firstLine)

  local index = 1
  local nextXPos = helper.findNextSymbolInString(firstLine, 1, #firstLine, {".", "G", "E"})

  if nextXPos ~= nil then
    print("RES =" .. nextXPos)
    --nextXPos = nextXPos + index
    index = index + nextXPos

    print(firstLine:sub(nextXPos, nextXPos))

    -- Register it in the right array if it's a unit
    local infos = {}
    if firstLine:sub(nextXPos, nextXPos) == "G" then
      infos = {type=firstLine:sub(nextXPos, nextXPos), position=point.new{nextXPos-1, 1}, attack=3, health=200}
      table.insert(goblins, infos)
      nbUnits = nbUnits + 1
    elseif firstLine:sub(nextXPos, nextXPos) == "E" then
      infos = {type="E", position=point.new{nextXPos-1, 1}, attack=3, health=200}
      table.insert(elfs, infos)
      nbUnits = nbUnits + 1
    else
      infos = {type="path", position=point.new{nextXPos-1, 1}}
    end

    -- Create a node with the infos array
    firstnode = {info=infos, top=nil, right=nil, bottom=nil, left=nil}

    -- Create a stack
    nextPoints = stack.new()
    stack.pushright(nextPoints, firstnode)
    --stack.printstack(nextPoints)

    -- Convert the entire map into graph...
    while getSize(nextPoints) > 1 do
      -- TODO LATER

      -- TOP

      -- RIGHT

      -- BOTTOM

      -- LEFT


    end
  end

  -- Debug here


  return nbUnits, elfs, goblins
end

--#################################################################
-- Main - Main function
--#################################################################
function day15Main (filename)
  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  nbUnits, elfs, goblins, map = preProcessing(inputFile)

  --nbUnits, elfs, goblins = preProcessing2(inputFile)

  -- DEBUG HERE
  -----------------------------------------
  -- Elfs list should be order in the reading order !
  for i = 1,#elfs do
    print("ELFS " .. i .. ", Health = " .. elfs[i].health .. ", Attack =" .. elfs[i].attack .. ", Position = " .. point.toString(elfs[i].position))
  end

  -- goblins list should be order in the reading order !
  for i = 1,#goblins do
    print("GOBLINS " .. i .. ", Health = " .. goblins[i].health .. ", Attack =" .. goblins[i].attack .. ", Position = " .. point.toString(goblins[i].position))
  end

  -- Debug map
  print(mapToString(map))

  -- Launch and print the final result
  print("Result part one :", partOne(nbUnits, elfs, goblins, map));

  -- Reset the file handle position to the beginning to use it again
  inputFile:seek("set");

  -- Launch and print the final result
  print("Result part two :", partTwo(nbUnits, elfs, goblins, map));

  -- Finally close the file
  inputFile:close();
end

--#################################################################
-- Package end
--#################################################################

day15 = {
  day15Main = day15Main,
}

return day15
