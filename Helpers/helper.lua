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

---------------------------------------
-- Set - function to create set data structure
-- Params:
--    - list : existing (can be empty) list.
-- Return:
--     the set datastructure.
---------------------------------------
function Set (list)
  local set = {};
  for _, l in ipairs (list) do set[l] = true end;
  return set;
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
print("---------------------------------------------")
print("Tests findAndReplaceString function : ")
print("---------------------------------------------")
print(findAndReplaceString("#..#.#..##......###...###", "%.%.%.##", 5, "#") == "#..#.#..##.....!###..!###")
print(findAndReplaceString("...#..#.#..##......###...###...........", "%.%.#%.%.", 5, "!") == "...!..#.#..##......###...###...........")
print(findAndReplaceString("...#...#....#.....#..#..#..#...........", "%.%.#%.%.", 5, "!") == "...!...!....!.....!..!..!..!...........")
print(findAndReplaceString("...#...#....#.....#..#..#..#...........", "#####", 5, "!") == "...#...#....#.....#..#..#..#...........")

-----------------------------------------------------
-- Helpers function to execute a bubble sort
-----------------------------------------------------
function bubbleSortList (list, swapFunction)
  local resStruct = list

  for i=#list,1,-1 do
    for j=1,#list-1 do
      if swapFunction(list[j], list[j+1]) then
        local temp = resStruct[j];
        resStruct[j] = resStruct[j+1];
        resStruct[j+1] = temp;
      end
    end -- end for 2
  end -- end for 1
  return resStruct;
end

------------------------------------------------------------------------------------
-- Helpers function know if an element is contained into a list
-- Return (true, index) if the element is inside the list, (false, nil) otherwise
------------------------------------------------------------------------------------
function contains(list, element)
  if list == {} then return false, nil end
  local found = false
  local finalIndex = nil
  local i = 0

  repeat
    i = i + 1
    found = list[i] == element
    if found then
      finalIndex = i
    end
  until i > #list or found
  return found, finalIndex
end
---------------------------------------------
-- Tests
---------------------------------------------
print("---------------------------------------------")
print("Tests contains function : ")
print("---------------------------------------------")
print(contains({}, 2) == false)
print(contains({8,4,6,2}, 3) == false)
print(contains({8,4,6,2}, 4) == true)
print(contains({8,4,6,2}, 2) == true)
print(contains({8,4,6,2}, 6) == true)

--#################################################################
-- Package end
--#################################################################

-- Let us make abstraction of the namespace prefixe for each function.
-- All the functions here are public outside the package
helper = {
  splitString = splitString,
  saveLinesToArray = saveLinesToArray,
  Set = Set,
  findAndReplaceString = findAndReplaceString,
  bubbleSortList = bubbleSortList,
  contains = contains,
}

return helper
