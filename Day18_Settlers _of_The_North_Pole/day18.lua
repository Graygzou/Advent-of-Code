--#################################################################
--# @author: Grégoire Boiron                                      #
--# @date: 10/01/2019                                             #
--#                                                               #
--# Template used for every main script for the day X of the AoC  #
--#################################################################

local P = {} -- packages

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  day18 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function printMatrix(scan)
  local matrix = ""
  for y = 1,#scan do
    for x = 1,#scan[y] do
      matrix = matrix .. scan[y][x]
    end
  end
  print(matrix)
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
local function checkRules(currentScan, currX, currY, xMin, xMax, yMin, yMax)
  local ruleOpenToTrees = false
  local ruleTreeToLumberyard = false
  local ruleRemainLumberyard = false

  local nbAdjacentTrees = 0
  local nbAdjacentLumberyard = 0

  for x = xMin, xMax do
    for y = yMin, yMax do
      if x ~= currX or y ~= currY then
        if currentScan[y][x] == "|" then
          nbAdjacentTrees =  nbAdjacentTrees + 1
        elseif currentScan[y][x] == "#" then
          nbAdjacentLumberyard = nbAdjacentLumberyard + 1
        end
      end
    end
  end

  ruleOpenToTrees = nbAdjacentTrees >= 3
  ruleTreeToLumberyard = nbAdjacentLumberyard >= 3
  ruleRemainLumberyard = nbAdjacentTrees >= 1 and nbAdjacentLumberyard >= 1

  return ruleOpenToTrees, ruleTreeToLumberyard, ruleRemainLumberyard
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
local function countAvailableResource(currentScan)
  local nbAdjacentTrees = 0
  local nbAdjacentLumberyard = 0

  for y = 1, #currentScan do
    for x = 1, #currentScan[y] do
      if currentScan[y][x] == "|" then
        nbAdjacentTrees =  nbAdjacentTrees + 1
      elseif currentScan[y][x] == "#" then
        nbAdjacentLumberyard = nbAdjacentLumberyard + 1
      end
    end
  end

  return nbAdjacentTrees * nbAdjacentLumberyard
end

------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (inputFile, nbMinutesMax)
  local fileLines = helper.saveLinesToArray(inputFile);

  local scan = {}
  for y = 1, #fileLines do
    scan[y] = {}
    for x = 1, #fileLines[y] do
      scan[y][x] = fileLines[y]:sub(x,x)
    end
  end

  --printMatrix(scan)

  currentTurn = 0
  repeat
    -- Make a copy of the current scan
    local scanCopy = {}
    for y = 1, #scan do
      scanCopy[y] = {}
      for x = 1, #scan[y] do
        scanCopy[y][x] = scan[y][x]
      end
    end

    for y = 1,#scan do
      for x = 1,#scan[y] do
        local xMin = math.max(1, tonumber(x-1))
        local xMax = math.min(#scan[y], x+1)
        local yMin = math.max(1, tonumber(y-1))
        local yMax = math.min(#scan, y+1)

        local ruleOpenToTrees, ruleTreeToLumberyard, ruleRemainLumberyard = checkRules(scanCopy, x, y, xMin, xMax, yMin, yMax)

        if scan[y][x] == "." and ruleOpenToTrees then
          scan[y][x] = "|"
        elseif scan[y][x] == "|" and ruleTreeToLumberyard then
          scan[y][x] = "#"
        elseif scan[y][x] == "#" and not ruleRemainLumberyard then
            scan[y][x] = "."
        end
      end
    end

    currentTurn = currentTurn + 1
  until currentTurn >= nbMinutesMax

  return countAvailableResource(scan)
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
local function checkRules2(currentScan, currX, currY, xMin, xMax, yMin, yMax)
  local ruleOpenToTrees = false
  local ruleTreeToLumberyard = false
  local ruleRemainLumberyard = false

  local nbAdjacentTrees = 0
  local nbAdjacentLumberyard = 0

  for x = xMin, xMax do
    for y = yMin, yMax do
      if x ~= currX or y ~= currY then
        if currentScan[y][x] == 1 then
          nbAdjacentTrees =  nbAdjacentTrees + 1
        elseif currentScan[y][x] == -1 then
          nbAdjacentLumberyard = nbAdjacentLumberyard + 1
        end
      end
    end
  end

  ruleOpenToTrees = nbAdjacentTrees >= 3
  ruleTreeToLumberyard = nbAdjacentLumberyard >= 3
  ruleRemainLumberyard = nbAdjacentTrees >= 1 and nbAdjacentLumberyard >= 1

  return ruleOpenToTrees, ruleTreeToLumberyard, ruleRemainLumberyard
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
local function countAvailableResource2(currentScan)
  local nbAdjacentTrees = 0
  local nbAdjacentLumberyard = 0

  for y = 1, #currentScan do
    for x = 1, #currentScan[y] do
      if currentScan[y][x] == 1 then
        nbAdjacentTrees =  nbAdjacentTrees + 1
      elseif currentScan[y][x] == -1 then
        nbAdjacentLumberyard = nbAdjacentLumberyard + 1
      end
    end
  end

  return nbAdjacentTrees * nbAdjacentLumberyard
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function computeSignature(scan)
  local finalSignature = ""
  for y = 1,#scan do
    local number = 0
    for x = 1,#scan[y] do
      number = number + tonumber(scan[y][x])
    end
    --print(number)
    finalSignature = finalSignature .. number
  end
  return finalSignature
end

------------------------------------------------------------------------
-- partTwo - function used for the part 2
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 2.
------------------------------------------------------------------------
local function partTwo (inputFile, nbMinutesMax)

  -- We need to generate a unique signature for every minutes in order to spot a loop and avoid computing forever.
  local signatures = Set{}
  local scores = {}

  local fileLines = helper.saveLinesToArray(inputFile);

  local scan = {}
  for y = 1, #fileLines do
    scan[y] = {}
    for x = 1, #fileLines[y] do
      local nextVal = nil
      if fileLines[y]:sub(x,x) == "." then
        scan[y][x] = 0
      elseif fileLines[y]:sub(x,x) == "#" then
        scan[y][x] = -1
      elseif fileLines[y]:sub(x,x) == "|" then
        scan[y][x] = 1
      end
    end
  end

  local found = false
  local currentTurn = 0
  local startNumberLoop = nil
  local loopNumber = nil

  repeat
    -- Make a copy of the current scan
    local scanCopy = {}
    for y = 1, #scan do
      scanCopy[y] = {}
      for x = 1, #scan[y] do
        scanCopy[y][x] = scan[y][x]
      end
    end

    -- Add the key
    local currentSignature = computeSignature(scan)
    if not set.containsKey(signatures, currentSignature) then
      for y = 1,#scan do
        for x = 1,#scan[y] do
          local xMin = math.max(1, tonumber(x-1))
          local xMax = math.min(#scan[y], x+1)
          local yMin = math.max(1, tonumber(y-1))
          local yMax = math.min(#scan, y+1)

          local ruleOpenToTrees, ruleTreeToLumberyard, ruleRemainLumberyard = checkRules2(scanCopy, x, y, xMin, xMax, yMin, yMax)

          if scan[y][x] == 0 and ruleOpenToTrees then
            scan[y][x] = 1
          elseif scan[y][x] == 1 and ruleTreeToLumberyard then
            scan[y][x] = -1
          elseif scan[y][x] == -1 and not ruleRemainLumberyard then
              scan[y][x] = 0
          end
        end
      end
      addKey(signatures, currentSignature, currentTurn)
      table.insert(scores, countAvailableResource2(scan))

      currentTurn = currentTurn + 1
    else
      startNumberLoop = signatures[currentSignature].value
      loopNumber = currentTurn - startNumberLoop;
      found = true
    end
  until currentTurn >= nbMinutesMax or found

  local rangeLeft = nbMinutesMax - currentTurn
  local numberOfFitInt = rangeLeft // loopNumber
  local numberOfFitRest = rangeLeft -  (loopNumber * numberOfFitInt)

  return scores[startNumberLoop + numberOfFitRest]
end


--#################################################################
-- Main - Main function
--#################################################################
function day18Main (filename)

  --local nbMinutesMax = 10

  --local nbMinutesMax = 1000000000

  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  local partOneResult = partOne(inputFile, 10)

  -- Reset the file handle position to the beginning to use it again
  inputFile:seek("set");

  local partTwoResult = partTwo(inputFile, 1000000000)

  -- Finally close the file
  inputFile:close();

  print("Result part one :", partOneResult);
  print("Result part two :", partTwoResult);

end

--#################################################################
-- Package end
--#################################################################

day18 = {
  day18Main = day18Main,
}

return day18
