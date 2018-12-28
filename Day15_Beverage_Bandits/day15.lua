--#################################################################
--# @author: Grégoire Boiron                                      #
--# @date: 12/XX/2018                                             #
--#                                                               #
--# Template used for every main script for the day X of the AoC  #
--#################################################################

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
  for j = 1, #map do
    for i = 1, #map[j] do
      finalString = finalString .. "" .. map[j][i]
    end
    --finalString = finalString .. "\n"
  end
  return finalString
end

------------------------------------------------------------------------
-- Exist at least one path to that square !
------------------------------------------------------------------------
function isInRange(currentTargetPos)
  local isInRange = false
  local finalPoints = {}
  -- for each side (bottom, right, left, top) = Inverse of the Reading Order)
  -- The previous order MATTERS ! it will helps settings the previous link in the reading order for pathfinding.
  adjacentSquares = {
    {type=map[(currentTargetPos.position.y+1)+1][(currentTargetPos.position.x)+1], position=point.new{currentTargetPos.position.x, currentTargetPos.position.y+1}, parentPos=currentTargetPos},
    {type=map[(currentTargetPos.position.y)+1][(currentTargetPos.position.x+1)+1], position=point.new{currentTargetPos.position.x+1, currentTargetPos.position.y}, parentPos=currentTargetPos},
    {type=map[(currentTargetPos.position.y)+1][(currentTargetPos.position.x-1)+1], position=point.new{currentTargetPos.position.x-1, currentTargetPos.position.y}, parentPos=currentTargetPos},
    {type=map[(currentTargetPos.position.y-1)+1][(currentTargetPos.position.x)+1], position=point.new{currentTargetPos.position.x, currentTargetPos.position.y-1}, parentPos=currentTargetPos},
  }

  for i=1,#adjacentSquares do
    if adjacentSquares[i].type ~= "E" and adjacentSquares[i].type ~= "G" and adjacentSquares[i].type ~= "#" then
      --print(adjacentSquares[i].type);  print(point.toString(adjacentSquares[i].position))
      table.insert(finalPoints, adjacentSquares[i])
      isInRange = true
    end
  end
  return isInRange, finalPoints
end

function foundEnemies(currentTargetPos, type)
  local isInRange = false
  local finalPoints = {}
  -- for each side (in the Reading Order)
  -- The previous order MATTERS ! it will helps settings the previous link in the reading order for pathfinding.
  adjacentSquares = {
    {type=map[(currentTargetPos.position.y-1)+1][(currentTargetPos.position.x)+1], position=point.new{currentTargetPos.position.x, currentTargetPos.position.y-1}, parentPos=currentTargetPos},
    {type=map[(currentTargetPos.position.y)+1][(currentTargetPos.position.x-1)+1], position=point.new{currentTargetPos.position.x-1, currentTargetPos.position.y}, parentPos=currentTargetPos},
    {type=map[(currentTargetPos.position.y)+1][(currentTargetPos.position.x+1)+1], position=point.new{currentTargetPos.position.x+1, currentTargetPos.position.y}, parentPos=currentTargetPos},
    {type=map[(currentTargetPos.position.y+1)+1][(currentTargetPos.position.x)+1], position=point.new{currentTargetPos.position.x, currentTargetPos.position.y+1}, parentPos=currentTargetPos},
  }

  for i=1,4 do
    if adjacentSquares[i].type == type then
      table.insert(finalPoints, adjacentSquares[i])
      isInRange = true
    end
  end
  return isInRange, finalPoints
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


----------------------------------------------------------------------------------------------
-- Return true if the unit2 should be before the unit1 (not in reading order), false otherwise.
----------------------------------------------------------------------------------------------
function isNotUnitsInRO (unit1, unit2)
  position1 = unit1.position
  position2 = unit2.position
  return not ((position1.y < position2.y) or (position1.y == position2.y and position1.x < position2.x))
end

------------------------------------------------------------------------
-- Return true if the position of the unit2 should be before the position
-- of the unit1 (not in reading order), false otherwise.
------------------------------------------------------------------------
function isNotPositionsInRO (position1, position2)
  return not ((position1.y < position2.y) or (position1.y == position2.y and position1.x < position2.x))
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function findNextPlayingUnit (units)
  local nextUnit = nil
  local finalIndex = nil

  for i=1,#units do
    --print(point.toString(nextUnit.position))
    --print(point.toString(units[i].position))
    if units[i] ~= nil and units[i].position ~= nil then
      if nextUnit == nil then
          nextUnit = units[i]
          finalIndex = i
      else
        local _, tempIndex = findfirstPosInRO(nextUnit.position, units[i].position, finalIndex, i)
        if finalIndex ~= tempIndex then
          nextUnit = units[i]
          finalIndex = i
        end
      end
    end
  end

  return nextUnit, finalIndex
end
print("|-------------------------------------------|")
print("| Tests findNextPlayingUnit function :      |")
print("|-------------------------------------------|")
print(point.equals(findNextPlayingUnit({{position={x=2, y=1}}, nil}), {position={x=2,y=1}}, 1))
print(point.equals(findNextPlayingUnit({nil, {position={x=3, y=1}}}), {position={x=3,y=1}}, 2))
print(point.equals(findNextPlayingUnit({{position={x=2, y=1}}, {}}), {position={x=2,y=1}}, 1))
print(point.equals(findNextPlayingUnit({{}, {position={x=3, y=1}}}), {position={x=3,y=1}}, 2))
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
  local goblinIndex = 1
  local elfIndex = 1

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
      if arg[i][teamIndexes[i]] ~= nil then
        print("ICI", i, point.toString(arg[i][teamIndexes[i]].position))
      end
      if arg[i][teamIndexes[i]] == nil then
        table.insert(competingUnit, {})
      else
        table.insert(competingUnit, arg[i][teamIndexes[i]])
      end
    end

    for i = 1,#competingUnit do
      print(competingUnit[i].position)
    end

    nextPlayingUnit, UnitTeamIndex = findNextPlayingUnit(competingUnit)

    --print("FOUND UNIT Type = " .. nextPlayingUnit.type .. ", Health = " .. nextPlayingUnit.health .. ", Attack =" .. nextPlayingUnit.attack .. ", Position = " .. point.toString(nextPlayingUnit.position))
    print("INDEX", UnitTeamIndex)

    -- Update and Insert the unit
    nextPlayingUnit.unitList = #unitList + 1
    if nextPlayingUnit.type == "G" then
      nextPlayingUnit.listIndex = goblinIndex
      goblinIndex = goblinIndex + 1
    else
      nextPlayingUnit.listIndex = elfIndex
      elfIndex = elfIndex + 1
    end
    table.insert(unitList, nextPlayingUnit)

    -- Update the index of the list of that unit to "remove" unit
    teamIndexes[UnitTeamIndex] = teamIndexes[UnitTeamIndex] + 1
  end

  return unitList
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function closestPointHeuristique(point1, point2, target)
  --print("POINT1", point.toString(point1))
  --print("POINT2", point.toString(point2))

  -- Compute both point distance to the target
  local distancePoint1ToTarget = math.abs(target.x - point1.x) + math.abs(target.y - point1.y)
  local distancePoint2ToTarget = math.abs(target.x - point2.x) + math.abs(target.y - point2.y)

  -- Study all cases
  if distancePoint1ToTarget == distancePoint2ToTarget then
    --print("DEBUG" .. point.toString(findfirstPosInRO(point1, point2)))
    --print(point.equals(point2, findfirstPosInRO(point1, point2)))
    return not point.equals(point2, findfirstPosInRO(point1, point2))
  elseif distancePoint1ToTarget < distancePoint2ToTarget then
    --print("FALSE")
    return true
  elseif distancePoint1ToTarget > distancePoint2ToTarget then
    --print("TRUE")
    return false
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
  _, possibleNextPoints = isInRange(currentPoint)

  possibleNextPoints = point.bubbleSortPoints(possibleNextPoints, heuristique, endingPoint)
  return possibleNextPoints
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function findShortestPathReadingOrder(source, target, weigthedMap)
  --local path = {}
  local nextStep = nil

  local next = source
  while not point.equals(next.position, target.position) do

    -- Retrieve the adjacent point from the current square
    adjacentSquares = {
      {length=weigthedMap[(next.position.y+1)+1][(next.position.x)+1], position=point.new{next.position.x, next.position.y+1}, parentPos=next},
      {length=weigthedMap[(next.position.y)+1][(next.position.x+1)+1], position=point.new{next.position.x+1, next.position.y}, parentPos=next},
      {length=weigthedMap[(next.position.y)+1][(next.position.x-1)+1], position=point.new{next.position.x-1, next.position.y}, parentPos=next},
      {length=weigthedMap[(next.position.y-1)+1][(next.position.x)+1], position=point.new{next.position.x, next.position.y-1}, parentPos=next},
    }

    for i = 1,#adjacentSquares do
      if adjacentSquares[i].length ~= "#" then
        if nextStep == nil or (tonumber(adjacentSquares[i].length) <= tonumber(nextStep.length) and isNotUnitsInRO(nextStep, adjacentSquares[i])) then
          nextStep = adjacentSquares[i]
        end
      end
    end
    --print(point.toString(nextStep.position))
    next = target
  end

  return nextStep
end


------------------------------------------------------------------------
--
------------------------------------------------------------------------
function dijkstraSquare(source, target, map)
  local isReachable = false;

  -- Build the initial Weighted map
  local weightedMap = {}
  for j = 1, #map do
    weightedMap[j] = {}
    for i = 1, #map[j] do
      if map[j][i] ~= "#" then
        weightedMap[j][i] = 0
      else
        weightedMap[j][i] = "#"
      end
    end
  end

  ------------
  -- Apply the "dijkstra" algorithm here
  ------------

  --
  local visitedSquares = {}
  local currentSquares = stack.new()
  local nextSquares = stack.new()

  -- Update data structures for the first point
  stack.pushleft(currentSquares, target)
  table.insert(visitedSquares, target.position)

  local currentLength = 0

  repeat
    -- Update the length for each iteration
    currentLength = currentLength + 1

    next = stack.popright(currentSquares)

    -- Update the boolean
    isReachable = isReachable or point.equals(next.position, source.position)

    while next ~= nil do
      -- Retrieve the adjacent point from the current square
      adjacentSquares = {
        {type=map[(next.position.y+1)+1][(next.position.x)+1], position=point.new{next.position.x, next.position.y+1}, parentPos=next},
        {type=map[(next.position.y)+1][(next.position.x+1)+1], position=point.new{next.position.x+1, next.position.y}, parentPos=next},
        {type=map[(next.position.y)+1][(next.position.x-1)+1], position=point.new{next.position.x-1, next.position.y}, parentPos=next},
        {type=map[(next.position.y-1)+1][(next.position.x)+1], position=point.new{next.position.x, next.position.y-1}, parentPos=next},
      }

      for i = 1,#adjacentSquares do
        if adjacentSquares[i].type ~= "#" then
          if not list.contains(visitedSquares, adjacentSquares[i].position, point.equals) then
            stack.pushleft(nextSquares, adjacentSquares[i])
          end
        end
      end

      next = stack.popright(currentSquares)
    end

    -- For all the points present in the nextSquares queues
    next = stack.popright(nextSquares)
    while next ~= nil do

      if next.type ~= "#" then
        weightedMap[(next.position.y)+1][(next.position.x)+1] = currentLength

        -- Update queues for the next iteration
        isReachable = isReachable or point.equals(next.position, source.position)
        table.insert(visitedSquares, next.position)
        stack.pushleft(currentSquares, next)
      end

      next = stack.popright(nextSquares)
    end

    --io.write("PRESSED FOR DEBUG : ")
    --io.flush()
    --io.read()

  until stack.getSize(currentSquares) <= 0

  print(mapToString(weightedMap))

  -- Find the shortest path (in the reading order !)
  return isReachable, findShortestPathReadingOrder(source, target, weightedMap)
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function findNextPositionToReach(rootUnit, targets, map)
  local finalNextStep = nil

  for i = 1,#targets do
    print("NEXT " .. i .. "eme TARGET = " .. point.toString(targets[i].position))

    -- Study if the target can be in range
    local inRange, availableSpots = isInRange(targets[i])
    if inRange then

      -- if it is, find the closest reachable position for each adjacent square (top, bottom, right, left) and take the lowest one.
      -- This step will also compute the length of each closest reachable position
      -- local _, adjacentSquares = isInRange(rootUnit)

      -- /!\ NEED TO REFACTOR that in a DIJKSTRA method to avoid recomputing twice the same square.
      -- The Dijkstra will compute all squares (basically doesn't finish when reaching the target)
      print("DIJKSTRA")
      local isReachable, nextStep = dijkstraSquare(rootUnit, targets[i], map)

      if isReachable then
        print("IS REACHABLE ! ")
        if finalNextStep == nil or nextStep.length < finalNextStep.length then
          finalNextStep = nextStep

          print("------------------------------------------------")
          print("TEMP finallength", finalNextStep.length)
          print("TEMP finalNextStep", point.toString(finalNextStep.position))
        end
      else
        print("NOT REACHABLE UNIT, MOVE TO THE NEXT ONE !")
      end
    else
      print("NOT REACHABLE UNIT, MOVE TO THE NEXT ONE !")
    end

    print("Current " .. i .. "eme TARGET = " .. point.toString(targets[i].position))

    --io.write("Pressed any keys to go to the next target : ")
    --io.flush()
    --io.read()
  end

  if finalNextStep ~= nil then
    print("FINAL lengthShorestPath", finalNextStep.length)
    print("FINAL chosenposition", point.toString(finalNextStep.position))
  end
  return finalNextStep
end

function isAttackPossible(unit, targets)
  local canAttack = false
  local enemyList = {}
  -- Get adjacent squares to study them

  _, adjacentSquares = foundEnemies(unit, targets[1].type)

  -- Found out which enemies is on those squares (to retrieve their infos)
  for squareIndex = 1, #adjacentSquares do
    -- For the current adjacent square, find the ennemy in the list
    for targetIndex = 1,#targets do
      print(point.toString(adjacentSquares[squareIndex].position))
      print(point.toString(targets[targetIndex].position))
      if point.equals(adjacentSquares[squareIndex].position, targets[targetIndex].position) then
        canAttack = true
        table.insert(enemyList, targets[targetIndex])
      end
    end
  end
  return canAttack, enemyList
end

function foundNextVictim(targets)
  local nextVictim = nil

  for i = 1, #targets do
    if nextVictim == nil then
      nextVictim = targets[i]
    else
      if nextVictim.health > targets[i].health then
        nextVictim = targets[i]
      end
    end
  end

  return nextVictim
end

------------------------------------------------------------------------
-- ATTACK
------------------------------------------------------------------------
function attackUnit(attackingUnit, closeEnemies, nbUnits, unitList, goblins, elfs, map)
  local done = false

  -- Found the next victim we'll be attacking
  if #closeEnemies > 1 then
    victim = foundNextVictim(closeEnemies)
  else
    victim = closeEnemies[1]
  end

  print("** ATTACK: The " .. currentUnit.type .. " attack the unit " .. victim.type .. " at position = " .. point.toString(victim.position) .. " !")
  print("** ATTACK: The victim " .. victim.type .. " health goes from " .. victim.health .. " to " .. (victim.health-currentUnit.attack) .. " !")

  -- Attack him
  victim.health = victim.health - currentUnit.attack


  -- Check if the unit needs to be removed (health <= 0)
  if victim.health <= 0 then
  --if victim.health < 200 then
    print("** DEATH: The " .. currentUnit.type .. " killed the unit " .. victim.type .. " at position = " .. point.toString(victim.position) .. " !")
    -- Remove it from the unitList (to continue the game)
    nbUnits = nbUnits - 1
    table.remove(unitList, victim.unitList)
    -- Update all the unitList index of the following units
    for unitIndex = 1,#unitList do
      if unitList[unitIndex].unitList > victim.unitList then
        unitList[unitIndex].unitList = unitList[unitIndex].unitList - 1
      end
    end


    for unitIndex = 1,#unitList do
      print("The " .. unitList[unitIndex].type .. ", ListIndex = " .. unitList[unitIndex].listIndex .. ", UnitListIndex = " .. unitList[unitIndex].unitList .. " Health = " .. unitList[unitIndex].health .. ", Attack =" .. unitList[unitIndex].attack .. ", Position = " .. point.toString(unitList[unitIndex].position))
    end

    -- Remove it from his own list
    if currentUnit.type == "E" then
      table.remove(goblins, victim.listIndex)
      done = #goblins <= 0
      for i = 1,#goblins do
        print("GOBLINS " .. i .. ", Health = " .. goblins[i].health .. ", Attack =" .. goblins[i].attack .. ", Position = " .. point.toString(goblins[i].position))
      end
    elseif currentUnit.type == "G" then
      table.remove(elfs, victim.listIndex)
      done = #elfs <= 0
      for i = 1,#elfs do
        print("ELFS " .. i .. ", Health = " .. elfs[i].health .. ", Attack =" .. elfs[i].attack .. ", Position = " .. point.toString(elfs[i].position))
      end
    end

    -- Remove the unit from the map
    map[victim.position.y+1][victim.position.x+1] = "."
  end

  return done, nbUnits, unitList, goblins, elfs, map
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
  nbTurn = 1
  while not done and nbTurn <= 47 do

    print("@@@@@@@@@@@ START TURN " .. nbTurn .. " ! @@@@@@@@@@@")

    -- Merge all the unit list into one big ordered by playing turn !
    unitList = mergeUnitLists(nbUnits, elfs, goblins)

    -- Reset all actions points of all units
    for unitIndex = 1,#unitList do
      unitList[unitIndex].movementPoint = 1
      unitList[unitIndex].attackPoint = 1
    end

    for unitIndex = 1,#unitList do
      print("The " .. unitList[unitIndex].type .. ", ListIndex = " .. unitList[unitIndex].listIndex .. ", UnitListIndex = " .. unitList[unitIndex].unitList .. " Health = " .. unitList[unitIndex].health .. ", Attack =" .. unitList[unitIndex].attack .. ", Position = " .. point.toString(unitList[unitIndex].position))
    end

    -- PLay one turn for each unit
    -- TODO REMOVE THAT AND MAKE A LIST.
    for unitIndex = 1,#unitList do
      -- Retrieve the current unit
      currentUnit = unitList[unitIndex]

      print(unitIndex)
      if currentUnit ~= nil then
        print("** START TURN: The " .. currentUnit.type .. ", Health = " .. currentUnit.health .. ", Attack =" .. currentUnit.attack .. ", Position = " .. point.toString(currentUnit.position))

        io.write("Pressed any keys to skip to the next unit : ")
        io.flush()
        io.read()

        -- Select the right targets
        targets = nil
        if currentUnit.type == "E" then
          targets = goblins
        elseif currentUnit.type == "G" then
          targets = elfs
        end

        -- Iterate over all targets left
        local inRangeCells = {}

        local endTurn = false
        repeat
          -----------------------------
          -- FIRST: TRY TO ATTACK
          -- Tag (Add) all adjacent cells (up, down, left, right) that are not wall or unit.
          local canAttack, closeEnemies = isAttackPossible(currentUnit, targets)
          if canAttack and currentUnit.attackPoint >= 0 then
            -- ATTACK
            print("** ATTACK: The " .. currentUnit.type .. " decided to attack !")
            done, nbUnits, unitList, goblins, elfs, map = attackUnit(currentUnit, closeEnemies, nbUnits, unitList, goblins, elfs, map)
            if done then
              break
            end

            currentUnit.attackPoint = currentUnit.attackPoint - 1
            endTurn = true
          end

          if not endTurn then
            -----------------------------
            -- SECONDE: TRY TO MOVE
            local nextStep = findNextPositionToReach(currentUnit, targets, map)
            if nextStep ~= nil and currentUnit.movementPoint > 0 then
              print("** MOVE: The " .. currentUnit.type .. " choose square " .. point.toString(nextStep.position) .. " as target !")

              -- Update the map
              map[currentUnit.position.y+1][currentUnit.position.x+1] = "."

              -- MOVE
              print("** MOVE: The " .. currentUnit.type .. " move from " .. point.toString(currentUnit.position) .. " to " .. point.toString(nextStep.position) .. " to reach his final target" .. " TODO " .. "!")
              currentUnit.position = nextStep.position

              -- Update the map
              map[currentUnit.position.y+1][currentUnit.position.x+1] = currentUnit.type

              currentUnit.movementPoint = currentUnit.movementPoint - 1
            else
              endTurn = true
            end
          end
        until endTurn or (currentUnit.movementPoint <= 0 and currentUnit.attackPoint <= 0)

        print("** END TURN: The " .. currentUnit.type .. ", Health = " .. currentUnit.health .. ", Attack =" .. currentUnit.attack .. ", Position = " .. point.toString(currentUnit.position))

        -- Debug map
        print(mapToString(map))

      else
        print("Ghost unit..")
      end
    end

    -- Sort each unit in their respective list
    -- Maybe later for optimization purpose.
    -- NOP NOW !
    print("BUBBLE SORT TIME !!!!")
    elfs = list.bubbleSortList(elfs, isNotUnitsInRO)
    goblins = list.bubbleSortList(goblins, isNotUnitsInRO)

    --for i = 1,#elfs do
    --  print("ELFS " .. i .. ", Health = " .. elfs[i].health .. ", Attack =" .. elfs[i].attack .. ", Position = " .. point.toString(elfs[i].position))
    --end

    -- goblins list should be order in the reading order !
    --for i = 1,#goblins do
    --  print("GOBLINS " .. i .. ", Health = " .. goblins[i].health .. ", Attack =" .. goblins[i].attack .. ", Position = " .. point.toString(goblins[i].position))
    --end

    -- Debug map
    print(mapToString(map))

    print("@@@@@@@@@@@ END TURN " .. nbTurn .. " ! @@@@@@@@@@@")

    for unitIndex = 1,#unitList do
      print("The " .. unitList[unitIndex].type .. ", ListIndex = " .. unitList[unitIndex].listIndex .. ", UnitListIndex = " .. unitList[unitIndex].unitList .. " Health = " .. unitList[unitIndex].health .. ", Attack =" .. unitList[unitIndex].attack .. ", Position = " .. point.toString(unitList[unitIndex].position))
    end

    io.write("Pressed any keys to play one more turn : ")
    io.flush()
    io.read()

    nbTurn = nbTurn + 1
  end

  -- Debug map
  print(mapToString(map))

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
    local nextXPos = 0
    local index = 1
    local previousXPos = 0
    local currentLine = fileLines[i]
    repeat
      nextXPos = helper.findNextSymbolInString(currentLine, index, #currentLine, {"G", "E"})

      if nextXPos ~= nil then
        nextXPos = nextXPos + index - 1
        --print(currentLine:sub(nextXPos, nextXPos))

        -- Create the unit with all the parameters
        local newUnit = {
          listIndex=nil,
          unitList=nil,
          type=currentLine:sub(nextXPos, nextXPos),
          position=point.new{nextXPos-1, i-1},
          attack=3,
          health=200,
          movementPoint=1,
          attackPoint=1,
        }

        -- Add it to the right team
        if newUnit.type == "G" then
          table.insert(goblins, newUnit)
        elseif newUnit.type == "E" then
          table.insert(elfs, newUnit)
        else
          print("Unknown unit...")
        end
        nbUnits = nbUnits + 1

        index = index + nextXPos
      end
    until nextXPos == nil or index >= #currentLine
  end
  return nbUnits, elfs, goblins, map
end

--#################################################################
-- Main - Main function
--#################################################################
function day15Main (filename)
  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  nbUnits, elfs, goblins, map = preProcessing(inputFile)

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
