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
  Day11 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

------------------------------------------------------------------------
-- computePowerCell
------------------------------------------------------------------------
function computePowerCell(x, y, serialNumber)
  local rackID = x + 10
  return ((((rackID * y + serialNumber) * rackID) // 100) % 10) - 5
end
------------------------------------------------------------------------
-- Tests
------------------------------------------------------------------------
print("Tests computePowerCell function :")
print(computePowerCell(3, 5, 8) == 4)
print(computePowerCell(122, 79, 57) == -5)
print(computePowerCell(217, 196, 39) == 0)
print(computePowerCell(101, 153, 71) == 4)


------------------------------------------------------------------------
-- computeTotalPowerCell
------------------------------------------------------------------------
function computeTotalPowerCell(lookupTable, sizeX, sizeY, i, j, serialNumber)
  local currrentTotalPowerCell = 0

  -- Compute the current total power cell
  for zoneI = 1, sizeX do
    for zoneJ = 1, sizeY do
      -- Check if the value has been already computed
      local powerCell = 0

      if lookupTable[j + (zoneJ - 1)][i + (zoneI - 1)] == "" then

        -- Compute the value for the currentCell
        powerCell = computePowerCell(i + (zoneI-1), j + (zoneJ-1), serialNumber)

        -- Store it in the lookup table (memoization)
        lookupTable[j + (zoneJ - 1)][i + (zoneI - 1)] = powerCell

        currrentTotalPowerCell = currrentTotalPowerCell + powerCell
      else
        -- Retrieve it and add it to the current total
        powerCell = lookupTable[j + (zoneJ-1)][i + (zoneI - 1)]
      end
      -- Update the total power
      currrentTotalPowerCell = currrentTotalPowerCell + powerCell
    end
  end

  return currrentTotalPowerCell
end
------------------------------------------------------------------------
-- Tests
------------------------------------------------------------------------
print("Tests computeTotalPowerCell function :")
-- Init the lookup table
lookupTable = {}
for j = 1,303 do
  lookupTable[j] = {}
  for i = 1,303 do
    lookupTable[j][i] = ""
  end
end
print(computeTotalPowerCell(lookupTable, 3, 3, 33, 45, 18) == 29)
print(computeTotalPowerCell(lookupTable, 3, 3, 21, 61, 42) == 30)

------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (serialNumber)
  -- Will use the memoization principe to speed up the process
  local maxX = 300
  local maxY = 300

  local FinalTotalPowerCell = 0
  local FinalXCoord = 0
  local FinalYCoord = 0
  local FinalSize = 0

  -- Init the lookup table
  local lookupTable = {}
  for j = 1,maxY do
    lookupTable[j] = {}
    for i = 1,maxX do
      lookupTable[j][i] = ""
    end
  end

  -- Foreach possible total power cell.
  size = 3
  for i = 1,maxX-size do
    for j = 1,maxY-size do
      -- Compute the total power of the size x size Grid
      local currrentTotalPowerCell = computeTotalPowerCell(lookupTable, size, size, i, j, serialNumber)

      if FinalTotalPowerCell < currrentTotalPowerCell then
        FinalTotalPowerCell = currrentTotalPowerCell
        FinalXCoord = i
        FinalYCoord = j
        FinalSize = size
      end
    end
  end

  print("Final (X,Y) = (" .. FinalXCoord .. "," .. FinalYCoord .. "," .. FinalSize ..  ")")

  return FinalTotalPowerCell
end

------------------------------------------------------------------------
-- partTwo - function used for the part 2
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 2.
------------------------------------------------------------------------
local function partTwo (serialNumber)
  -- Will use the memoization principe to speed up the process
  local maxX = 300
  local maxY = 300

  local FinalTotalPowerCell = 0
  local FinalXCoord = 0
  local FinalYCoord = 0
  local FinalSize = 0

  -- Init the lookup table
  local lookupTable = {}
  for j = 1,maxY do
    lookupTable[j] = {}
    for i = 1,maxX do
      lookupTable[j][i] = ""
    end
  end

  --------------------
  -- A possible solution to speed up the process can be to use another lookup table to register using the memoization current total power size
  -- It will allow to only add to this result right side and bottom side. It will use bigger Memory space but less GPU.
  --------------------

  -- For any size of square
  for size=1,300 do
    -- Foreach possible total power cell.
    for i = 1,maxX-size do
      for j = 1,maxY-size do
        -- Compute the total power of the size x size Grid
        local currrentTotalPowerCell = computeTotalPowerCell(lookupTable, size, size, i, j, serialNumber)

        if FinalTotalPowerCell < currrentTotalPowerCell then
          FinalTotalPowerCell = currrentTotalPowerCell
          FinalXCoord = i
          FinalYCoord = j
          FinalSize = size
        end
      end
    end
    print("Final (X,Y) = (" .. FinalXCoord .. "," .. FinalYCoord .. "," .. FinalSize ..  ") value = " .. FinalTotalPowerCell)
  end

  print("Final (X,Y) = (" .. FinalXCoord .. "," .. FinalYCoord .. "," .. FinalSize ..  ")")

  return FinalTotalPowerCell
end


--#################################################################
-- Main - Main function
--#################################################################
function day11Main (filename)
  -- Read the input file and put it in a file handle

  local serialNumber = 2568

  -- Launch and print the final result
  print("Result part one :", partOne(serialNumber));

  -- Reset the file handle position to the beginning to use it again
  --inputFile:seek("set");

  -- Launch and print the final result
  print("Result part two :", partTwo(serialNumber));

end

--#################################################################
-- Package end
--#################################################################

day11 = {
  day11Main = day11Main,
}

return day11
