-- Variables
local filename = "inputTestParse.txt";
local mode = "r";

day2 = {}

--#################################################################
-- ToStringArray - Return true if the rect1 contained the rect2, false otherwise
--#################################################################
function ToStringArray(array)
  for i=1,#array do
    local string = "";
    for j=1,#array[i] do
      string = string .. array[i][j] .. ",";
    end
    print(string);
  end
end

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
function bubbleSortRectangleArea (rectangleArray, param1, param2)
  local resArray = rectangleArray

  for i=#rectangleArray,1,-1 do
    for j=2,i do
      if tonumber(resArray[j-1][param1]) * tonumber(resArray[j-1][param2]) > tonumber(resArray[j][param1]) * tonumber(resArray[j][param2]) then
        temp = resArray[j-1];
        resArray[j-1] = resArray[j];
        resArray[j] = temp;
      end
    end
  end

  return resArray;
end


--#################################################################
-- IsContainRect - Return true if the rect1 contained the rect2, false otherwise
--#################################################################
function IsContainRect (rect1, rect2)
  local maxWidth = {tonumber(rect1[2])+tonumber(rect1[4]), tonumber(rect2[2])+tonumber(rect2[4])};
  local maxHeight = {tonumber(rect1[3])+tonumber(rect1[5]), tonumber(rect2[3])+tonumber(rect2[5])};

  --[[
  print(maxWidth[1]);
  print(maxWidth[2]);
  print(maxHeight[1]);
  print(maxHeight[2]);
  --]]

  return ((tonumber(rect2[2])) >= (tonumber(rect1[2]))) and
          ((tonumber(rect2[3])) >= (tonumber(rect1[3]))) and
          (tonumber(maxWidth[2]) <= tonumber(maxWidth[1])) and
          (tonumber(maxHeight[2]) <= tonumber(maxHeight[1]));
end
------------------------------------------------------------------
-- TESTS
--[[
print(IsContainRect({"#4", "486", "680", "13", "15"}, {"#1", "0", "0", "2002", "2002"}));  --false
print(IsContainRect({"#1", "0", "0", "2002", "2002"}, {"#65", "486", "680", "13", "15"}));  --true
print(IsContainRect({"#66", "3", "3", "1602", "1602"}, {"#55", "486", "680", "13", "15"}));  --true
print(IsContainRect({"#5", "5", "5", "1502", "1502"}, {"#1", "0", "0", "2005", "2005"}));  --false
--]]

--#################################################################
-- GetOverlappingPoints - TODO
--#################################################################
function GetNumberOverlappingPoints (rect1, rect2, existingPoints)
  value = 0;

  local startJIndex = 0;
  local lengthJ = 0;
  if tonumber(rect1[2]) > tonumber(rect2[2]) then
    startJIndex = rect1[2];
    lengthJ = rect2[2]+rect2[4] - startJIndex;
  elseif tonumber(rect1[2]) == tonumber(rect2[2]) then
    startJIndex = rect1[2];
    lengthJ = math.max(rect2[4], rect1[4]) - startJIndex;
  else
    startJIndex = rect2[2];
    lengthJ = rect1[2]+rect1[4] - startJIndex;
  end

  --print(startJIndex);
  --print(lengthJ);

  local startIIndex = 0;
  local lengthI = 0;
  if tonumber(rect1[3]) > tonumber(rect2[3]) then
    startIIndex = rect1[3];
    lengthI = rect2[3]+rect2[5] - startIIndex;
  elseif tonumber(rect1[3]) == tonumber(rect2[3]) then
    print(math.max(rect2[5], rect1[5]));
    startIIndex = rect1[3];
    lengthI = math.max(rect2[5], rect1[5]) - startIIndex;
  else
    startIIndex = rect2[3];
    lengthI = rect1[3]+rect1[5] - startIIndex;
  end

  --print(startIIndex);
  --print(lengthI);

  --print(#existingPoints);

  tempStruc = Set{};
  tempStruc2 = {}

  for j=startJIndex,(startJIndex+lengthJ-1) do
    for i=startIIndex,(startIIndex+lengthI-1) do
      local key = (j * 1000 + i);
      if tempStruc ~= nil then
        if not tempStruc[key] then
          print("HRTE" .. key)
          tempStruc[key] = true;
          table.insert(tempStruc2, key);
          -- Update the existingPoint List
          value = value + 1;
        end
      end
    end
  end

  --print(table.getn(tempStruc2));

  for i=1,#tempStruc2 do
    print(tempStruc2[i]);
  end

  existingPoints = tempStruc;



  return value, existingPoints;
end
------------------------------------------------------------------
-- TESTS
-- Regular tests
print(GetNumberOverlappingPoints({"#1", "1", "3", "4", "4"}, {"#2", "3", "1", "4", "4"}) == 4);
print(GetNumberOverlappingPoints({"#1", "1", "3", "4", "4"}, {"#2", "3", "1", "6", "6"}) == 8);
print(GetNumberOverlappingPoints({"#2", "3", "1", "4", "4"}, {"#1", "1", "3", "4", "4"}) == 4);
print(GetNumberOverlappingPoints({"#2", "3", "1", "6", "6"}, {"#1", "1", "3", "4", "4"}) == 8);

-- Share the same edge
print(GetNumberOverlappingPoints({"#2", "3", "3", "6", "6"}, {"#1", "1", "3", "4", "4"}) == 6);
print(GetNumberOverlappingPoints({"#1", "1", "3", "4", "4"}, {"#2", "3", "3", "6", "6"}) == 6);
print(GetNumberOverlappingPoints({"#1", "1", "3", "4", "4"}, {"#2", "1", "1", "4", "4"}) == 6);
print(GetNumberOverlappingPoints({"#2", "1", "1", "4", "4"}, {"#1", "1", "3", "4", "4"}) == 6);

--
print(GetNumberOverlappingPoints({"#2", "3", "3", "4", "4"}, {"#1", "1", "1", "4", "4"}) == 4);



--#################################################################
-- MergeRectangles - TODO
--#################################################################
function MergeRectangles(lineStruct2)
  local points = 0;   -- Final number !

  local exSet = lineStruct2;
  local newSet = {};
  knownPoints = Set{};

  local eraseRect = false;

  for i=1,#exSet do
    local rect = exSet[i];
    if rect ~= nil then
      print(rect[1]);

      for j=i+1,#exSet do
        if exSet[j] ~= nil then
          print(exSet[j][1]);
          -- check if we can merge the current rectangle into the above one.
          if IsContainRect(rect, exSet[j]) then
            -- Remove the rect from the list
            print("erase1");
            ------
            -- the new one should take the lead.... Maybe not..
            ------
            newPoints, knownPoints = GetNumberOverlappingPoints(rect, exSet[j], knownPoints);

            table.insert(newSet, rect);
            table.remove(exSet, j);

          elseif IsContainRect(exSet[j], rect) then

            print("erase2");
            
            newPoints, knownPoints = GetNumberOverlappingPoints(rect, exSet[j], knownPoints);

            table.insert(newSet, exSet[j][1]);
            table.remove(exSet, i);
          else
            -- Here rectangle are far from each other or overlapping each other.
            -- So we add overlaping index to a final set.
            print("overlap");

            newPoints, knownPoints = GetNumberOverlappingPoints(rect, exSet[j], knownPoints);

            point = points + newPoints;

            -- Remove the current rectangle to not deal with it when treating the j rectangle
            table.remove(exSet, i);
          end
        end
      end
      if not eraseRect then
        table.insert(newSet, rect);
      end
    end
  end

  print("RESULTAT");

  print(points);
  print(points/2);

  --[[
  for i=1,#newSet do
    print(newSet[i][1]);
  end
  --]]

  print("END");

  return #knownPoints;
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

  for i=1,#lineStruct2 do
    print(lineStruct2[i][1] .. "," .. lineStruct2[i][2] .. "," .. lineStruct2[i][3] .. "," ..  lineStruct2[i][4] .. "," .. lineStruct2[i][5]);
  end

  --local lineStruct2 = bubbleSortRectangle(lineStruct, 3, 2);

  print(MergeRectangles(lineStruct2));

  --print(lineStruct2[1][1]);

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
