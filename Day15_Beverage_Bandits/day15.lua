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
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (elfs, goblins)


  -- Game loop
  done = false
  nbTurn = 0
  while not done and nbTurn < 100000000 do



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
local function partTwo (inputFile)

  -- TODO

  return 0;
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function preProcessing(inputFile)
  local fileLines = helper.saveLinesToArray(inputFile);

  local elfs = {}
  local goblins = {}

  -- For each lines in the file
  for i = 1, #fileLines do
    
  end


  return elfs, goblins
end


--#################################################################
-- Main - Main function
--#################################################################
function day15Main (filename)
  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  elfs, goblins = preProcessing(inputFile)

  -- DEBUG HERE
  -- Elfs list should be order in the reading order !
  for i = 1,#elfs do
    print("ELFS " .. i .. ", Health = " .. elfs[i].health .. ", Attack =" .. elfs[i].attack .. ", Position = " .. point.tostring(elfs[i].position))
  end

  -- goblins list should be order in the reading order !
  for i = 1,#goblins do
    print("GOBLINS " .. i .. ", Health = " .. goblins[i].health .. ", Attack =" .. goblins[i].attack .. ", Position = " .. point.tostring(goblins[i].position))
  end

  -- Launch and print the final result
  print("Result part one :", partOne(elfs, goblins));

  -- Reset the file handle position to the beginning to use it again
  inputFile:seek("set");

  -- Launch and print the final result
  print("Result part two :", partTwo(elfs, goblins));

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
