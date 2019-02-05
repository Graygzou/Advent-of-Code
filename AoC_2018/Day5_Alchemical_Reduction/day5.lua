--#################################################################
--# @author: Grégoire Boiron                                      #
--# @date: 12/08/2018                                             #
--#                                                               #
--# Template used for every main script for the day 5 of the AoC  #
--#################################################################

local P = {} -- packages

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  day5 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - polymer : string, current polymer that we need to divide and merge back.
-- Return
--    the polymer with all the possible reactions done.
------------------------------------------------------------------------
function DivideAndConquer (polymer)
  local currentFinalPolymer = "";

  if (#polymer > 1) then
    -- Divided step
    local halfPolymer = math.floor(#polymer/2)

    --print(polymer .. " => DIVIDE")
    local leftPolymer = DivideAndConquer(string.sub(polymer, 1, halfPolymer))
    local rightPolymer = DivideAndConquer(string.sub(polymer, halfPolymer+1, #polymer))

    -- Can start comparing here
    --print("MERGE")
    while ((string.byte(string.sub(leftPolymer,#leftPolymer,#leftPolymer)) ~= string.byte(string.sub(rightPolymer, 1, 1))) and
      (string.byte(string.upper(string.sub(leftPolymer,#leftPolymer,#leftPolymer))) == string.byte(string.sub(rightPolymer, 1, 1)) or
      string.byte(string.sub(leftPolymer,#leftPolymer,#leftPolymer)) == string.byte(string.upper(string.sub(rightPolymer, 1, 1))))) do
      --print(string.sub(leftPolymer,#leftPolymer,#leftPolymer) .. "+" .. string.sub(rightPolymer, 1, 1) .. "=> REACT")
      -- REACT together !
      leftPolymer = string.sub(leftPolymer, 1, #leftPolymer-1);
      rightPolymer = string.sub(rightPolymer, 2, #rightPolymer)
    end

    -- Merge step
    currentFinalPolymer = leftPolymer .. rightPolymer

    --print("AFTER MERGE : " .. currentFinalPolymer)
  else
    --print(polymer .. "=> SINGLE")
    -- Return the letter alone
    return polymer
  end

  return currentFinalPolymer
end


------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
function partOne (inputFile)

  -- Read the entire file at once.
  polymer = inputFile:read("*all")

  -- Remove the line break character at the end of the string
  polymer = string.sub(polymer, 1, #polymer-1)

  -- Launch the Divide and Conquer algorithm
  finalPolymer = DivideAndConquer(polymer);

  print("FINAL : " .. finalPolymer)

  return #finalPolymer
end

------------------------------------------------------------------------
-- partTwo - function used for the part 2
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 2.
------------------------------------------------------------------------
local function partTwo (inputFile)
  local lowerScore = nil
  local finalChar = 0

  -- Read the entire file at once.
  polymer = inputFile:read("*all")

  -- Remove the line break character at the end of the string
  polymer = string.sub(polymer, 1, #polymer-1)

  local lowerIndex = string.byte('a')-1
  local upperIndex = string.byte('A')-1
  -- while we did not reach the end of the alphabet or find a result equals to zero.
  repeat
    -- Update
    lowerIndex = lowerIndex + 1
    upperIndex = upperIndex + 1

    print("Current letter removed : " .. string.char(lowerIndex) .. ", " .. string.char(upperIndex))

    -- Remove all the current letter from the polymer (upper and lower case)
    local customPolymer = string.gsub(string.gsub(polymer, string.char(lowerIndex), ""), string.char(upperIndex), "")

    -- Launch the partOne to get the score
    local tempString = DivideAndConquer(customPolymer);
    print(tempString)
    local currentScore = #tempString

    if lowerScore == nil or lowerScore > currentScore then
      lowerScore = currentScore
      finalChar = lowerIndex;
    end
  until tonumber(lowerIndex) >= 122 and tonumber(upperIndex) >= 90 or (tonumber(lowerScore) ~= nil and lowerScore <= 0)

  print("Final score : " .. lowerScore .. ", caused by the character : " .. string.char(finalChar))
  return lowerScore;
end

--#################################################################
-- Main - Main function
--#################################################################
function day5Main (filename)
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

day5 = {
  day5Main = day5Main,
}

return day5
