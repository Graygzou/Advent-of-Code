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
  local nbDoors = 5
  local nbRooms = 0

  local fileLine = helper.saveLinesToArray(inputFile);

  -- Retrieve the real string only (^ = start / $ = end)
  local regexp = string.match(fileLine[1], "%^(.*)%$")
  print("RegExp = ", regexp)

  local selection = string.match(regexp, '%([^()]*%)')
  print("Test v2", selection)

  local currentIteration = 0
  local nbIterationMax = 5000
  while selection ~= nil and currentIteration < nbIterationMax do
    -- Find the previous selection in the string
    local replacementIndexStart, replacementIndexEnd = string.find(regexp, '%(' .. selection .. '%)')

    beforeSelection = string.match(regexp:sub(1, replacementIndexStart-1), '[^|()][A-Z]*$')
    if beforeSelection == nil then
      beforeSelection = ""
    end
    --print(beforeSelection)

    afterSelection = string.match(regexp:sub(replacementIndexEnd+1, #regexp), '^[A-Z]*[^|()]')
    if afterSelection == nil then
      afterSelection = ""
    end
    --print(afterSelection)

    -- Parse it and choose the greatest option
    local newOptions = ""
    if string.match(selection, '|%)') == nil then
      -- For each possible option (token)
      --for token in string.gmatch(selection, "[^(|)]+") do
        --if #token >= nbDoors then
        --  print(token)
         -- nbRooms = nbRooms + 1
        --else
          -- Replace it and add it to the path array.
      --    newOptions = newOptions .. beforeSelection .. token .. afterSelection .. "|"
        --end
      --end
      print(string.gsub(selection, "([^%(%|%)]+)", function(w) return beforeSelection .. w .. afterSelection end))
      newOptions = newOptions .. string.gsub(selection, "([^%(%|%)]+)", function(w) return beforeSelection .. w .. afterSelection end)
      -- Remove the last '|'
      --newOptions = newOptions:sub(1,#newOptions-1)
    else
      newOptions = newOptions .. beforeSelection .. afterSelection
    end
    print("FINAL RESULT", newOptions)

    -- Replace it.
    regexp = regexp:sub(1, replacementIndexStart - #beforeSelection - 1) .. newOptions .. regexp:sub(replacementIndexEnd + #afterSelection + 1, #regexp)

    -- New selection
    selection = string.match(regexp, '%([^()]*%)')
    --print("Test v2", selection)

    currentIteration = currentIteration + 1
    print("Iteration n°" .. currentIteration)
  end

  print("FINAL", nbRooms, regexp)

  for possiblePath in string.gmatch(regexp, "[^(|)]+") do
    if #possiblePath >= nbDoors then
      nbRooms = nbRooms + 1
    end
  end

  return nbRooms
end

------------------------------------------------------------------------
local function partTwoddd (inputFile)
  local nbDoors = 1000
  local nbRooms = 0

  local fileLine = helper.saveLinesToArray(inputFile);

  -- Retrieve the real string only (^ = start / $ = end)
  local regexp = string.match(fileLine[1], "%^(.*)%$")
  local newRegexp = regexp
  print("RegExp = ", regexp)

  local currentIteration = 0
  local nbIterationMax = 2000
  repeat
    regexp = newRegexp

    newRegexp = string.gsub(regexp, '([A-Z]*)(%([^()]*%))([A-Z]*)', function(a, b, c)
      local string = ""
      if string.match(b, '|%)') == nil then
        for token in string.gmatch(b, "[^(|)]+") do
          string = string .. a .. token .. c .. '|'
        end
        string = string:sub(1, #string-1)
      else
        string = a .. c
      end
      return string
    end)
    currentIteration = currentIteration + 1

    print(currentIteration)
    --print(newRegexp)
  until currentIteration > nbIterationMax or regexp == newRegexp

  --print("FINAL", nbRooms, regexp)

  local paths = {}

  for possiblePath in string.gmatch(regexp, "[^(|)]+") do
    -- Check if the path is legit
    if #possiblePath >= nbDoors then
      -- Add the path
      table.insert(paths, possiblePath:sub(1000, #possiblePath))
      --print(possiblePath:sub(1000, #possiblePath))
    end
  end

  print("post-processing")

  -- Find unique rooms from the list
  while #paths > 0 do
    local i = 1
    local currentChar = nil
    repeat
      currentChar = paths[i]:sub(1,1)
      i = i + 1
    until currentChar == nil or i >= #paths

    print("Debug", currentChar, paths[i-1])

    -- Count the current room of the first path
    nbRooms = nbRooms + 1

    -- Remove that character from all the path (including the current one)
    for j = 1, #paths do
      -- Remove empty path from the list
      if paths[j] ~= nil then
        if #paths[j] <= 0 then
          table.remove(paths, j)
        elseif paths[j]:sub(1,1) == currentChar then
          paths[j] = paths[j]:sub(2, #paths[j])
        end
      end
    end
  end

  return nbRooms
end

local function partTwoFinal(inputFile)
  --local nbDoors = 25
  local nbDoors = 1000
  local nbRooms = 0

  local fileLine = helper.saveLinesToArray(inputFile);

  -- Retrieve the real string only (^ = start / $ = end)
  local regexp = string.match(fileLine[1], "%^(.*)%$")
  print("RegExp = ", regexp)

  -- Replace all Letter by the actual number of letters itself
  local regexpNum = string.gsub(regexp, '([^(|)]*)', function(w)
    if w ~= "" then
      return string.len(w)
    end
  end)

  print(regexpNum)

  local stackCounter = stack.new{}

  local i = 1
  local nbIteration = 0
  local nbIterationMax = 10000

  local nbDoorsPassed = 0
  while i <= #regexpNum and nbIteration < nbIterationMax do
    print("Next path ", regexpNum:sub(i, #regexpNum))

    local specialCharIndex = string.find(regexpNum:sub(i, #regexpNum), '[%(%|%)]')
    if specialCharIndex ~= nil then
      local specialChar = regexpNum:sub(i-1 + specialCharIndex, i-1 + specialCharIndex)
      print(" ====== Nb doors passed = ", nbDoorsPassed, " ====== ")

      -- Test if we need to add some rooms
      if tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1)) ~= nil then
        if nbDoorsPassed > nbDoors then
          -- Add the room
          nbRooms = nbRooms + tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1))

          print("New rooms found : ", tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1)))
        elseif nbDoorsPassed + tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1)) > nbDoors then
          nbRooms = nbRooms + (nbDoorsPassed + tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1))) - nbDoors
          -- Debug
          print("Start reaching finals rooms : ", (nbDoorsPassed + tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1))) - nbDoors)
        end
      end

      if specialChar == "(" then
        -- Push the current total to keep the old one but use this one next.
        if tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1)) ~= nil then
          nbDoorsPassed = nbDoorsPassed + tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1))
          stack.pushleft(stackCounter, nbDoorsPassed)

          print("Fast-forward and go throught " .. regexpNum:sub(i, i-1 + specialCharIndex-1) .. " more door(s) !")
        end
      elseif specialChar == "|" then
        nbDoorsPassed = stack.getleft(stackCounter)

        if regexpNum:sub(i+1, i+1 + specialCharIndex-1) == '|)' then
          print("Empty option after " .. nbDoorsPassed + tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1)) .. " doors : Go back to the last junction")
          i = i + 1
        else
          if tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1)) ~= nil then
            print("Condition path after " .. nbDoorsPassed + tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1)) .. " doors : Go back to the last junction to explore other paths.")
          else
            print("Condition path after " .. nbDoorsPassed .. " doors : Go back to the last junction")
          end
        end

        -- Debug
        --print("Reset old total", nbDoorsPassed)
        --print(regexpNum:sub(i, i-1 + specialCharIndex-1))
      elseif specialChar == ")" then
        --print(tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1)))
        --if regexpNum:sub(i-1, i-1 + specialCharIndex-1) == '|' then
          -- too care of it earlier
        --else
        --print(regexpNum:sub(i+2, i+1 + specialCharIndex-1))
        --print("ICI", string.find(regexpNum:sub(i+2, i+1 + specialCharIndex-1), "[(|)]"))
        if string.find(regexpNum:sub(i+2, i+1 + specialCharIndex-1), "[(|)]") == nil then
          -- Update the currentTotal with the number
          -- Note: all options should have the same length here !
          --print("here")
          --if tonumber(regexpNum:sub(i+1, i+1 + specialCharIndex-1)) ~= nil then
          --  print("Fast-forward and go throught " .. regexpNum:sub(i+1, i+1 + specialCharIndex-1) .. " more door(s) !")
          --  nbDoorsPassed = nbDoorsPassed + tonumber(regexpNum:sub(i+1, i+1 + specialCharIndex-1))

          --  print("End of conditional path after " .. nbDoorsPassed .. " doors : Go back to the last junction")
          --end
          nbDoorsPassed = stack.popleft(stackCounter)
        else
          -- Note: options can have different length
          -- Retrieve the old total to continue with the
          print("End of conditional path after " .. nbDoorsPassed .. " doors : Go back to the last junction")
          stack.popleft(stackCounter)
          nbDoorsPassed = stack.getleft(stackCounter)
        end
        --end
      end

      i = i + specialCharIndex
    else
      -- End : just add to the final rooms if possible
      --if currentTotal + tonumber(regexpNum:sub(i, #regexpNum)) > nbDoors then
      --  nbRooms = nbRooms + (currentTotal + tonumber(regexpNum:sub(i, #regexpNum))) - nbDoors
        -- Debug
      --  print("Add : ", (currentTotal + tonumber(regexpNum:sub(i, #regexpNum))) - nbDoors)
      --end

      -- Test if we need to add some rooms
      if nbDoorsPassed > nbDoors then
        -- Add the room
        nbRooms = nbRooms + tonumber(regexpNum:sub(i, #regexpNum))

        print("New rooms found : ", tonumber(regexpNum:sub(i, #regexpNum)))
      elseif nbDoorsPassed + tonumber(regexpNum:sub(i, #regexpNum)) > nbDoors then
        nbRooms = nbRooms + (nbDoorsPassed + tonumber(regexpNum:sub(i, #regexpNum))) - nbDoors

        print("Start reaching finals rooms : ", (nbDoorsPassed + tonumber(regexpNum:sub(i, #regexpNum))) - nbDoors)
      end

      -- Update for the last time the current total
      print("END = ", tonumber(regexpNum:sub(i, #regexpNum)))
      nbDoorsPassed = nbDoorsPassed + tonumber(regexpNum:sub(i, #regexpNum))

      i = i + 1
    end

    --print("I", i)
    --print("======= Current total", nbDoorsPassed)

    nbIteration = nbIteration + 1
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

  local partTwoResult = partTwoFinal(inputFile)

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
