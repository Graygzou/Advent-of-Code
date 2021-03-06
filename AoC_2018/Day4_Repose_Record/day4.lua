--################################
--# @author: Grégoire Boiron     #
--# @date: 12/08/2018            #
--################################

local P = {} -- packages

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  day4 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- PRINTING function used for the part one
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
end

--------------------------------------
-- Helpers function to execute a bubble sort
---------------------------------------
function bubbleSortRecord (lines)
  local resStruct = lines;

  for i=#resStruct,1,-1 do
    for j=1,#resStruct-1 do
      --print(resStruct[j]);
      --print(resStruct[j+1]);
      datej = helper.splitString(resStruct[j], {"%]", "%-", "%s", "%:"});
      datejplus = helper.splitString(resStruct[j+1], {"%]", "%-", "%s", "%:"});

      --[[
      print("J :" .. datej[1] .. " ".. datej[2] .. " ".. datej[3] .. " " .. datej[4] .. " " .. datej[5]);
      print("J+1 :" .. datejplus[1] .. " ".. datejplus[2] .. " ".. datejplus[3] .. " " .. datejplus[4] .. " " .. datejplus[5]);
      --]]


      --print(tonumber(datejplus[3]));
      --print(tonumber(datej[3]));
      -- Start with the month
      if tonumber(datejplus[2]) < tonumber(datej[2]) then
        local temp = resStruct[j];
        resStruct[j] = resStruct[j+1];
        resStruct[j+1] = temp;
      -- Continue with the days
      elseif tonumber(datejplus[2]) == tonumber(datej[2]) and tonumber(datejplus[3]) < tonumber(datej[3]) then
        local temp = resStruct[j];
        resStruct[j] = resStruct[j+1];
        resStruct[j+1] = temp;
      elseif tonumber(datejplus[2]) == tonumber(datej[2]) and tonumber(datejplus[3]) == tonumber(datej[3]) then
        --print("HOURS")
        -- Hours and minutes
        if tonumber(datej[4]) == tonumber(datejplus[4]) then
          if tonumber(datejplus[5]) < tonumber(datej[5]) then
            local temp = resStruct[j];
            resStruct[j] = resStruct[j+1];
            resStruct[j+1] = temp;
          end
        else
          if tonumber(datej[4]) == 23 then
            local temp = resStruct[j];
            resStruct[j] = resStruct[j+1];
            resStruct[j+1] = temp;
          end
        end
      end
    end
  end
  return resStruct;
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

--#################################################################
-- FINAL function used for the part one
-- startIndex: Indice d'ou les informations vont etre prelevées. Commence a 1.
-- endIndex: Indice inclusive ou les informations vont s'arreter d'etre analysées
--#################################################################
function StudyGuardActivities2(activities)
  --print(activities);

  -- Init array of minutes
  minutes = {};
  for i=1,60 do
    minutes[i] = 0;
  end

  finalInteger = 0;
  finalMinutesIndex = 0;
  local isSleeping = false;

  currentIndex = 1;   -- Time index

  currentNumberIndex = 1; -- The current value index used in the loop.

  for currentNumber in string.gmatch(activities, "([^%,]+)") do
    --print("NUMBER" .. currentNumber);
    --print(finalInteger);
    -- Ignore the first value of the array
    --if currentNumberIndex > 1 then

      -- little parse before treatment
      time = helper.splitString(currentNumber, {"%:"});

      -- if start by 23 => no need to process.
      if tonumber(time[1]) ~= 23 then
        currentNumber = time[2]

        -- Reset the currentIndex if the day change
        if tonumber(currentNumber) < currentIndex and currentNumberIndex > 2 then
          --print("RESET !")
          isSleeping = false;
          currentIndex = 1;
          currentNumberIndex = 0;

        else

          -- If the value in the array is above 0.0
          if(tonumber(currentNumber) > 0) then
            if isSleeping then
              --print(currentIndex);
              for i=currentIndex,tonumber(currentNumber)-1 do
                minutes[currentIndex] = minutes[currentIndex] + 1;
                finalInteger = finalInteger + 1;
                currentIndex = currentIndex + 1;
              end
              --print(currentIndex);
            else
              --print(currentIndex);
              --print(tonumber(currentNumber));
              -- Forward "the time"
              for i=currentIndex,tonumber(currentNumber)-1 do
                currentIndex = currentIndex + 1;
              end
              --print(currentIndex);
            end
            if currentNumberIndex > 0 then
              --print(isSleeping);
              isSleeping = not isSleeping;
            end
          end
        end
      end

    --end
    currentNumberIndex = currentNumberIndex + 1;
  end

  --print("FINAL INT = " .. finalInteger);

  local maxValueSoFar = 0
  for i=1,#minutes do
    if minutes[i] > maxValueSoFar then
      maxValueSoFar = minutes[i];
      finalMinutesIndex = i;
    end
  end

  --print("FINAL MINUTES = " .. finalMinutesIndex);
  return tonumber(finalInteger), finalMinutesIndex;
end
-----------------------------------------
-- Tests
-----------------------------------------
print("|-------------------------------------------|")
print("| Tests StudyGuardActivities2 function :    |")
print("|-------------------------------------------|")
print(select(1, StudyGuardActivities2("00:00,00:05,00:25,00:30,00:55,00:05,00:24,00:29")) == 50);
print(select(2, StudyGuardActivities2("00:00,00:05,00:25,00:30,00:55,00:05,00:24,00:29")) == 24);
print(select(1, StudyGuardActivities2("23:58,00:40,00:50,00:02,00:36,00:46,00:03,00:45,00:55")) == 30);
print(select(2, StudyGuardActivities2("23:58,00:40,00:50,00:02,00:36,00:46,00:03,00:45,00:55")) == 45);

--####################################################################
-- BuildStringHeader - Build the header string to be print at the end
--####################################################################
function BuildStringHeader()
  stringHeader = "Date   ID   Minute\n";

  stringHeader = stringHeader .. "              000000000011111111112222222222333333333344444444445555555555\n";
  stringHeader = stringHeader .. "              012345678901234567890123456789012345678901234567890123456789";

  return stringHeader;
end

--#######################################################################
-- PrintFinalBoard - Used to go throught all the lines and retrieve useful data
--#######################################################################
function PrintFinalBoard(resultIndex, guardsIndex, headersDay, guards);
  -- print the header
  print(BuildStringHeader());

  -- print the rest
  index = 1;
  for j = 1,#resultIndex do
    for i = 1,#guardsIndex do
      if tonumber(string.sub(guardsIndex[i], 1, 4)) == tonumber(resultIndex[j]) then
        print(headersDay[i] .. StudyGuardActivities(guards[tonumber(guardsIndex[i])]));
      end
      index = index + 3;
    end
    print("_____________________________________________________________________________")
    print("_____________________________________________________________________________")
  end
end

--#######################################################################
-- MainLoop - Used to go throught all the lines and retrieve useful data
--#######################################################################
function MainLoop(daysStruct)
  local guards = {};
  local guardsIndex = {};
  local headersDay = {};

  local indice = 1;
  local guardIndex = "0";

  -- FINAL STRUCT
  local resultIndex = {};
  local resultPart1 = {};

  local uniqueID;
  local guardID = "";

  for i=1,#daysStruct do
      val = daysStruct[i];

      lineString = "";

      sentence = helper.splitString(val, {"%]"});   -- Parse the string with given separators
      dateTimeStr = helper.splitString(sentence[1], {"%[ ", " %]", "\n",});   -- Parse the string with given separators

      --[[
      print(sentence[1] .. "/" .. sentence[2]);
      print(dateTimeStr[1] .. ":" .. dateTimeStr[2] .. ":" .. dateTimeStr[3]);
      --]]

      date = helper.splitString(dateTimeStr[1], {"%-"});
      time = helper.splitString(dateTimeStr[2], {"%:"});

      found, newGuardNumber = RetrieveGuardNumber(sentence[2]);
      if found then
        --print("NEW GUARD :" .. newGuardNumber);

        -- Change the guard number
        guardNumber = newGuardNumber

        -- Compute a unique ID which is the guardnumber + the date on which is operating;

        guardID = guardNumber;
        uniqueID = guardID .. date[2] .. date[3] .. time[1] .. time[2];

        -- Insert the index to retrieve it easily later on.
        table.insert(guardsIndex, uniqueID);
        print(guardID);
        table.insert(resultIndex, guardID);

        -- Results
        table.insert(resultPart1, guardNumber);
      end

      print("GUARD ID " .. guardID);
      if resultPart1[tonumber(guardID)] == nil then
        resultPart1[tonumber(guardID)] = time[1] .. ":" .. time[2];
      else
        resultPart1[tonumber(guardID)] = resultPart1[tonumber(guardID)] .. "," .. time[1] .. ":" .. time[2];
      end


      print(uniqueID);

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

      -- Should multiply by 10 and add an extra space here..
      local lastSpace = "  ";
      if tonumber(guardNumber) < 1000 then
        if tonumber(guardNumber) < 100 then
          lastSpace = lastSpace .. "  ";
        else
          lastSpace = lastSpace .. " ";
        end
      end
      lineString = lineString .. date[2] .. "-" .. date[3] .. "  #" .. guardNumber .. lastSpace;
      --[[
      print(date[1])
      print(date[2])
      print(date[3])
      --]]

      if found then
        -- Insert what need to be print at the beginning of the day
        table.insert(headersDay, lineString);
      end
  end

  finalGuardID = "";
  finalGuardTime = 0;
  finalMinute = 0;

  for i = 1,#resultIndex do
    local currentRes, currentMinute = StudyGuardActivities2(resultPart1[tonumber(resultIndex[i])]);
    print("GUARD #" .. tonumber(resultIndex[i]) .. " : " .. currentRes .. " minutes. With the minutes :" .. currentMinute);
    if currentRes > finalGuardTime then
      finalGuardID = tonumber(resultIndex[i]);
      finalGuardTime = currentRes;
      finalMinute = currentMinute;
    end
  end

  print("=========================================================================");
  print("Choosen GUARD #" .. finalGuardID .. " : " .. finalGuardTime .. " minutes.");
  print("At the minute : " .. finalMinute);
  print("=========================================================================");
  print("FINAL RESULT PART 1 : " .. tonumber(tonumber(finalGuardID) * tonumber(finalMinute)));
  print("=========================================================================");

  -- Beautiful print
  PrintFinalBoard(resultIndex, guardsIndex, headersDay, guards);
end

--#################################################################
-- PartOne - function used for the part one
--#################################################################
function PartOne (inputFile)
  local daysStruct = helper.saveLinesToArray(inputFile);

  -- Sort the array of value
  local daysStruct = bubbleSortRecord(days);

  -- File that will contains the output file tidy-up
  file = io.open("Day4_Repose_Record/inputTidyUp.txt", "w");
  io.output(file);
  -- Save the sort output in another file.
  for i=1,#daysStruct do
    io.write(daysStruct[i]);
    print(daysStruct[i]);
  end
  io.close(file);

  -- Start the algorithm here
  MainLoop(daysStruct);

  return 0;
end

--#################################################################
-- PartTwo - function used for the part one
--#################################################################
function PartTwo (inputFile)

  -- TODO

  return 0;
end


--#################################################################
-- Main - Main function
--#################################################################
function day4Main (filename)
  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  -- Launch and print the final result
  print("Result part one :", PartOne(inputFile));

  -- Reset the file handle position to the beginning to use it again
  inputFile:seek("set");

  -- Launch and print the final result
  print("Result part two :", PartTwo(inputFile));

  -- Finally close the file
  inputFile:close();
end

--#################################################################
-- Package end
--#################################################################

day4 = {
  day4Main = day4Main,
}

return day4
