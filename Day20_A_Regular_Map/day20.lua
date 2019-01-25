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

  local counter = 0

  local currentIndex = 1
  local stop = false
  repeat
    -- Find the next parenthesis
    print(currentIndex)
    local nextParenthesisIndex = string.find(regexp, "%(", currentIndex)

    if nextParenthesisIndex == nil then
      counter = counter + (#regexp - (currentIndex - 1))
      stop = true
    else
      counter = counter + (nextParenthesisIndex - (currentIndex - 1))
      currentIndex = currentIndex + nextParenthesisIndex

      -- Choose the greatest number between all available options.
      --findBestOption
    end
  until stop

  print(regexp)
  return counter;
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
function day20Main (filename)

  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  local partOneResult = partOne(inputFile)

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

day20 = {
  day20Main = day20Main,
}

return day20
