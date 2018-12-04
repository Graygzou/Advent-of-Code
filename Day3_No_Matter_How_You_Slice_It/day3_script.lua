-- Variables
local filename = "inputTestParse.txt";
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

--------------------------------------
-- Helpers function to execute a bubble sort
---------------------------------------
function bubbleSort (string)
  local resStr = string
  for i=#resStr,1,-1 do
    for j=1,#resStr-1 do
      if string.byte(retrieveCharacter(resStr, j+1)) < string.byte(retrieveCharacter(resStr, j)) then
        resStr = string.sub(resStr, 1, j-1) .. retrieveCharacter(resStr, j+1) .. retrieveCharacter(resStr, j) .. string.sub(resStr, j+2, #resStr)
      end
    end
  end
  return resStr;
end

--------------------------------------
-- Useless for now.
---------------------------------------
function bubbleSort (array)
  local resArray = array

  for i=#resArray,1,-1 do
    for j=1,#resArray-1 do
      if resArray[j+1] < resArray[j] then
        local temp = resArray[j];
        resArray[j] = resArray[j+1];
        resArray[j+1] = temp;
      end
    end
  end

  return resArray;
end

--------------------------------------
-- My nigga function.
---------------------------------------
function bubbleSortRectangle (rectangleArray, param1, param2)
  local resArray = rectangleArray

  for i=#rectangleArray,1,-1 do
    for j=2,i do
      if tonumber(resArray[j-1][param1]) > tonumber(resArray[j][param1]) or
        tonumber(resArray[j-1][param1]) == tonumber(resArray[j][param1]) and tonumber(resArray[j-1][param2]) > tonumber(resArray[j][param2]) then
        temp = resArray[j-1];
        resArray[j-1] = resArray[j];
        resArray[j] = temp;
      end
    end
  end

  return resArray;
end

--------------------------------------
-- EVENT BETTER
---------------------------------------
function bubbleSortRectangle (rectangleArray, param1, param2)
  local resArray = rectangleArray

  for i=#rectangleArray,1,-1 do
    for j=2,i do
      if tonumber(resArray[j-1][param1]) > tonumber(resArray[j][param1]) or
        tonumber(resArray[j-1][param1]) == tonumber(resArray[j][param1]) and tonumber(resArray[j-1][param2]) > tonumber(resArray[j][param2]) then
        temp = resArray[j-1];
        resArray[j-1] = resArray[j];
        resArray[j] = temp;
      end
    end
  end

  return resArray;
end


function MergeRectangles(lineStruct2)
  local newSet = {};
  local ind = 1;

  for i=1,#lineStruct2 do
    local rect = lineStruct2[i];
    newSet[ind] = rect[1];
    ind = ind + 1;

    for j=i+1,#lineStruct2 do
      -- check if we can merge the current rectangle into the above one.
      if (tonumber(lineStruct2[j][2]) > tonumber(rect[2]) and
        tonumber(lineStruct2[j][3]) > tonumber(rect[3]) and
        tonumber(lineStruct2[j][2])+lineStruct2[j][4] < tonumber(rect[2])+tonumber(rect[4]) and
        tonumber(lineStruct2[j][3])+tonumber(lineStruct2[j][5]) < tonumber(rect[3])+tonumber(rect[5])) or
        (tonumber(lineStruct2[j][2]) < tonumber(rect[2]) and
          tonumber(lineStruct2[j][3]) < tonumber(rect[3]) and
          tonumber(lineStruct2[j][2])+lineStruct2[j][4] > tonumber(rect[2])+tonumber(rect[4]) and
          tonumber(lineStruct2[j][3])+tonumber(lineStruct2[j][5]) > tonumber(rect[3])+tonumber(rect[5])) then
        -- Remove the rect from the list
        -- so nothing
      else
        print(lineStruct2[j][1]);
        newSet[ind] = lineStruct2[j][1];
        ind = ind + 1;
      end
    end
  end

  print(#newSet);

  for i=1,#newSet do
    print(newSet[i][1]);
  end

end

---------------------------------------
-- function used for the part one
---------------------------------------
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

  local lineStruct = {};

  -- rects that are claimed by two or more elfs.
  local rectTwoOrMore = {}
  local rectLeft = {}

  local i = 1;

  -- Post processing : parse the string and save them in a Set.
  local lines = string.gsub(lines, ".-[\n]", function (val)
          t = SplitString(val, separators);
          lineStruct[i] = t;

          i = i + 1;

          --[[
          for i=1,#t do
            print(t[i]);
          end
          --]]

        end);
  local lineStruct2 = bubbleSortRectangle(lineStruct, 2, 3);

  MergeRectangles(lineStruct2);

  --local lineStruct2 = bubbleSortRectangle(lineStruct, 3, 2);
  --print(lineStruct2[1][1]);
  for i=1,#lineStruct2 do
    print(lineStruct2[i][1] .. "," .. lineStruct2[i][2] .. "," .. lineStruct2[i][3] .. "," ..  lineStruct2[i][4] .. "," .. lineStruct2[i][5]);
  end
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
