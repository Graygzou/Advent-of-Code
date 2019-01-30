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


local function partTwo(inputFile)
  local nbDoors = 1000
  --local nbDoors = 15
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

  -- Divided by 2 all the options present in empty options.
  local regexpNum = string.gsub(regexpNum, '([%d+%|]+%|%))', function(w)
    if w ~= "" then
      print(w)
      return string.gsub(w, "(%d+)", function(x) return tonumber(x)/2 end)
    end
  end)

  print(regexpNum)

  local stackCounter = stack.new{}

  local i = 1
  local nbIteration = 0
  local nbIterationMax = 10000

  local nbDoorsPassed = 0
  while i <= #regexpNum and nbIteration < nbIterationMax do
    print(" ====== Nb doors passed = ", nbDoorsPassed, " ====== ")
    print(" ====== Nb rooms tagged = ", nbRooms, " ====== ")
    print("Next path ", regexpNum:sub(i, #regexpNum))

    local specialCharIndex = string.find(regexpNum:sub(i, #regexpNum), '[%(%|%)]')
    if specialCharIndex ~= nil then
      local specialChar = regexpNum:sub(i-1 + specialCharIndex, i-1 + specialCharIndex)

      -- Test if we need to add some rooms
      if tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1)) ~= nil then
        local nbNextDoors = tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1))
        if nbDoorsPassed > nbDoors then
          -- Add the room
          nbRooms = nbRooms + nbNextDoors

          print("New rooms found : ", tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1)))
        elseif nbDoorsPassed + nbNextDoors >= nbDoors then
          local foundRooms = (nbDoorsPassed + nbNextDoors) - (nbDoors)
          nbRooms = nbRooms + foundRooms
          -- Debug
          print("Start reaching finals rooms : ", foundRooms)
        end
      end

      if specialChar == "(" then
        -- Push the current total to keep the old one but use this one next.
        if tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1)) ~= nil then
          nbDoorsPassed = nbDoorsPassed + tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1))
        end

        stack.pushleft(stackCounter, nbDoorsPassed)
        print("Fast-forward and go throught " .. regexpNum:sub(i, i-1 + specialCharIndex-1) .. " more door(s) !")
      elseif specialChar == "|" then
        nbDoorsPassed = stack.getleft(stackCounter)
        print(nbDoorsPassed)

        --if regexpNum:sub(i+1, i+1 + specialCharIndex-1) == '|)' then
          --print("Empty option after " .. nbDoorsPassed + tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1)) .. " doors : Go back to the last junction")
          --i = i + 1

          --nbDoorsPassed stack.popleft(stackCounter)
          --nbDoorsPassed = stack.getleft(stackCounter)
        --else
          if tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1)) ~= nil then
            print("Condition path after " .. nbDoorsPassed + tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1)) .. " doors : Go back to the last junction to explore other paths.")
          else
            print("Condition path after " .. nbDoorsPassed .. " doors : Go back to the last junction")
          end
        --end

        -- Debug
        --print("Reset old total", nbDoorsPassed)
        --print(regexpNum:sub(i, i-1 + specialCharIndex-1))
      elseif specialChar == ")" then
        --print(tonumber(regexpNum:sub(i, i-1 + specialCharIndex-1)))
        --if regexpNum:sub(i-1, i-1 + specialCharIndex-1) == '|' then
          -- too care of it earlier
        --else
        --print(regexpNum:sub(i+1, i+1 + specialCharIndex-1))
        --print("ICI", string.find(regexpNum:sub(i+1, i+1 + specialCharIndex-1), "^[(|)]")

        print(regexpNum:sub(i + specialCharIndex, i + specialCharIndex))
        print("ICI", string.find(regexpNum:sub(i + specialCharIndex, i + specialCharIndex), "^[%d]"))

        -- If after the parenthises, their is a path following (all options converged to this final path)
        if regexpNum:sub(i + specialCharIndex, i + specialCharIndex) ~= "" and string.find(regexpNum:sub(i + specialCharIndex, i + specialCharIndex), "^[%d]") ~= nil then
          -- Update the currentTotal with the number
          -- Note: all options should have the same length here !
          --print("here")
          --if tonumber(regexpNum:sub(i+1, i+1 + specialCharIndex-1)) ~= nil then
          --  print("Fast-forward and go throught " .. regexpNum:sub(i+1, i+1 + specialCharIndex-1) .. " more door(s) !")
          --  nbDoorsPassed = nbDoorsPassed + tonumber(regexpNum:sub(i+1, i+1 + specialCharIndex-1))

          --  print("End of conditional path after " .. nbDoorsPassed .. " doors : Go back to the last junction")
          --end

          -- Debug purpose
          local nextSpecialCharIndex = string.find(regexpNum:sub(i+specialCharIndex, #regexpNum), '[(|)]')
          if nextSpecialCharIndex ~= nil then
            print("End of conditional path after " .. nbDoorsPassed .. " doors : continue because both path merged into " .. tonumber(regexpNum:sub(i + specialCharIndex, i + specialCharIndex + nextSpecialCharIndex-2)) .. " doors.")
          else
            print("End of conditional path after " .. nbDoorsPassed .. " doors : continue because both path merged into " ..  tonumber(regexpNum:sub(i + specialCharIndex, #regexpNum)))
          end
          nbDoorsPassed = stack.popleft(stackCounter)
        else
          -- Note: options can have different length
          -- Retrieve the old total to continue with the
          --if tonumber(regexpNum:sub(i, i-1 + nextSpecialCharIndex-1)) ~= nil then
          --  print("End of conditional path after " .. nbDoorsPassed + tonumber(regexpNum:sub(i, i-1 + nextSpecialCharIndex)) .. " doors : Go back to the last junction")
          --else
          print("End of conditional path after " .. nbDoorsPassed .. " doors : Go back to the last junction")
          --end
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

      local nbNextDoors = tonumber(regexpNum:sub(i, #regexpNum))
      -- Test if we need to add some rooms
      if nbDoorsPassed > nbDoors then
        -- Add the room
        nbRooms = nbRooms + nbNextDoors

        print("New rooms found : ", tonumber(regexpNum:sub(i, #regexpNum)))
      elseif nbDoorsPassed + nbNextDoors >= nbDoors then
        local foundRooms = (nbDoorsPassed + nbNextDoors) - (nbDoors)
        nbRooms = nbRooms + foundRooms

        print("Start reaching finals rooms : ", nbDoorsPassed + foundRooms)
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
