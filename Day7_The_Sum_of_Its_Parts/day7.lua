--#################################################################
--# @author: Grégoire Boiron                                      #
--# @date: 12/XX/2018                                             #
--#                                                               #
--# Template used for every main script for the day X of the AoC  #
--#################################################################
-- Note:
-- To use it Press Ctrl + F and replace "DayX" by "Day" and the associated number.
--

local P = {} -- packages

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  day7 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
function partOne (inputFile)

  local instructions = helper.saveLinesToArray(inputFile)

  tasks = {}
  leftArray = {}
  rightArray = {}

  local startingPoint = {}


  -- /!\ Use a Set here. /!\

  for i = 1,#instructions do
    print(instructions[i])
    --tasks = helper.splitString(instructions[i], {"^][", "must be finished before step", "can begin.\n"})

    local f = 1
    for str in string.gmatch(instructions[i], "[%u]") do
      if f ~= 1 then
        tasks[f] = str;
      end
      f = f + 1;
    end

    print(string.byte(tasks[2]))
    print(string.byte(tasks[3]))

    print(startingPoint[string.byte(tasks[3])])

    if startingPoint[string.byte(tasks[3])] then
      print("REMOVE")
      table.remove(startingPoint, string.byte(tasks[3]))
    end


    print(startingPoint[string.byte(tasks[2])])

    -- If the point appear in the rightArray and already register in startingPoint
    if startingPoint[string.byte(tasks[2])] ~= nil and rightArray[string.byte(tasks[2])] ~= nil then
      print("REMOVE")
      table.remove(startingPoint, string.byte(tasks[2]))
    elseif startingPoint[string.byte(tasks[2])] == nil and rightArray[string.byte(tasks[2])] == nil then
      print("ADD")
        print(tasks[2])
      table.insert(startingPoint, string.byte(tasks[2]))
    end

    print(tasks[3])

    -- Save them for later computation
    table.insert(leftArray, string.byte(tasks[2]))
    table.insert(rightArray, string.byte(tasks[3]))
  end

  for i=1,#startingPoint do
    if startingPoint[i] then
      print(i)
    end
  end

  return 0;
end

------------------------------------------------------------------------
-- partTwo - function used for the part 2
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 2.
------------------------------------------------------------------------
function partTwo (inputFile)

  -- TODO

  return 0;
end


--#################################################################
-- Main - Main function
--#################################################################
function day7Main (filename)
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

day7 = {
  day7Main = day7Main,
}

return day7
