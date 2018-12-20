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
  day14 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

function initCellList(initialList)
  local endingCellRef = nil
  local cells = nil

  -- TODO

  return cells, endingCellRef
end


------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - input : int, number of recipes we have to generate before computing the 10 last recipes.
--    - nbElfs : int, number of elfs who participate to the process
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (input, nbElfs)
  local endingCellRef = nil
  local cells = nil
  local elfs = nil

  -- Create a circular linked list to make easier the loop between the last and the first cell.
  -- The endingCellRef is here to allow adding more recipes.
  cells, endingCellRef = initCellList({3, 7, 1, 0})

  -- An elf only require the cell to compute everything
  -- (can get the previous score and know the index he's on)
  for i = 1,nbElfs do
    table.insert(elfs, {currentCell = cells[i]})
  end

  local computedRecipes = 4
  while computedRecipes < (input) + 10 do

    -- TODO : compute all the recipes

  end

  -- TODO : Find the last 10 digits

  return 0;
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
function day14Main (filename)
  local puzzleInput = 074501
  local nbElfs = 2

  -- Launch and print the final result
  print("Result part one :", partOne(puzzleInput, nbElfs));

  -- Launch and print the final result
  print("Result part two :", partTwo(puzzleInput));

end

--#################################################################
-- Package end
--#################################################################

day14 = {
  day14Main = day14Main,
}

return day14
