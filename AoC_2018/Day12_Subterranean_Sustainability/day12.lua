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
-- Add 4 dots if needed (Just to be sure everything works correctly)
------------------------------------------------------------------------
function addMissingDots(state, potsStartNum)

  -- Add beginning dots if needed
  if string.find(string.sub(state, 1, 5), "#") ~= nil then
    state = "...." .. state
    potsStartNum = potsStartNum - 4
  end

  -- Add ending dots if needed
  if string.find(string.sub(state, #state-4, #state), "#") ~= nil then
    state = state .. "...."
  end

  return state, potsStartNum
end

------------------------------------------------------------------------
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
function sanitizedState (state, potsStartNum)
  state = string.gsub(string.gsub(string.gsub(state, '#', '.'), '!', '#'), ',', '.')
  state, potsStartNum = addMissingDots(state, potsStartNum)

  return state, potsStartNum
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function applyAllRules(state, rules, potsStartNum)
  local finalState = nil
  for i = 1,#rules do
    local match = false
    tempState, nbMatch = helper.findAndReplaceString(state, rules[i].pattern, 5, rules[i].replace)
    if nbMatch > 0 then
      finalState = mergeString(finalState, tempState)
    end
  end
  finalState, potsStartNum = sanitizedState(finalState, potsStartNum)
  return finalState, potsStartNum
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function computePart2Result(nbPots, currentIteration, finalIteration, scoreCurrentIteration, valueFirstPot)
  print("nbPots : ", nbPots)
  print("currentIteration : ", currentIteration)
  print("finalIteration : ", finalIteration)
  print("scoreCurrentIteration : ", scoreCurrentIteration)
  print("valueFirstPot : ", valueFirstPot)

  addedSpace = finalIteration - currentIteration  -- correspond to the missing space the finalIteration will generate

  print("addedSpace", addedSpace)

  return scoreCurrentIteration + (nbPots * addedSpace)
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function countPotsNum(currentState, potsStartNum, LASTFIRSTPOTNUM)
  local totalNum = 0
  local first = true
  local counter = potsStartNum
  local nbPots = 0
  local valueFirstPot = 0

  for i=1,#currentState do
    if currentState:sub(i,i) == "#" then
      if first then
        first = false
        valueFirstPot = counter
        print("INDEX : ", valueFirstPot)
        if LASTFIRSTPOTNUM + 1 ~= counter then
          print("WRONG")
          LASTFIRSTPOTNUM = counter
        else
          LASTFIRSTPOTNUM = LASTFIRSTPOTNUM + 1
        end
      end
      nbPots = nbPots + 1
      totalNum = totalNum + counter
    end
    counter = counter + 1
  end

  print("FINAL PART 2 :",computePart2Result(nbPots, 1000, 50000000000, totalNum, valueFirstPot))

  print("NB POTS", nbPots)

  return totalNum, LASTFIRSTPOTNUM
end

------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (inputFile)
  local potsStartNum = 0

  local fileLines = helper.saveLinesToArray(inputFile);

  -- Retrieve the initial state
  local initialState = helper.splitString(fileLines[1], {"a-z", ": ","\n"})[1]
  initialState, potsStartNum = addMissingDots(initialState, potsStartNum)

  print(initialState)

  -- Retrieve all the rules
  local rules = {}
  local index = 1
  for i = 3,#fileLines do
    local currentRules = helper.splitString(fileLines[i], {" => "})
    rules[index] = {pattern=string.gsub(currentRules[1],"%.","%%."), replace=(string.gsub(currentRules[2],"\n",""))}

    --print(rules[index].pattern .. "," .. rules[index].replace)

    index = index + 1
  end

  local LASTFIRSTPOTNUM = 0

  local nbGeneration = 1000
  local currentState = initialState
  for i = 1, nbGeneration do
    print(i)
    --Apply all the rules where it can be on the current state
    currentState, potsStartNum = applyAllRules(currentState, rules, potsStartNum)
    print(currentState)

    --LASTFIRSTPOTNUM = select(2, countPotsNum(currentState, potsStartNum, LASTFIRSTPOTNUM))
  end

  print("FINAL POT NUM : ", potsStartNum)

  local finalRes = countPotsNum(currentState, potsStartNum, LASTFIRSTPOTNUM)

  return finalRes;
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
