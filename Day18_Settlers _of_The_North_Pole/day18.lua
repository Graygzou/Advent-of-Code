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

  matrix = ""
  for y = 1,#scan do
    for x = 1,#scan[y] do
      matrix = matrix .. scan[y][x]
    end
  end
  print(matrix)

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

        --print(xMin, xMax, yMin, yMax)

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

    --matrix = ""
    --for i = 1,#fileLines do
    --  for j = 1,#fileLines[i] do
    --    matrix = matrix .. scan[i][j]
    --  end
    --end
    --print(matrix)
    --print(currentTurn)

    --io.write('Hello, what is your name? ')
    --local name = io.read()
  until currentTurn >= nbMinutesMax

  return countAvailableResource(scan)
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
function day18Main (filename)

  --local nbMinutesMax = 10

  local nbMinutesMax = 1000000000

  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  local partOneResult = partOne(inputFile, nbMinutesMax)

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

day18 = {
  day18Main = day18Main,
}

return day18
