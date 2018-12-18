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
  day13 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

------------------------------------------------------------------------
--
-----------------------------------------------------------------------
function findNextSymbol(currentLine, index, sizeLine, symbols)
  local finalRes = nil

  temp1 = currentLine:sub(index, sizeLine):find(symbols[1])
  temp2 = currentLine:sub(index, sizeLine):find(symbols[2])

  if temp1 ~= nil or temp2 ~= nil then
    if temp1 == nil and temp2 ~= nil then
      finalRes = temp2
    elseif temp2 == nil and temp1 ~= nil then
      finalRes = temp1
    else
      finalRes = math.min(temp1, temp2)
    end
  end

  return finalRes
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function constructLoop (currentLine, lineIndex, tracks, startingSymbols, endingSymbols)
  local index = 1

  repeat
    -- Find the first char representing the TOP LEFT of the loop
    startingLoop = findNextSymbol(currentLine, index, #currentLine, startingSymbols)

    print(startingLoop)

    if startingLoop ~= nil then
      index = index + select(1, startingLoop)
      local startingIndex = index   -- x variable top-left
      startingIndex = startingIndex - 2

      print(startingLoop)
      print("CURRENT STARTING", currentLine:sub(index, #currentLine))

      -- Find the first char representing the TOP RIGHT of the loop
      endingLoop = findNextSymbol(currentLine, index, #currentLine, endingSymbols)

      if endingLoop ~= nil then
        index = index + select(1, endingLoop)
        endingIndex = index   -- x variable top-right
        endingIndex = endingIndex - 1

        print(endingLoop)
        print("CURRENT ENDING", currentLine:sub(index, #currentLine))

        local found = false
        for i = 1, #tracks do
          if tracks[i].topleft.y == 33 then
            print(tracks[i].topleft.y)
            print(startingIndex)
            print(tracks[i].topright.y)
            print(endingIndex)
          end

          if tracks[i].topleft.x == startingIndex and tracks[i].topright.x == endingIndex then
            print("MATCH !")
            found = true        -- Update the boolean
            tracks[i].bottomleft = point.new{startingIndex, lineIndex-1}
            tracks[i].bottomright = point.new{endingIndex, lineIndex-1}
          end
        end

        if not found then
          -- Insert the new loop
          table.insert(tracks, {topleft = point.new{startingIndex, lineIndex-1},
                                topright = point.new{endingIndex, lineIndex-1},
                                bottomleft = nil,
                                bottomright = nil})
        end

        print(startingLoop)
        print(index)
      end
    end
  until startingLoop == nil or index >= #currentLine

  --for i = 1,#tracks do
  --  print("(" .. tracks[i].topleft.x .. ", " .. tracks[i].topleft.y .. "), (" .. tracks[i].topright.x .. ", " .. tracks[i].topright.y .. ")")
  --end
end

------------------------------------------------------------------------
-- Add a card if found on the line
-- A card is composed by a velocity, an int nextTurn (contains the info to guide him when finding junctions)
-- a current position (could store a list of already visited cells instead..) and a current path the card is on.
------------------------------------------------------------------------
function addCards(currentLine, cards, coordY, cardDirection, velocity)
  local index = 1
  local coordXCard = nil
  repeat
    coordXCard = currentLine:sub(index, #currentLine):find(cardDirection)
    if coordXCard ~= nil then
      -- Add the found card to the struct (nextTurn = 0 mean he will turn left)
      table.insert(cards, {position=point.new{index+coordXCard-2, coordY}, velocity = point.new(velocity), nextTurn=0, currentLoop=nil})

      index = index + coordXCard    --Update the index to move on
    end
  until coordXCard == nil or index >= #currentLine
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function findCards(currentLine, coordX, cards)
  local index = 1

  coordX = coordX - 1 -- Start at the index 0 for the algorithm

  -- Give the pattern to search and his velocity vector
  addCards(currentLine, cards, coordX, "%<", {-1, 0})
  addCards(currentLine, cards, coordX, "%>", {1, 0})
  addCards(currentLine, cards, coordX, "%^", {0, -1})
  addCards(currentLine, cards, coordX, "%v", {0, 1})
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function assignInitialLoopToCards(cards, tracks)
  for i = 1, #cards do
    local found = false
    local loopIndex = 0

    print("Cards : position = " .. point.toString(cards[i].position, 2))

    repeat
      loopIndex = loopIndex + 1

      -- Retrieve the current loop
      print(loopIndex)
      local currentLoop = tracks[loopIndex]

      print("(" .. currentLoop.topleft.x .. ", " .. currentLoop.topleft.y .. "), (" .. currentLoop.topright.x .. ", " .. currentLoop.topright.y .. ") , (" .. currentLoop.bottomleft.x .. ", " .. currentLoop.bottomleft.y .. "), (" .. currentLoop.bottomright.x .. ", " .. currentLoop.bottomright.y .. ")")

      -- Vertical alignment or horizontal alignment
      found = ((cards[i].position.x == currentLoop.topleft.x or cards[i].position.x == currentLoop.topright.x) and
                cards[i].position.y >= currentLoop.topleft.y and cards[i].position.y <= currentLoop.bottomleft.y)
              or
              ((cards[i].position.y == currentLoop.topleft.y or cards[i].position.y == currentLoop.bottomleft.y) and
                cards[i].position.x >= currentLoop.topleft.x and cards[i].position.x <= currentLoop.topright.x)

      if found then
        print("FOUNDED")
        cards[i].currentLoop = currentLoop
      end

    until found or loopIndex >= #tracks  -- EVERY card should be on a loop

    print("Cards : loop = " .. point.toString(cards[i].currentLoop.topleft, 2) .. ", " .. point.toString(cards[i].currentLoop.topright, 2))
  end
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function constructTracks(lines)

  local tracks = {}
  local cards = {}

  -- For each lines in the file
  for i = 1, #lines do
    -- TRACKS
    constructLoop(lines[i], i, tracks, {"/%-", "/%+"}, {"%-\\", "%+\\"})      -- Add new loop to the struct
    constructLoop(lines[i], i, tracks, {"\\%-", "\\%+"}, {"%-/", "%+/"})      -- Close existing loop

    -- CARDS
    findCards(lines[i], i, cards)     -- Add new possible cards
  end

  assignInitialLoopToCards(cards, tracks)

  return tracks, cards
end
------------------------------------------------------------------------
-- Tests
------------------------------------------------------------------------
print("------------------------------------------------------------------------")
print("Tests constructTacks function :")
--constructTracks({ "    /----\\   /------\\    ", "    \\----/   \\-----+/    " })
--constructTracks({ "    /----\\   /------\\    ", "    \\+--+/   \\-----+/    " })
--constructTracks({ "    /----\\   /------\\    ", "    \\+--+/   \\+-----/    " })
--constructTracks({ "    /----\\   /------\\    ", "  /------\\    /-----\\      " , "    \\+--+/   \\------/    " })
--constructTracks({ "tttt----fez---fezf-----------" })

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function findFirstCrash (tracks, cards)
  local tick = 0
  -- Keep going until a crash or reach threshold
  while not crash and tick < 5000000000 do
    -- Iterate over all the cards and make them move thanks to their velocity
    for i = 1, #cards do

    end
    crash = true
    tick = tick + 1
  end

end


------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (inputFile)

  local fileLines = helper.saveLinesToArray(inputFile);

  local tracks = {}
  local cards = {}

  -- Construct the tracks with custom struct
  tracks, cards =  constructTracks(fileLines)

  -- CARDS
  print("NB CARDS FOUND = " .. #cards)
  for i = 1,#cards do
    print("Cards : position = " .. point.toString(cards[i].position, 2) .. ", velocity = " .. point.toString(cards[i].velocity, 2) .. ", loop : " .. point.toString(cards[i].currentLoop.topleft, 2) .. ", " .. point.toString(cards[i].currentLoop.topright, 2) .. ", " .. point.toString(cards[i].currentLoop.bottomleft, 2) .. ", " .. point.toString(cards[i].currentLoop.bottomright, 2))
  end

  -- TRACK
  print("NB LOOP FOUND = " .. #tracks)
  for i = 1,#tracks do
    if tracks[i].bottomleft ~= nil and tracks[i].bottomright ~= nil then
      print("(" .. tracks[i].topleft.x .. ", " .. tracks[i].topleft.y .. "), (" .. tracks[i].topright.x .. ", " .. tracks[i].topright.y .. ") , (" .. tracks[i].bottomleft.x .. ", " .. tracks[i].bottomleft.y .. "), (" .. tracks[i].bottomright.x .. ", " .. tracks[i].bottomright.y .. ")")
    else
      print(tracks[i].bottomleft)
      print(tracks[i].bottomright)
      print("(" .. tracks[i].topleft.x .. ", " .. tracks[i].topleft.y .. "), (" .. tracks[i].topright.x .. ", " .. tracks[i].topright.y .. ")")
    end
  end

  -- Algorithm that will simulate the tick and find the first crash
  findFirstCrash(tracks, cards)

  return 0;
end

------------------------------------------------------------------------
-- partTwo - function used for the part 2
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 2.
------------------------------------------------------------------------
local function partTwo (inputFile)



  return 0;
end


--#################################################################
-- Main - Main function
--#################################################################
function day13Main (filename)
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

day13 = {
  day13Main = day13Main,
}

return day13
