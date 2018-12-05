-- Variables
local filename = "input.txt";
local mode = "r";

day2 = {}

---------------------------------------
-- Helper function for set data structure
---------------------------------------
function Set (list)
  local set = {};
  for _, l in ipairs (list) do set[l] = true end;
  return set;
end

---------------------------------------
-- Helpers function to construct the maching pattern in lua
---------------------------------------
function CreatePattern(separators)
  local i = 1;
  local pattern = "([";

  for i=1,#separators do
    pattern = pattern .. "^" .. separators[i];
  end

  return pattern .. "]+)";
end

---------------------------------------
-- Helpers function to retrieve a character from a string
---------------------------------------
function RetrieveCharacter (string, indice)
  return string.sub(string, indice, indice);
end

function SplitString(string, separators)
  local result = {};
  local pattern = "";
  local i = 1;

  -- If no separators provided, add a default one : any whitespace.
  if separators == nil then
    pattern = "%s";
  else
    pattern = CreatePattern(separators);
  end

  -- Parse the string
  for str in string.gmatch(string, pattern) do
    result[i] = str
    i = i + 1;
  end

  return result;
end

--#################################################################
-- function used for the part one
--#################################################################
function PartOne (inputFile)

  -- Read the entire file at once.
  lines = inputFile:read("*all");

  local separators = {
    "@",
    " , ",
    " : ",
    "x",
    "\n",
  };

  local borneMax = 1200;

  local lineStruct = {};

  -- rects that are claimed by two or more elfs.
  finalSet = {}

  -- Init
  for i=1,borneMax do
    finalSet[i] = {}
    for j=1,borneMax do
      table.insert(finalSet[i], 0);
    end
  end

  local indice = 1;

  -- Post processing : parse the string and save them in a Set.
  local lines = string.gsub(lines, ".-[\n]", function (val)
          t = SplitString(val, separators);

          -- [[
          print(t[2])
          print(t[3])
          print(t[4])
          print(t[5])

          print("===")

          print(t[2])
          print(t[2]+t[4]-1)
          print(t[3])
          print(t[3]+t[5]-1)
          --]]

          -- Current Rectangle
          for i=tonumber(t[2]+1),tonumber(t[2]+t[4]) do
            for j=t[3]+1,t[3]+t[5] do
              print(i);
              print(j);
              finalSet[i][j] = finalSet[i][j] + 1;
              --print(finalSet[i][j]);
            end
          end

          lineStruct[indice] = t;
          indice = indice + 1;

        end);

  local finalCounter = 0;

  print(#finalSet);
  for i = 1,#finalSet do
    local res = ""
    for j = 1,#finalSet[i] do
      if finalSet[i][j] ~= nil then
        res = res .. finalSet[i][j];
      end

      if finalSet[i][j] >= 2 then
        finalCounter = finalCounter + 1;
      end
    end
    print(res);
  end

  print(finalCounter);

  return 0;
end


---------------------------------------
-- function used for the part two
---------------------------------------
function PartTwo (inputFile)

end

---------------------------------------
-- function main
---------------------------------------
function main ()
  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, mode));

  -- Launch and print the final result
  print("Result part one :", PartOne(inputFile));

  -- Reset the file handle position to the beginning to use it again
  inputFile:seek("set");

  -- Launch and print the final result
  print("Result part two :", PartTwo(inputFile));

  -- Finally close the file
  inputFile:close();
end

main();
