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

------------------------------------------------------------------------
-- partTwo - function used for the part 2
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 2.
------------------------------------------------------------------------
local function partTwo (inputFile)
  local nbDoors = 14

  local fileLine = helper.saveLinesToArray(inputFile);

  -- Retrieve the real string only (^ = start / $ = end)
  local regexp = string.match(fileLine[1], "%^(.*)%$")
  print("RegExp = ", regexp)

  local selection = string.match(regexp, '%([^()]*%)')
  print("Test v2", selection)

  local currentIteration = 0
  local nbIterationMax = 10
  while selection ~= nil and currentIteration < nbIterationMax do
    -- Find the previous selection in the string
    local replacementIndexStart, replacementIndexEnd = string.find(regexp, '%(' .. selection .. '%)')

    local beforeSelection = string.match(regexp:sub(1, replacementIndexStart-1), '[^|()][A-Z]*$')
    print(beforeSelection)

    local afterSelection = string.match(regexp:sub(replacementIndexEnd+1, #regexp), '^[A-Z]*[^|()]')
    print(afterSelection)


    -- Parse it and choose the greatest option
    local newOptions = ""
    if string.match(selection, '|%)') == nil then
      -- For each possible option (token)
      for token in string.gmatch(selection, "[^(|)]+") do
        -- Replace it and add it to the path array.
        if beforeSelection ~= nil then
          newOptions = newOptions .. beforeSelection
        end
        newOptions = newOptions .. token
        if afterSelection ~= nil then
          newOptions = newOptions .. afterSelection
        end
        newOptions = newOptions .. "|"
      end
      -- Remove the last '|'
      newOptions = newOptions:sub(1,#newOptions-1)
      print(newOptions)
    end

    -- Replace it.
    regexp = regexp:sub(1, replacementIndexStart-1) .. newOptions .. regexp:sub(replacementIndexEnd+1, #regexp)

    -- New selection
    selection = string.match(regexp, '%([^()]*%)')
    print("Test v2", selection)

    currentIteration = currentIteration + 1
  end

  print("FINAL", regexp)

  local nbRooms = 0
  for possiblePath in string.gmatch(regexp, "[^(|)]+") do
    if #possiblePath >= nbDoors then
      nbRooms = nbRooms + 1
    end
  end

  return nbRooms
end


--#################################################################
-- Main - Main function
--#################################################################
function day20Main (filename)

  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  --local partOneResult = partOne(inputFile)

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
