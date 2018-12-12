--#################################################################
--# @author: Grégoire Boiron                                      #
--# @date: 12/XX/2018                                             #
--#                                                               #
--# Template used for every main script for the day X of the AoC  #
--#################################################################

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
--
------------------------------------------------------------------------
function ContainsValue(array, value, rightSide)
  found = false

  print(value)

  local i = 1
  while i <= #array and not found do
    if rightSide then
      found = array[i].right == value
    else
      found = found or array[i].left == value
    end
    i = i + 1
  end
  return found
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function ContainsValue2(array, value)
  contained = false;
  for k, v in pairs(array) do
    contained = contained or k == value
  end
  return contained
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function isTaskAvailable(array, value, leftValue, finalPoint)
  available = true

  print("VALUE = " .. value)
  print("LEFT = " .. leftValue)
  for k, v in pairs(finalPoint) do
    print(k)
  end

  for i = 1,#array do
    if array[i].left ~= leftValue and array[i].right == value then
      print("CONTAINS2 : ")
      print(ContainsValue2(finalPoint, array[i].left))
      if not ContainsValue2(finalPoint, array[i].left) then
        available = false
      end
    end
  end
  return available
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function postProcessing(inputFile)

  tasks = {}
  -- Use set to register Starting and Ending Tasks
  local array = Set{}
  local startingPoint = Set{}

  -- Algorithm
  local instructions = helper.saveLinesToArray(inputFile)

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

    existInRight = ContainsValue(array, tasks[2], true)

    -- if the ending tasks is present in the starting structs.
    if startingPoint[tasks[3]] then
      startingPoint[tasks[3]] = false
    else
      -- If the point appear in the rightArray and already register in startingPoint
      if startingPoint[tasks[2]] ~= nil and existInRight then
        startingPoint[tasks[2]] = false
      elseif startingPoint[tasks[2]] == nil and not existInRight then
        startingPoint[tasks[2]] = true
      end
    end

    -- Save them for later computation
    table.insert(array, {left=tasks[2], right=tasks[3]})
  end

  print("ARRAY")
  for i = 1,#array do
    print(array[i].left .. " => " .. array[i].right)
  end

  return array, startingPoint
end

------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
function partOne (inputFile)

  finalString = ""
  local finalPoint = Set{}
  taskList = new{}

  -- Use set to register Starting and Ending Tasks
  local array, startingPoint = postProcessing(inputFile)

  print("START")
  table.sort(startingPoint)
  for k,v in pairs(startingPoint) do
    if v == true then
      print(k)
      List.pushleft(taskList, k)
    end
  end

  List.printstack(taskList)

  local nextValue = List.popright(taskList)
  while nextValue ~= nil do
    print("NEXT VALUE" .. nextValue)

    -- Update final string
    if not finalPoint[nextValue] then
      print("ICI")
      finalString = finalString .. nextValue
      finalPoint[nextValue] = true
    end

    -- Get all the value that this task "give" AND POSSIBLE TO DEAL WITH !
    for i = 1,#array do
      if array[i].left == nextValue then
        --table.insert(tempArray, string.byte(array[i].right))
        List.pushleft(taskList, array[i].right)
      end
    end

    tempArray = {}
    for k, v in pairs(taskList) do
      if k ~= "first" and k ~= "last" then
        table.insert(tempArray, string.byte(v))
      end
    end

    print(getSize(taskList))

    for i = 1,#tempArray do
      print(tempArray[i])
    end

    -- Sort the array to follow the alphabetic order
    table.sort(tempArray, function(a,b) return a<b end)

    taskList = new{}
    for i = 1,#tempArray do
      print(string.char(tempArray[i]))
      if isTaskAvailable(array, string.char(tempArray[i]), nextValue, finalPoint) then
        List.pushleft(taskList, string.char(tempArray[i]))
      end
    end

    print("DEBUG :")
    List.printstack(taskList)

    -- Add all new points to the struct we're iterating on.
    --for i = 1,#tempArray do
    --  print(string.char(tempArray[i]))
    --  List.pushleft(taskList, string.char(tempArray[i]))
    --end

    List.printstack(taskList)

    nextValue = List.popright(taskList)
  end

  print("FINAL VALUE" .. finalString)

  return finalString;
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function assignTasks (workersNum, extraTime, workers, nextValue, taskList)
  assigned = false

  local nextValue = List.popright(taskList)
  i = 1
  while i < workersNum and nextValue ~= nil do
    if workers[i].time == 0 then
      -- Assign the task to the current worker
      workers[i].task = nextValue
      workers[i].time = string.byte(nextValue) - 64 + extraTime
      assigned = true
      -- Get a new value
      nextValue = List.popright(taskList)
    end
    i = i + 1
  end

  return assigned, workers, taskList
end


------------------------------------------------------------------------
-- partTwo - function used for the part 2
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 2.
------------------------------------------------------------------------
function partTwo (inputFile)
  extraTime = 0
  workersNum = 2

  local tick = 0

  workers = {}
  for i=1,workersNum do
    table.insert(workers, {task="", time=0})  -- Insert the current time the worker need to work (0 right now)
  end

  local array, startingPoint = postProcessing(inputFile)
  local finalPoint = Set{}
  taskList = new{}

  print("START")
  table.sort(startingPoint)
  for k,v in pairs(startingPoint) do
    if v == true then
      print(k)
      List.pushleft(taskList, k)
    end
  end

  List.printstack(taskList)

  -- Assign the task to all available workers
  assigned, workers, taskList = assignTasks(workersNum, extraTime, workers, nextValue, taskList)

  print(assigned)
  while assigned do

    -- Debug
    for i=1,workersNum do
      print("Worker : " .. i .. ", task : " .. workers[i].task .. ", time : " .. workers[i].time)
    end

    List.printstack(taskList)

    -- While no workers has finished his tasks
    finished = false
    while not finished do
      -- Update the time
      tick = tick + 1

      -- Decrease by one all the current work for each worker
      for i=1,workersNum do
        if workers[i].task ~= "" then
          if workers[i].time > 0 then
            workers[i].time = workers[i].time - 1;
          end
          finished = finished or workers[i].time == 0
        end
      end

      for i=1,workersNum do
        print("Worker : " .. i .. ", task : " .. workers[i].task .. ", time : " .. workers[i].time)
      end
    end

    print("FINISHED")

    -- At least one worker has finished his task

    -- for all the task done, update the final string
    for i=1,workersNum do
      if workers[i].task ~= "" then
        if workers[i].time == 0 and not finalPoint[nextValue] then
          finalString = finalString .. workers[i].task
          finalPoint[workers[i].task] = true
        end

        if workers[i].time == 0 then
          for j = 1,#array do
            if array[j].left == workers[i].task then
              List.pushleft(taskList, array[j].right)
            end
          end

          tempArray = {}
          for k, v in pairs(taskList) do
            if k ~= "first" and k ~= "last" then
              table.insert(tempArray, string.byte(v))
            end
          end

          for i = 1,#tempArray do
            print("TEMP " .. tempArray[i])
          end

          -- Sort the array to follow the alphabetic order
          table.sort(tempArray, function(a,b) return a<b end)

          -- Get all the value that this task "give" AND POSSIBLE TO DEAL WITH !
          taskList = new{}
          for i = 1,#tempArray do
            print(string.char(tempArray[i]))
            if isTaskAvailable(array, string.char(tempArray[i]), workers[i].task, finalPoint) then
              List.pushleft(taskList, string.char(tempArray[i]))
            end
          end
        end

      end
    end

    print("DEBUG :")
    List.printstack(taskList)

    -- Assign the task to all available workers
    assigned, workers, taskList = assignTasks(workersNum, extraTime, workers, nextValue, taskList)
  end

  return tick;
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
