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
  day12 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function addMissingDots(string)
  -- Add beginning dots if needed
  if string.sub(string,1,1) == "#" or string.sub(string,2,2) == "#" then
    string = ".." .. string
  end

  -- Add ending dots if needed
  if string.sub(string,#string,#string) == "#" or string.sub(string,#string-1,#string-1) == "#" then
    string = string .. ".."
  end

  return string
end

------------------------------------------------------------------------
--
-- Post-condition : Both strings should be the same length.
------------------------------------------------------------------------
function mergeString (string1, string2)
  if string1 == nil then
    return string2
  end
  if string2 == nil then
    return string1
  end
  local finalString = ""
  -- Both string should be the same length
  for i=1,#string1 do
    finalString = finalString .. string.char(math.min(string.byte(string.sub(string1,i,i)), string.byte(string.sub(string2,i,i))))
  end
  return finalString
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function applyAllRules(state, rules)
  local finalState = state
  print(state)
  for i = 1,#rules do
    local match = false
    print("CURRENT RULE : " .. rules[i].pattern .. " =>" .. rules[i].replace)

    local tempState = string.gsub(state, rules[i].pattern, function(string)
      match = true
      --print("MATCH : " .. string ..  " =>" .. string.sub(string,1,2) .. rules[i].replace .. string.sub(string,4,5))
      print("MATCH : " .. string ..  " =>" .. ".." .. rules[i].replace .. "..")
      return string.sub(string,1,2) .. rules[i].replace .. string.sub(string,4,5)
    end)

    if match then
      finalState = tempState -- mergeString(finalState, tempState)
    end
    print(match)
    print(finalState)
  end
  return finalState
end

------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (inputFile)

  local fileLines = helper.saveLinesToArray(inputFile);

  -- Retrieve the initial state
  local initialState = helper.splitString(fileLines[1], {"a-z", ": ","\n"})[1]
  initialState = addMissingDots(initialState)

  print(initialState)

  -- Retrieve all the rules
  local rules = {}
  local index = 1
  for i = 3,#fileLines do
    local currentRules = helper.splitString(fileLines[i], {" => "})
    rules[index] = {pattern=string.gsub(currentRules[1],"%.","%%."), replace=(string.gsub(currentRules[2],"\n",""))}

    print(rules[index].pattern .. "," .. rules[index].replace)

    index = index + 1
  end

  local nbGeneration = 1
  local currentState = initialState
  for i = 1, nbGeneration do
    --Apply all the rules where it can be on the current state
    currentState = applyAllRules(currentState, rules)
    print(currentState)
  end

  return currentState;
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
function day12Main (filename)
  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  -- Launch and print the final result
  print("Result part one :", partOne(inputFile));

  -- Reset the file handle position to the beginning to use it again
  inputFile:seek("set");

  -- Launch and print the final result
  print("Result part two :", partTwo(inputFile));

  -- Finally close the file
  inputFile:close();
end

--#################################################################
-- Package end
--#################################################################

day12 = {
  day12Main = day12Main,
}

return day12
