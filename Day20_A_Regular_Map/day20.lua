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

function hashFct(point)
  return point.x .. "/" .. point.y
end

local function partTwo(inputFile, nbDoors)
  local nbRooms = 0
  local visitedPoint = Set{}

  local fileLine = helper.saveLinesToArray(inputFile);

  -- Retrieve the real string only (^ = start / $ = end)
  local regexp = string.match(fileLine[1], "%^(.*)%$")
  print("RegExp = ", regexp)

  -- Replace all Letter by the actual number of letters itself
  --local regexpNum = string.gsub(regexp, '([^(|)]*)', function(w)
  --  if w ~= "" then
  --   return string.len(w)
  --  end
  --end)

  -- Divided by 2 all the options present in empty options.
  --local regexpNum = string.gsub(regexpNum, '([%d+%|]+%|%))', function(w)
  --  if w ~= "" then
  --    print(w)
  --    return string.gsub(w, "(%d+)", function(x) return tonumber(x)/2 end)
  --    --return string.gsub(w, "(%d+)", function(x) return 0 end)
  --  end
  --end)

  local directions = {
    ["N"] = point.new{0, 1},
    ["S"] = point.new{0, -1},
    ["W"] = point.new{-1, 0},
    ["E"] = point.new{1, 0},
  }

  print(regexpNum)

  local stackCounter = stack.new{}

  local i = 1
  local nbIteration = 0
  local nbIterationMax = 10000

  local nbDoorsPassed = 0
  local initPoint = point.new{0,0 }
  local currentPoint = initPoint
  while i <= #regexp and nbIteration < nbIterationMax do
    print(" ====== CurrentPoint = ", point.toString(currentPoint), " ====== ")
    print(" ====== Nb doors passed = ", nbDoorsPassed, " ====== ")
    print(" ====== Nb rooms tagged = ", nbRooms, " ====== ")
    --print("Next path ", regexpNum:sub(i, #regexpNum))

    --local specialCharIndex = string.find(regexpNum:sub(i, #regexpNum), '[%(%|%)]')

    -- Retrieve the next char if the string
    local currentChar = regexp:sub(i,i)
    print(currentChar)

    -- ========= REGULAR DIRECTION =========
    if currentChar == "N" or currentChar == "S" or currentChar == "W" or currentChar == "E" then
      print("Go throught one more room = ", point.toString(directions[currentChar]))
      -- Update the current point
      local newPoint = point.add(currentPoint, directions[currentChar], 2)

      print("new point", point.toString(newPoint))

      print(set.containsKey(visitedPoint, newPoint, point.toString))

      if not set.containsKey(visitedPoint, newPoint, point.toString) then
        set.addKey(visitedPoint, newPoint, point.toString)
        nbDoorsPassed = nbDoorsPassed + 1

        -- Test if we need to add some rooms
        if nbDoorsPassed >= nbDoors then
          -- Add the room
          nbRooms = nbRooms + 1
          print("New room found ! +1")
        end
      end
      -- Update the current point
      currentPoint = newPoint

    -- ========= PARENTHESIS START =========
    elseif currentChar == "(" then
      -- Push the current total to keep the old one but use this one next.
      stack.pushleft(stackCounter, {nb=nbDoorsPassed, root=currentPoint})
    -- ========= CONDITION PATH =========
    elseif currentChar == "|" then
      local previousStep = stack.getleft(stackCounter)
      nbDoorsPassed = previousStep.nb
      currentPoint = previousStep.root
      if nbDoorsPassed == nil then
        nbDoorsPassed = 0
      end
      -- Debug
      print("Condition path : Go back to the last junction")
    -- ========= PARENTHESIS ENDING =========
    elseif currentChar == ")" then

      if regexp:sub(i+1,i+1) ~= "" and string.find(regexp:sub(i+1,i+1), "[%(%|%)]") ~= nil then
        print("End of conditional path after " .. nbDoorsPassed .. " doors : Go back to the last junction")
        stack.popleft(stackCounter)
        local previousStep = stack.getleft(stackCounter)
        nbDoorsPassed = previousStep.nb
        currentPoint = previousStep.root
      else
        -- If after the parentheses, there is a path following (all options converged to this final path)
        -- Debug purpose
        print("End of conditional path after " .. nbDoorsPassed .. " doors : continue because all conditionnal paths merged.")
        -- Reset the number of doors passed
        local previousStep = stack.popleft(stackCounter)
        nbDoorsPassed = previousStep.nb
        currentPoint = previousStep.root
      end
    end

    i = i + 1
    nbIteration = nbIteration + 1
  end

  print(" ====== CurrentPoint = ", point.toString(currentPoint), " ====== ")
  print(" ====== Nb doors passed = ", nbDoorsPassed, " ====== ")
  print(" ====== Nb rooms tagged = ", nbRooms, " ====== ")

  return nbRooms
end


--#################################################################
-- Main - Main function
--#################################################################
function day20Main (filename, nbDoors)

  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  --local partOneResult = partOne(inputFile)

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
--assert(day20Main ("Day20_A_Regular_Map/example1.txt", 1) == 3)
--assert(day20Main ("Day20_A_Regular_Map/example2.txt", 5) == 11)
--assert(day20Main ("Day20_A_Regular_Map/example2.txt", 10) == 1)

--day20Main ("example3.txt", 5)
--day20Main ("example3.txt", 20)

assert(day20Main ("Day20_A_Regular_Map/example4.txt", 5) == 31)
assert(day20Main ("Day20_A_Regular_Map/example4.txt", 10) == 25)

assert(day20Main ("Day20_A_Regular_Map/example5.txt", 10) == 39)
assert(day20Main ("Day20_A_Regular_Map/example5.txt", 20) == 28)
assert(day20Main ("Day20_A_Regular_Map/example5.txt", 25) == 20)
assert(day20Main ("Day20_A_Regular_Map/example5.txt", 30) == 7)
assert(day20Main ("Day20_A_Regular_Map/example5.txt", 35) == 0)

assert(day20Main ("Day20_A_Regular_Map/inputBis.txt", 50) == 62)

--assert(day20Main ("Day20_A_Regular_Map/input.txt", 50) == 9948)
assert(day20Main ("Day20_A_Regular_Map/input.txt", 1000) == 8366)


--day20Main ("example6.txt", 20)

--day20Main ("example7.txt", 15)
--day20Main ("example7.txt", 30)

--day20Main ("example8.txt", 15)
--day20Main ("example8.txt", 25)


--#################################################################
-- Package end
--#################################################################

day20 = {
  day20Main = day20Main,
}

return day20
