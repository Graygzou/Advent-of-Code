--################################
--# @author: Grégoire Boiron     #
--# @date: 12/08/2018            #
--################################

local P = {} -- packages

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  helper = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Private functions
--#################################################################

----------------------------------------------------------------------------------------------
-- createPattern - construct the maching pattern based on many separators in lua
-- Params:
--    - separators : {strings}, list of separators.
-- Return
--    the final pattern containing all the separators.
----------------------------------------------------------------------------------------------
local function createPattern(separators)
  local i = 1;
  local pattern = "([";

  for i=1,#separators do
    pattern = pattern .. "^" .. separators[i];
  end

  return pattern .. "]+)";
end

--#################################################################
-- Public functions
--#################################################################
------------------------------------------------------------------------
-- splitString - parse a string with the given separators.
-- Params:
--    - string : string, string that needs to be parse
--    - separators : {strings}, list of separators.
-- Return:
--     a list of strings.
------------------------------------------------------------------------
local function splitString(string, separators)
  local result = {};
  local pattern = "";
  local i = 1;

  -- If no separators provided, add a default one : any whitespace.
  if separators == nil then
    pattern = "%s";
  else
    pattern = createPattern(separators);
  end

  -- Parse the string
  for str in string.gmatch(string, pattern) do
    result[i] = str
    i = i + 1;
  end

  return result;
end

--------------------------------------------------------------------------
-- saveLinesToArray - Used to parse lines from a file and save each of them in an array
-- Params:
--    - inputFile : file handle.
-- Return:
--     an array of every line of the doc
--------------------------------------------------------------------------
function saveLinesToArray(inputFile)
  days = {}

  -- Read the entire file at once.
  lines = inputFile:read("*all");

  -- Post processing : parse the string and save them in a Set.
  local lines = string.gsub(lines, ".-[\n]", function(val)
    table.insert(days, val);
  end);

  return days;
end

---------------------------------------------
-- gsub but works with overlapping pattern
---------------------------------------------
function findAndReplaceString (string, pattern, patternSize, replace)
  local finalString = string
  local nbMatch = 0
  patternSize = patternSize - 1

  for i= 1, #string - patternSize do
    m = string:sub(i, i + patternSize):match(pattern);
    if m then
      nbMatch = nbMatch + 1   -- Just for debug purpose

      local replaceChar = "!"
      if replace == "#" then
        replaceChar = "!"
      elseif replace == "." then
        replaceChar = ","
      end
      finalString = finalString:sub(1, i+1) .. replaceChar .. finalString:sub(i+3, #finalString)
    end
  end
  return finalString, nbMatch
end
---------------------------------------------
-- Tests
---------------------------------------------
print("|-------------------------------------------|")
print("| Tests findAndReplaceString function :     |")
print("|-------------------------------------------|")
print(findAndReplaceString("#..#.#..##......###...###", "%.%.%.##", 5, "#") == "#..#.#..##.....!###..!###")
print(findAndReplaceString("...#..#.#..##......###...###...........", "%.%.#%.%.", 5, "!") == "...!..#.#..##......###...###...........")
print(findAndReplaceString("...#...#....#.....#..#..#..#...........", "%.%.#%.%.", 5, "!") == "...!...!....!.....!..!..!..!...........")
print(findAndReplaceString("...#...#....#.....#..#..#..#...........", "#####", 5, "!") == "...#...#....#.....#..#..#..#...........")



------------------------------------------------------------------------
-- find the first occuring symbols in a string among a list of symbols
-----------------------------------------------------------------------
function findNextSymbolInString(string, startingIndex, stringLength, symbols)
  local finalRes = nil
  temp = nil
  for i = 1, #symbols do
    temp = string:sub(startingIndex, stringLength):find(symbols[i])
    if temp ~= nil then
      if finalRes ~= nil then
        finalRes = math.min(finalRes, temp)
      else
        finalRes = temp
      end
    end
  end

  return finalRes
end
---------------------------------------------
-- Tests
---------------------------------------------
print("|-------------------------------------------|")
print("| Tests findNextSymbolInString function :   |")
print("|-------------------------------------------|")
print(findNextSymbolInString("#######", 0, 7, {"G", "E"}) == nil)
print(findNextSymbolInString("#.#.#G#", 0, 7, {"G", "E"}) == 6)
print(findNextSymbolInString("#...EG#", 0, 7, {"G", "E"}) == 5)
print(findNextSymbolInString("#...GG#", 0, 7, {"G", "E"}) == 5)
print(findNextSymbolInString("#...GE#", 0, 7, {"G", "E"}) == 5)
print(findNextSymbolInString("#...FE#", 0, 7, {"G", "E"}) == 6)

------------------------------------------------------------------------
--
-----------------------------------------------------------------------
function dijkstra(pointsArray, startingPos, endingPos)
  

end


--#################################################################
-- Package end
--#################################################################

-- Let us make abstraction of the namespace prefixe for each function.
-- All the functions here are public outside the package
helper = {
  splitString = splitString,
  saveLinesToArray = saveLinesToArray,
  findAndReplaceString = findAndReplaceString,
  findNextSymbolInString = findNextSymbolInString,
}

return helper
