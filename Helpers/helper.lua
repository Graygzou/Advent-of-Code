--################################
--# @author: Grégoire Boiron     #
--# @date: 12/08/2018            #
--################################

local P = {} -- packages
local PRINT_TEST = true

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  helper = P
else
  _G[_REQUIREDNAME] = P
end

if PRINT_TEST then
  print("|*******************************************|")
  print("|Package HELPER : BEGIN TESTS               |")
  print("|*******************************************|")
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

--------------------------------------------------------------------------
--
--------------------------------------------------------------------------
function decimalToBinary (value)
  local binary = ""
  local temp = value
  repeat
    -- Concat the next value to the binary result
    binary = (temp % 2) .. binary
    -- Update the value
    temp = (temp // 2)
  until temp <= 0
  -- Complete if necessary with zeros
  local currentLength = #binary
  for i = currentLength, 3 do
    binary = "0" .. binary
  end
  return binary
end
---------------------------------------------
-- Tests
---------------------------------------------
if PRINT_TEST then
  print("== Tests decimalToBinary function ==")
  print(decimalToBinary(0) == "0000")
  print(decimalToBinary(1) == "0001")
  print(decimalToBinary(3) == "0011")
  print(decimalToBinary(5) == "0101")
  print(decimalToBinary(8) == "1000")
  print(decimalToBinary(11) == "1011")
  print(decimalToBinary(15) == "1111")
end

--------------------------------------------------------------------------
--
--------------------------------------------------------------------------
function binaryToDecimal (value)
  local decimal = 0
  local binary = "" .. value
  for i = 1, #binary do
    if tonumber(binary:sub(i,i)) == 1 then
      decimal = decimal + 2^((#binary-i))
    end
  end
  return decimal
end
---------------------------------------------
-- Tests
---------------------------------------------
if PRINT_TEST then
  print("== Tests binaryToDecimal function ==")
  print(binaryToDecimal("0000") == 0)
  print(binaryToDecimal("0001") == 1)
  print(binaryToDecimal("0011") == 3)
  print(binaryToDecimal("0101") == 5)
  print(binaryToDecimal("1000") == 8)
  print(binaryToDecimal("1011") == 11)
  print(binaryToDecimal("1111") == 15)
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
if PRINT_TEST then
  print("== Tests findAndReplaceString function ==")
  print(findAndReplaceString("#..#.#..##......###...###", "%.%.%.##", 5, "#") == "#..#.#..##.....!###..!###")
  print(findAndReplaceString("...#..#.#..##......###...###...........", "%.%.#%.%.", 5, "!") == "...!..#.#..##......###...###...........")
  print(findAndReplaceString("...#...#....#.....#..#..#..#...........", "%.%.#%.%.", 5, "!") == "...!...!....!.....!..!..!..!...........")
  print(findAndReplaceString("...#...#....#.....#..#..#..#...........", "#####", 5, "!") == "...#...#....#.....#..#..#..#...........")
end


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
if PRINT_TEST then
  print("== Tests findNextSymbolInString function for list ==")
  print(findNextSymbolInString("#######", 0, 7, {"G", "E"}) == nil)
  print(findNextSymbolInString("#.#.#G#", 0, 7, {"G", "E"}) == 6)
  print(findNextSymbolInString("#...EG#", 0, 7, {"G", "E"}) == 5)
  print(findNextSymbolInString("#...GG#", 0, 7, {"G", "E"}) == 5)
  print(findNextSymbolInString("#...GE#", 0, 7, {"G", "E"}) == 5)
  print(findNextSymbolInString("#...FE#", 0, 7, {"G", "E"}) == 6)
end

if PRINT_TEST then
  print("|*******************************************|")
  print("|Package HELPER : END TESTS                 |")
  print("|*******************************************|")
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
  decimalToBinary = decimalToBinary,
  binaryToDecimal = binaryToDecimal,
}

return helper
