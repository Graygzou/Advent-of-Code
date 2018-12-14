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
  day9 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

function printLine(l, currentPlayer, currentMarble)
  local finalString = "[" .. currentPlayer .. "] "
  zeroAppears = 0
  while l and zeroAppears <= 1 do
    if tonumber(l.value) == 0 then
      zeroAppears = zeroAppears + 1
    end
    if zeroAppears <= 1 then
      if l.value == currentMarble.value then
        finalString = finalString .. " (" .. l.value .. ")"
      else
        finalString = finalString .. " " .. l.value
      end
    end
    l = l.next
  end

  return finalString
end

function isINT(n)
  return n==math.floor(n)
end

------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (inputFile)
  nbPlayers = 493
  lastMarble = 7186300

  playerScore = {}

  for i=1,nbPlayers do
    playerScore[i] = 0
  end

  -- Use a linked list to solve it
  currentMarble = nil

  -- First marble (0)
  firstMarble = {next = nil, previous = nil, value = 0}

  -- Second marble (1) : Create a circular struct
  nextMarble = {next = nil, previous = nil, value = 1}

  firstMarble.next = nextMarble
  firstMarble.previous = nextMarble

  nextMarble.next = firstMarble
  nextMarble.previous = firstMarble

  currentMarble = nextMarble.next


  local l = currentMarble
  print(printLine(firstMarble, "-", nextMarble))

  local currentPlayer = 1
  local i = 2
  while(i <= lastMarble) do

    -- Find which player is currenly playing
    currentPlayer = ((currentPlayer + 1) % (nbPlayers+1))
    if currentPlayer == 0 then
      currentPlayer = 1
    end

    -- Add the score to the current player if needed
    if isINT(i / 23) then
      local oldMarble = newMarble
      for index=1,7 do
        oldMarble = oldMarble.previous
      end

      playerScore[currentPlayer] = playerScore[currentPlayer] + oldMarble.value + i

      -- Remove the marble and fill the gap
      tempMarble = oldMarble.next
      oldMarble.previous.next = tempMarble

      currentMarble = oldMarble.next.next

      newMarble = oldMarble.next

      --oldMarble = nil -- Garbage collection
    else
      -- temp Marble
      tempMarble = currentMarble.next

      -- Create the new marble
      newMarble = {next = currentMarble.next, previous = currentMarble, value = i}

      -- Create a gap and fill it with the new marble
      currentMarble.next = newMarble
      tempMarble.previous = newMarble

      -- Update the current marble
      currentMarble = newMarble.next

    end

    --print(printLine(firstMarble, currentPlayer, newMarble))

    -- Update (fast forward) a turn
    -- Update the turn
    i = i + 1
  end

  maxScore = 0
  for i=1,nbPlayers do
    if maxScore < playerScore[i] then
      maxScore = playerScore[i]
    end
  end

  return maxScore;
end

------------------------------------------------------------------------
-- partTwo - function used for the part 2
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 2.
------------------------------------------------------------------------
local function partTwo (inputFile)

  -- TODO

  return 0;
end


--#################################################################
-- Main - Main function
--#################################################################
function day9Main (filename)
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

day9 = {
  day9Main = day9Main,
}

return day9
