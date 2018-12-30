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
    finalString = finalString .. "\n"
  end
  return finalString
end

------------------------------------------------------------------------
-- Exist at least one path to that square !
------------------------------------------------------------------------
function isInRange(currentTargetPos, map)
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
    if adjacentSquares[i].type == "." then
      --print(adjacentSquares[i].type);  print(point.toString(adjacentSquares[i].position))
      table.insert(finalPoints, adjacentSquares[i])
      isInRange = true
    end
  end
  return isInRange, finalPoints
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function foundEnemies(currentTargetPos, type, map)
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

  --print(point.toString(nextUnit.position))

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
function resetActionsPoints(unit)
  unit.movementPoint = 1
  unit.attackPoint = 1
  return unit
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function incrementAttackDamage(unit, amount)
  unit.attack = unit.attack + amount
  return unit
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function mergeUnitLists (nbUnits, ...)
  local firstUnit = nil
  local goblinIndex = 1
  local elfIndex = 1

  local nbTeam = select("#",...)

  -- Create an index of each team
  local teamIndexes = {}
  for i = 1,nbTeam do
    table.insert(teamIndexes, 1)
  end

  local arg = {...}
  local addedUnit = 0
  while addedUnit < nbUnits do

    -- Find the next playing unit among all separate lists of units
    competingUnit = {}
    for i = 1, nbTeam do
      if arg[i][teamIndexes[i]] ~= nil then
        --print("ICI", i, point.toString(arg[i][teamIndexes[i]].position))
      end
      if arg[i][teamIndexes[i]] == nil then
        table.insert(competingUnit, {})
      else
        table.insert(competingUnit, arg[i][teamIndexes[i]])
      end
    end

    for i = 1,#competingUnit do
      if competingUnit[i].position ~= nil then
        print("ICICICI", point.toString(competingUnit[i].position))
      else
        print("nilll")
      end
    end

    nextPlayingUnit, UnitTeamIndex = findNextPlayingUnit(competingUnit)

    --print("FOUND UNIT Type = " .. nextPlayingUnit.type .. ", Health = " .. nextPlayingUnit.health .. ", Attack =" .. nextPlayingUnit.attack .. ", Position = " .. point.toString(nextPlayingUnit.position))
    print("INDEX", UnitTeamIndex)

    -- Update and Insert the unit
    if nextPlayingUnit.type == "G" then
      nextPlayingUnit.listIndex = goblinIndex
      goblinIndex = goblinIndex + 1
    else
      nextPlayingUnit.listIndex = elfIndex
      elfIndex = elfIndex + 1
    end

    -- Reset all the actions points
    nextPlayingUnit = resetActionsPoints(nextPlayingUnit)

    local nextUnit = {value=nextPlayingUnit, next=nil}
    if firstUnit == nil then
      firstUnit = nextUnit
    else
      currentUnit.next = nextUnit
    end

    -- Update values
    currentUnit = nextUnit
    addedUnit = addedUnit + 1

    -- Update the index of the list of that unit to "remove" unit
    teamIndexes[UnitTeamIndex] = teamIndexes[UnitTeamIndex] + 1
  end

  return firstUnit
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
  _, possibleNextPoints = isInRange(currentPoint, map)

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
      {length=weigthedMap[(next.position.y+1)+1][(next.position.x)+1], position=point.new{next.position.x, next.position.y+1}},
      {length=weigthedMap[(next.position.y)+1][(next.position.x+1)+1], position=point.new{next.position.x+1, next.position.y}},
      {length=weigthedMap[(next.position.y)+1][(next.position.x-1)+1], position=point.new{next.position.x-1, next.position.y}},
      {length=weigthedMap[(next.position.y-1)+1][(next.position.x)+1], position=point.new{next.position.x, next.position.y-1}},
    }

    for i = 1,#adjacentSquares do
      if adjacentSquares[i].length ~= "#" and tonumber(adjacentSquares[i].length) > 0 then
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
function dijkstraSquare(source, target, availableSpots, map)
  local isReachable = false;
  local finalSpots = nil

  -- Build the initial Weighted map
  local weightedMap = {}
  for j = 1, #map do
    weightedMap[j] = {}
    for i = 1, #map[j] do
      if map[j][i] == "." or (j == target.position.y+1 and i == target.position.x+1) or (j == source.position.y+1 and i == source.position.x+1) then
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
  table.insert(visitedSquares, target.position)
  stack.pushleft(currentSquares, target)

  --repeat
  -- Retrieve the next square to be studied (neighborhood study)
  local next = stack.popright(currentSquares)

  local currentLength = 1

  -- If their is a square left
  while next ~= nil do

    -- Update the boolean
    isReachable = isReachable or point.equals(next.position, source.position)

    -- Set the length of the current point (which is navigable because it was added)
    if next.length ~= nil then
      weightedMap[(next.position.y)+1][(next.position.x)+1] = next.length

      -- Update the length for each iteration
      currentLength = next.length + 1
    end

    -- Retrieve the adjacent point from the current square
    local adjacentSquares = {
      {type=map[(next.position.y+1)+1][(next.position.x)+1], position=point.new{next.position.x, next.position.y+1}, length=currentLength},
      {type=map[(next.position.y)+1][(next.position.x+1)+1], position=point.new{next.position.x+1, next.position.y}, length=currentLength},
      {type=map[(next.position.y)+1][(next.position.x-1)+1], position=point.new{next.position.x-1, next.position.y}, length=currentLength},
      {type=map[(next.position.y-1)+1][(next.position.x)+1], position=point.new{next.position.x, next.position.y-1}, length=currentLength},
    }

    for i = 1,#adjacentSquares do
      if tonumber(weightedMap[(adjacentSquares[i].position.y)+1][(adjacentSquares[i].position.x)+1]) ~= nil then

        -- Add the point that need to be added in the currentSquares list (it is navigable and not already visited)
        if not list.contains(visitedSquares, adjacentSquares[i].position, point.equals) then
          table.insert(visitedSquares, adjacentSquares[i].position)
          stack.pushleft(currentSquares, adjacentSquares[i])
        end
      end
    end

    -- For GC
    adjacentSquares = nil

    next = stack.popright(currentSquares)

    --print(mapToString(weightedMap))

    --io.write("PRESSED FOR DEBUG : ")
    --io.flush()
    --io.read()

  end

  --io.write("PRESSED FOR DEBUG : ")
  --io.flush()
  --io.read()

  --until stack.getSize(currentSquares) <= 0

  --print(mapToString(weightedMap))

  -- Find the shortest path (in the reading order !)
  --print("FINAL SPOT :", point.toString(finalSpots.position))
  return isReachable, findShortestPathReadingOrder(source, target, weightedMap)
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function findNextPositionToReach(rootUnit, targets, map)
  local finalNextStep = nil

  for i = 1,#targets do
    --print("CURRENT " .. i .. "eme TARGET = " .. point.toString(targets[i].position))

    -- Study if the target can be in range
    local inRange, availableSpots = isInRange(targets[i], map)
    if inRange then
      --print("IS IN RANGE !")
      -- if it is, find the closest reachable position for each adjacent square (top, bottom, right, left) and take the lowest one.
      -- This step will also compute the length of each closest reachable position
      -- local _, adjacentSquares = isInRange(rootUnit, map)

      -- /!\ NEED TO REFACTOR that in a DIJKSTRA method to avoid recomputing twice the same square.
      -- The Dijkstra will compute all squares (basically doesn't finish when reaching the target)
      --print("DIJKSTRA")
      local isReachable, nextStep = dijkstraSquare(rootUnit, targets[i], availableSpots, map)

      if isReachable then
        --print("IS REACHABLE ! ")
        if finalNextStep == nil or nextStep.length < finalNextStep.length then
          finalNextStep = nextStep

          --print("------------------------------------------------")
          --print("TEMP finallength", finalNextStep.length)
          --print("TEMP finalNextStep", point.toString(finalNextStep.position))
        end
      else
        --print("NOT REACHABLE UNIT, MOVE TO THE NEXT ONE !")
      end
    else
      --print("NOT REACHABLE UNIT, MOVE TO THE NEXT ONE !")
    end

    --print("Current " .. i .. "eme TARGET = " .. point.toString(targets[i].position))

    --io.write("Pressed any keys to go to the next target : ")
    --io.flush()
    --io.read()
  end

  if finalNextStep ~= nil then
    --print("FINAL lengthShorestPath", finalNextStep.length)
    --print("FINAL chosenposition", point.toString(finalNextStep.position))
  end
  return finalNextStep
end

function isAttackPossible(unit, targets, map)
  local canAttack = false
  local enemyList = {}
  -- Get adjacent squares to study them

  _, adjacentSquares = foundEnemies(unit, targets[1].type, map)

  -- Found out which enemies is on those squares (to retrieve their infos)
  for squareIndex = 1, #adjacentSquares do
    -- For the current adjacent square, find the ennemy in the list
    for targetIndex = 1,#targets do
      --print(point.toString(adjacentSquares[squareIndex].position))
      --print(point.toString(targets[targetIndex].position))
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
function attackUnit(attackingUnit, attackingUnitValues, closeEnemies, nbUnits, goblinsLeft, elfsLeft, map)
  local done = false
  local elfDied = false

  -- Found the next victim we'll be attacking
  if #closeEnemies > 1 then
    victim = foundNextVictim(closeEnemies)
  else
    victim = closeEnemies[1]
  end

  print("** ATTACK: The " .. attackingUnitValues.type .. " attack the unit " .. victim.type .. " at position = " .. point.toString(victim.position) .. " !")
  print("** ATTACK: The victim " .. victim.type .. " health goes from " .. victim.health .. " to " .. (victim.health-attackingUnitValues.attack) .. " !")

  -- Attack him
  victim.health = victim.health - attackingUnitValues.attack


  -- Check if the unit needs to be removed (health <= 0)
  if victim.health <= 0 then
  --if victim.health < 200 then
    print("** DEATH: The " .. attackingUnitValues.type .. " killed the unit " .. victim.type .. " at position = " .. point.toString(victim.position) .. " !")
    -- Found it and IF THE UNIT DIDNT PLAY ALREADY, Remove it from the linked list (to skip his turn)
    nbUnits = nbUnits - 1

    local previousUnit = attackingUnit
    local followingUnit = attackingUnit.next
    while followingUnit do
      if point.equals(followingUnit.value.position, victim.position) then
        previousUnit.next = followingUnit.next
        followingUnit = nil
      else
        previousUnit = followingUnit
        followingUnit = followingUnit.next
      end
    end

    --local l = attackingUnit
    --while l do
    --  print("The " .. l.value.type .. ", Health = " .. l.value.health .. ", Attack =" .. l.value.attack .. ", Position = " .. point.toString(l.value.position))
    --  l = l.next
    --end

    -- Remove it from his own list (for the next turn)
    if attackingUnitValues.type == "E" then
      table.remove(goblinsLeft, victim.listIndex)
      done = #goblinsLeft <= 0
      -- Shift all the listIndex of all units left
      for i = 1,#goblinsLeft do
        goblinsLeft[i].listIndex = goblinsLeft[i].listIndex - 1
        --print("GOBLINS " .. i .. ", Health = " .. goblinsLeft[i].health .. ", Attack =" .. goblinsLeft[i].attack .. ", Position = " .. point.toString(goblinsLeft[i].position))
      end
    elseif attackingUnitValues.type == "G" then
      elfDied = true
      table.remove(elfsLeft, victim.listIndex)
      done = #elfsLeft <= 0
      for i = 1,#elfsLeft do
        elfsLeft[i].listIndex = elfsLeft[i].listIndex - 1
        --print("ELFS " .. i .. ", Health = " .. elfsLeft[i].health .. ", Attack =" .. elfsLeft[i].attack .. ", Position = " .. point.toString(elfsLeft[i].position))
      end
    end

    -- Remove the unit from the map
    map[victim.position.y+1][victim.position.x+1] = "."
  end

  return done, elfDied, nbUnits, attackingUnit, goblinsLeft, elfsLeft, map
end

------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (nbUnits, elfs, goblins, map)
  local finalScore = 0
  local firstUnit = nil

  -- Game Loop
  done = false
  nbTurn = 1
  while not done and nbTurn <= 100 do

    print("@@@@@@@@@@@ START TURN " .. nbTurn .. " ! @@@@@@@@@@@")

    -- Merge all the unit list into one big ordered by playing turn !
    -- also reset all the actions points
    firstUnit = mergeUnitLists(nbUnits, elfs, goblins)

    --local l = firstUnit
    --while l do
    --  print("The " .. l.value.type .. ", Health = " .. l.value.health .. ", Attack =" .. l.value.attack .. ", Position = " .. point.toString(l.value.position))
    --  l = l.next
    --end

    -- PLay one turn for each unit
    local currentUnit = firstUnit
    while currentUnit and not done do

      -- Retrieve all the info of the current unit
      currentUnitValues = currentUnit.value

      if currentUnitValues ~= nil then
        print("** START TURN: The " .. currentUnitValues.type .. ", Health = " .. currentUnitValues.health .. ", Attack =" .. currentUnitValues.attack .. ", Position = " .. point.toString(currentUnitValues.position))

        --io.write("Pressed any keys to skip to the next unit : ")
        --io.flush()
        --io.read()

        -- Select the right targets
        targets = nil
        if currentUnitValues.type == "E" then
          targets = goblins
        elseif currentUnitValues.type == "G" then
          targets = elfs
        end

        -- Iterate over all targets left
        local inRangeCells = {}

        local endTurn = false
        repeat
          -----------------------------
          -- FIRST: TRY TO ATTACK
          -- Tag (Add) all adjacent cells (up, down, left, right) that are not wall or unit.
          local canAttack, closeEnemies = isAttackPossible(currentUnitValues, targets, map)
          if canAttack and currentUnitValues.attackPoint >= 0 then
            -- ATTACK
            print("** ATTACK: The " .. currentUnitValues.type .. " decided to attack !")
            done, _, nbUnits, currentUnit, goblins, elfs, map = attackUnit(currentUnit, currentUnitValues, closeEnemies, nbUnits, goblins, elfs, map)
            if done then
              break
            end

            currentUnitValues.attackPoint = currentUnitValues.attackPoint - 1
            endTurn = true
          end

          if not endTurn then
            -----------------------------
            -- SECONDE: TRY TO MOVE
            local nextStep = findNextPositionToReach(currentUnitValues, targets, map)
            if nextStep ~= nil and currentUnitValues.movementPoint > 0 then
              print("** MOVE: The " .. currentUnitValues.type .. " choose square " .. point.toString(nextStep.position) .. " as target !")

              -- Update the map
              map[currentUnitValues.position.y+1][currentUnitValues.position.x+1] = "."

              -- MOVE
              print("** MOVE: The " .. currentUnitValues.type .. " move from " .. point.toString(currentUnitValues.position) .. " to " .. point.toString(nextStep.position) .. " to reach his final target" .. " TODO " .. "!")
              currentUnitValues.position = nextStep.position

              -- Update the map
              map[currentUnitValues.position.y+1][currentUnitValues.position.x+1] = currentUnitValues.type

              currentUnitValues.movementPoint = currentUnitValues.movementPoint - 1
            else
              endTurn = true
            end
          end
        until endTurn or (currentUnitValues.movementPoint <= 0 and currentUnitValues.attackPoint <= 0)

        print("** END TURN: The " .. currentUnitValues.type .. ", Health = " .. currentUnitValues.health .. ", Attack =" .. currentUnitValues.attack .. ", Position = " .. point.toString(currentUnitValues.position))

        -- Debug map
        --print(mapToString(map))

      else
        print("Ghost unit..")
      end

      -- Update the unit
      currentUnit = currentUnit.next
    end

    elfs = list.bubbleSortList(elfs, isNotUnitsInRO)
    goblins = list.bubbleSortList(goblins, isNotUnitsInRO)

    print("@@@@@@@@@@@ END TURN " .. nbTurn .. " ! @@@@@@@@@@@")

    --io.write("Pressed any keys to play one more turn : ")
    --io.flush()
    --io.read()

    if currentUnit == nil then
      if not done then
        nbTurn = nbTurn + 1
      end
    else
      nbTurn = nbTurn - 1
    end
  end

  local l = firstUnit
  while l do
    if l.value.health > 0 then
      finalScore = finalScore + l.value.health
    end
    l = l.next
  end

  print("NB TURN", nbTurn)
  print("FINAL SCORE", finalScore)

  return nbTurn * finalScore;
end

------------------------------------------------------------------------
-- partTwo - function used for the part 2
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 2.
------------------------------------------------------------------------
local function partTwo (startingNbUnits, startingElfs, startingGoblins, startingMap)
  local done = false

  local finalScore = 0
  local firstUnit = nil
  local nbTurn = 1
  local elfDied = false

  local nbUnits = startingNbUnits
  local elfs = startingElfs
  local goblins = startingGoblins
  local map = startingMap

  print(startingNbUnits)
  print(#startingElfs)
  print(#startingGoblins)

  -- Game Loop
  while not done and not elfDied and nbTurn <= 10000  do

    print("@@@@@@@@@@@ START TURN " .. nbTurn .. " ! @@@@@@@@@@@")

    -- Merge all the unit list into one big ordered by playing turn !
    -- also reset all the actions points
    local firstUnit = mergeUnitLists(nbUnits, elfs, goblins)

    -- PLay one turn for each unit
    local currentUnit = firstUnit
    while currentUnit and not done and not elfDied do

      -- Retrieve all the info of the current unit
      local currentUnitValues = currentUnit.value

      if currentUnitValues ~= nil then
        print("** START TURN: The " .. currentUnitValues.type .. ", Health = " .. currentUnitValues.health .. ", Attack =" .. currentUnitValues.attack .. ", Position = " .. point.toString(currentUnitValues.position))

        -- Select the right targets
        local targets = nil
        if currentUnitValues.type == "E" then
          targets = goblins
        elseif currentUnitValues.type == "G" then
          targets = elfs
        end

        -- Iterate over all targets left
        local inRangeCells = {}

        local endTurn = false
        repeat
          -----------------------------
          -- FIRST: TRY TO ATTACK
          -- Tag (Add) all adjacent cells (up, down, left, right) that are not wall or unit.
          local canAttack, closeEnemies = isAttackPossible(currentUnitValues, targets, map)
          if canAttack and currentUnitValues.attackPoint >= 0 then
            -- ATTACK
            print("** ATTACK: The " .. currentUnitValues.type .. " decided to attack !")
            done, elfDied, nbUnits, currentUnit, goblins, elfs, map = attackUnit(currentUnit, currentUnitValues, closeEnemies, nbUnits, goblins, elfs, map)
            if done or elfDied then
              break
            end

            currentUnitValues.attackPoint = currentUnitValues.attackPoint - 1
            endTurn = true
          end

          if not endTurn then
            -----------------------------
            -- SECONDE: TRY TO MOVE
            local nextStep = findNextPositionToReach(currentUnitValues, targets, map)
            if nextStep ~= nil and currentUnitValues.movementPoint > 0 then
              print("** MOVE: The " .. currentUnitValues.type .. " choose square " .. point.toString(nextStep.position) .. " as target !")

              -- Update the map
              map[currentUnitValues.position.y+1][currentUnitValues.position.x+1] = "."

              -- MOVE
              print("** MOVE: The " .. currentUnitValues.type .. " move from " .. point.toString(currentUnitValues.position) .. " to " .. point.toString(nextStep.position) .. " to reach his final target" .. " TODO " .. "!")
              currentUnitValues.position = nextStep.position

              -- Update the map
              map[currentUnitValues.position.y+1][currentUnitValues.position.x+1] = currentUnitValues.type

              currentUnitValues.movementPoint = currentUnitValues.movementPoint - 1
            else
              endTurn = true
            end
          end
        until endTurn or (currentUnitValues.movementPoint <= 0 and currentUnitValues.attackPoint <= 0)

        print("** END TURN: The " .. currentUnitValues.type .. ", Health = " .. currentUnitValues.health .. ", Attack =" .. currentUnitValues.attack .. ", Position = " .. point.toString(currentUnitValues.position))
      else
        print("Ghost unit..")
      end

      -- Update the unit
      currentUnit = currentUnit.next
    end

    elfs = list.bubbleSortList(elfs, isNotUnitsInRO)
    goblins = list.bubbleSortList(goblins, isNotUnitsInRO)

    print("@@@@@@@@@@@ END TURN " .. nbTurn .. " ! @@@@@@@@@@@")

    --io.write("Pressed any keys to play one more turn : ")
    --io.flush()
    --io.read()

    if currentUnit == nil then
      if not done then
        nbTurn = nbTurn + 1
      end
    else
      nbTurn = nbTurn - 1
    end
  end

  -- Debug map
  print(mapToString(map))


  for i = 1,#elfs do
    finalScore = finalScore + elfs[i].health
  end

  print("NB TURN", nbTurn)

  print("FINAL SCORE", finalScore)

  return done, elfDied, nbTurn * finalScore;
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
    local temp = 0
    local nextXPos = 0
    local index = 1
    local previousXPos = 0
    local currentLine = fileLines[i]
    repeat
      nextXPos = helper.findNextSymbolInString(currentLine, index, #currentLine, {"G", "E"})
      if nextXPos ~= nil then
        temp = temp + nextXPos
        --print(currentLine:sub(temp, temp))

        -- Create the unit with all the parameters
        local newUnit = {
          listIndex = nil,
          type=currentLine:sub(temp, temp),
          position=point.new{temp-1, i-1},
          attack=3,
          health=200,
          movementPoint=1,
          attackPoint=1,
        }

        -- Add it to the right team
        if newUnit.type == "G" then
          print("GOLBINS", "ligne", i, index)
          table.insert(goblins, newUnit)
        elseif newUnit.type == "E" then
          print("ELFS", "ligne", i, index)
          table.insert(elfs, newUnit)
        else
          print("Unknown unit...")
        end
        nbUnits = nbUnits + 1

        print(nextXPos)

        index = index + nextXPos
      end
      print("INDEX", index)
      print("LIGNE LENGTH", #currentLine)
    until nextXPos == nil or index >= #currentLine
    print("EXIT")
  end
  return nbUnits, elfs, goblins, map
end

--#################################################################
-- Main - Main function
--#################################################################
function day15Main (filename)
  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  local nbUnits, elfs, goblins, map = preProcessing(inputFile)

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
  --print("Result part one :", partOne(nbUnits, elfs, goblins, map));

  -- Reset the file handle position to the beginning to use it again
  inputFile:seek("set");

  local done = false
  local elfDied = false
  local result = 0
  local finish = false

  -- Launch and print the final result
  local currentAttackBoost = 1
  while not finish do
    done, elfDied, result = partTwo(nbUnits, elfs, goblins, map)

    if elfDied then
      done = false
      elfDied = false

      nbUnits, elfs, goblins, map = preProcessing(inputFile)

      inputFile:seek("set");

      for i = 1,#elfs do
        incrementAttackDamage(elfs[i], currentAttackBoost)
      end

      currentAttackBoost = currentAttackBoost + 1

      for i = 1,#elfs do
        print("ELFS " .. i .. ", Health = " .. elfs[i].health .. ", Attack =" .. elfs[i].attack .. ", Position = " .. point.toString(elfs[i].position))
      end
    end

    finish = done and not elfDied
  end
  print("Result part two :", result);

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
