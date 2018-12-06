-- Variables
local filename = "inputFake.txt";
local mode = "r";

--#################################################################
-- function used for the part one
-- startIndex: Indice d'ou les informations vont etre prelevées. Commence a 1.
-- endIndex: Indice inclusive ou les informations vont s'arreter d'etre analysées
--#################################################################
function StudyGuardActivities(activities)
  --print(activities);
  --print(startIndex);
  --print(endIndex);

  finalString = "";
  value = ".";

  currentIndex = 1;
  currentNumberIndex = 1;
  for currentNumber in string.gmatch(activities, "([^%,]+)") do
    --print("NUMBER" .. currentNumber);
    --print(value);
    if(tonumber(currentNumber) > 0) then
      for i=currentIndex,tonumber(currentNumber) do
        --print(value);
        finalString = finalString .. value;
        currentIndex = currentIndex + 1;
      end
      if currentNumberIndex ~= 1 then
        value = (value == "." and "#" or ".");
      end
    end
    currentNumberIndex = currentNumberIndex + 1;
  end
  -- Complete the day of the guard if needed.
  if currentIndex < 60 then
    for i = currentIndex,60 do
      finalString = finalString .. ".";
    end
  end
  return finalString;
  --"............................................................";
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
-- TODO
---------------------------------------
function RetrieveGuardNumber(string)
  local guardNumber;
  for number in string.gmatch(string, "([%d]+)") do
    guardNumber = number;
  end
  return (guardNumber ~= nil), guardNumber;
end
-----------------------------------------
-- Tests
-----------------------------------------
--[[
RetrieveGuardNumber("Guard #2081 begins shift");
RetrieveGuardNumber("falls asleep");
RetrieveGuardNumber("wakes up");
RetrieveGuardNumber("This is a test.");
--]]

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


function BuildStringHeader()
  stringHeader = "Date   ID   Minute\n";

  stringHeader = stringHeader .. "            000000000011111111112222222222333333333344444444445555555555\n";
  stringHeader = stringHeader .. "            012345678901234567890123456789012345678901234567890123456789";

  return stringHeader;
end

--#################################################################
-- function used for the part one
--#################################################################
function PartOne (inputFile)

  -- Read the entire file at once.
  lines = inputFile:read("*all");

  local separators = {
    "%]",
  };

  local separators2 = {
    "%[ ",
    " %]",
    "\n",
  };

  local guards = {};
  local guardsIndex = {};
  local headersDay = {};

  local indice = 1;
  local guardIndex = "0";

  local days = {};
  local daysIndex = 1;

  stringHeader = BuildStringHeader();

  -- Post processing : parse the string and save them in a Set.
  local lines = string.gsub(lines, ".-[\n]", function (val)

          -- Should apply a bubble sort here to tidy up date.

          lineString = "";

          a = SplitString(val, separators);

          --[[
          print(a[1]);
          print(a[2]);
          --]]

          t = SplitString(a[1], separators2);

          --[[
          print(t[1])
          print(t[2])
          print(t[3])
          --]]

          date = SplitString(t[1], {"%-"});

          found, newGuardNumber = RetrieveGuardNumber(a[2]);
          if found then
            --print("NEW GUARD :" .. newGuardNumber);

            -- Change the guard number
            guardNumber = newGuardNumber

            -- Insert the index to retrieve it easily later on.
            table.insert(guardsIndex, guardNumber .. date[3]);
          end

          time = SplitString(t[2], {"%:"});

          -- Compute a unique ID which is the guardnumber + the date on which is operating;
          print(guardNumber);
          uniqueID = guardNumber .. date[3];

          -- Store the time of the current event in the guard array.
          if tonumber(time[1]) == 23 then
            -- The time before midnight is not revelent. We force it to start at midnight.
            guards[tonumber(uniqueID)] = 0;
          else
            if guards[tonumber(uniqueID)] == nil then
              guards[tonumber(uniqueID)] = time[2];
            else
              if found then
                -- Mark the changements in the activities string
                guards[tonumber(uniqueID)] = guards[tonumber(uniqueID)] .. "||" .. time[2] ;
              else
                guards[tonumber(uniqueID)] = guards[tonumber(uniqueID)] .. "," .. time[2];
              end
            end
          end


          --print(tonumber(time[1]) .. guards[tonumber(uniqueID)]);

          lineString = lineString .. date[2] .. "-" .. date[3] .. "  #" .. guardNumber .. "  ";
          --[[
          print(date[1])
          print(date[2])
          print(date[3])
          --]]

          if found then
            -- Insert what need to be print at the beginning of the day
            table.insert(headersDay, lineString);
          end


        end);

  print(lines);

  print(stringHeader);

  index = 1;
  for i = 1,#guardsIndex do
    print(headersDay[i] .. StudyGuardActivities(guards[tonumber(guardsIndex[i])], index, (index+2)));
    index = index + 3;
  end

  return 0;
end

--#################################################################
-- function used for the part one
--#################################################################
function PartTwo (inputFile)

  return 0;
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
