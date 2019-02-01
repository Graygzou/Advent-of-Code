--#################################################################
--# @author: Grégoire Boiron                                      #
--# @date: 25/01/2019                                             #
--#                                                               #
--# Main script for the day 20 of the AoC                         #
--#################################################################

local P = {} -- packages

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  day20 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (inputFile)

  local fileLine = helper.saveLinesToArray(inputFile);

  -- Retrieve the real string only (^ = start / $ = end)
  local regexp = string.match(fileLine[1], "%^(.*)%$")
  print("RegExp = ", regexp)

  local selection = string.match(regexp, '%([^()]*%)')

  while selection ~= nil do
    -- Parse it and choose the greatest option
    local biggestOption = ""
    if string.match(selection, '|%)') == nil then
      for token in string.gmatch(selection, "[^(|)]+") do
        if #token > #biggestOption then
          biggestOption = token
        end
      end
    end

    if string.match(biggestOption, '|') ~= nil or string.match(biggestOption, '%(') or string.match(biggestOption, '%)') then
      return -1
    end

    -- Find the previous selection in the string
    local replacementIndexStart, replacementIndexEnd = string.find(regexp, '%(' .. selection .. '%)')

    -- Replace it.
    regexp = regexp:sub(1, replacementIndexStart-1) .. biggestOption .. regexp:sub(replacementIndexEnd+1, #regexp)

    -- New selection
    selection = string.match(regexp, '%([^()]*%)')
  end

  return #regexp;
end

function hashFct(origin, destination)
  -- Order the two points first
  local firstPoint = origin
  local secondPoint = destination
  if origin.y > destination.y or (origin.y == destination.y and origin.x < destination.x) then
    firstPoint = origin
    secondPoint = destination
  else
    firstPoint = destination
    secondPoint = origin
  end

  return firstPoint.x .. "," .. firstPoint.y .. " | " .. secondPoint.x .. "," .. secondPoint.y
end

local function partTwo(inputFile, nbDoors)
  local nbRooms = 0
  local visitedPoint = Set{}

  local fileLine = helper.saveLinesToArray(inputFile);

  -- Retrieve the real string only (^ = start / $ = end)
  local regexp = string.match(fileLine[1], "%^(.*)%$")

  local directions = {
    ["N"] = point.new{0, 1},
    ["S"] = point.new{0, -1},
    ["W"] = point.new{-1, 0},
    ["E"] = point.new{1, 0},
  }

  local stackCounter = stack.new{}

  local i = 1
  local nbIteration = 0
  local nbIterationMax = 50000
  local nbDoorsPassed = 0
  local currentPoint = point.new{0,0}
  while i <= #regexp and nbIteration < nbIterationMax do
    -- Retrieve the next char if the string
    local currentChar = regexp:sub(i,i)

    --print(" ============== CHAR = " .. currentChar .. ", CurrentPoint = ", point.toString(currentPoint), " ==============0 ")
    --print(" ====== Nb doors passed = ", nbDoorsPassed, " ====== ")
    --print(" ====== Nb rooms tagged = ", nbRooms, " ====== ")
    --print(" ====== Nb rooms tagged = ", nbRooms, " ====== ")

    -- ========= REGULAR DIRECTION =========
    if currentChar == "N" or currentChar == "S" or currentChar == "W" or currentChar == "E" then
      -- Update the current point
      local newPoint = point.add(currentPoint, directions[currentChar], 2)

      if not set.containsKey(visitedPoint, hashFct(currentPoint, newPoint))  then
        set.addKey(visitedPoint, hashFct(currentPoint, newPoint))
        nbDoorsPassed = nbDoorsPassed + 1

        -- Test if we need to add some rooms
        if nbDoorsPassed >= nbDoors then
          -- Add the room
          nbRooms = nbRooms + 1
          --print("New room found ! +1")
        end
      end
      -- Update the current point
      currentPoint = newPoint

    -- ========= PARENTHESIS START =========
    elseif currentChar == "(" then
      -- Push the current total to keep the old one but use this one next.
      stack.pushleft(stackCounter, {nb=nbDoorsPassed, root=point.copy(currentPoint)})
      -- Debug
      --print("Condition start save = ", nbDoorsPassed, point.toString(currentPoint))

    -- ========= CONDITION PATH =========
    elseif currentChar == "|" then
      local previousStep = stack.getleft(stackCounter)
      nbDoorsPassed = previousStep.nb
      currentPoint = previousStep.root
      if nbDoorsPassed == nil then
        nbDoorsPassed = 0
      end
      -- Debug
      --print("Condition path : Go back to the last junction")
    -- ========= PARENTHESIS ENDING =========
    elseif currentChar == ")" then
      -- Debug purpose
      --print("End of conditional path after " .. nbDoorsPassed .. " doors : continue because all conditionnal paths merged.")
      -- Reset the number of doors passed
      local previousStep = stack.popleft(stackCounter)
      nbDoorsPassed = previousStep.nb
      currentPoint = previousStep.root
    end
    i = i + 1
    nbIteration = nbIteration + 1
  end

  return nbRooms
end


--#################################################################
-- Main - Main function
--#################################################################
function day20Main (filename, nbDoors)

  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  local partOneResult = partOne(inputFile)

  -- Reset the file handle position to the beginning to use it again
  inputFile:seek("set");
  if nbDoors == nil then
    nbDoors = 1000
  end
  local partTwoResult = partTwo(inputFile, nbDoors)

  -- Finally close the file
  inputFile:close();

  print("Result part one :", partOneResult);
  print("Result part two :", partTwoResult);

  return partTwoResult
end
assert(day20Main ("Day20_A_Regular_Map/example1.txt", 1) == 3)
assert(day20Main ("Day20_A_Regular_Map/example2.txt", 5) == 11)
assert(day20Main ("Day20_A_Regular_Map/example2.txt", 10) == 1)

assert(day20Main ("Day20_A_Regular_Map/example4.txt", 5) == 31)
assert(day20Main ("Day20_A_Regular_Map/example4.txt", 10) == 25)

assert(day20Main ("Day20_A_Regular_Map/example5.txt", 10) == 39)
assert(day20Main ("Day20_A_Regular_Map/example5.txt", 20) == 28)
assert(day20Main ("Day20_A_Regular_Map/example5.txt", 25) == 20)
assert(day20Main ("Day20_A_Regular_Map/example5.txt", 30) == 7)
assert(day20Main ("Day20_A_Regular_Map/example5.txt", 35) == 0)

assert(day20Main ("Day20_A_Regular_Map/inputBis.txt", 10) == 112)
assert(day20Main ("Day20_A_Regular_Map/inputBis.txt", 50) == 47)
assert(day20Main ("Day20_A_Regular_Map/inputBis.txt", 60) == 32)

assert(day20Main ("Day20_A_Regular_Map/inputBis2.txt", 50) == 47)

assert(day20Main ("Day20_A_Regular_Map/inputBis3.txt", 1) == 236)
assert(day20Main ("Day20_A_Regular_Map/inputBis3.txt", 20) == 209)

assert(day20Main ("Day20_A_Regular_Map/inputBis4.txt", 100) == 2184)

assert(day20Main ("Day20_A_Regular_Map/input.txt", 100) == 9894)
assert(day20Main ("Day20_A_Regular_Map/input.txt", 1000) == 8366)


--#################################################################
-- Package end
--#################################################################

day20 = {
  day20Main = day20Main,
}

return day20
