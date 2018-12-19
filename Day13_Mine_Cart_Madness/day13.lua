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
  temps = {}

  for i = 1, #symbols do
    temps[i] = currentLine:sub(index, sizeLine):find(symbols[i])
    if temps[i] ~= nil then
      if finalRes ~= nil then
        finalRes = math.min(finalRes, temps[i])
      else
        finalRes = temps[i]
      end
    end
  end

  --temp1 = currentLine:sub(index, sizeLine):find(symbols[1])
  --temp2 = currentLine:sub(index, sizeLine):find(symbols[2])
  --if temp1 ~= nil or temp2 ~= nil then
  --  if temp1 == nil and temp2 ~= nil then
  --    finalRes = temp2
  --  elseif temp2 == nil and temp1 ~= nil then
  --    finalRes = temp1
  --  else
  --    finalRes = math.min(temp1, temp2)
  --  end
  --end

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

    --print(startingLoop)

    if startingLoop ~= nil then
      index = index + select(1, startingLoop)
      local startingIndex = index   -- x variable top-left
      startingIndex = startingIndex - 2

      --print(startingLoop)
      --print("CURRENT STARTING", currentLine:sub(index, #currentLine))

      -- Find the first char representing the TOP RIGHT of the loop
      endingLoop = findNextSymbol(currentLine, index, #currentLine, endingSymbols)

      if endingLoop ~= nil then
        index = index + select(1, endingLoop)
        endingIndex = index   -- x variable top-right
        endingIndex = endingIndex - 1

        -- print(endingLoop)
        -- print("CURRENT ENDING", currentLine:sub(index, #currentLine))

        local found = false
        for i = 1, #tracks do
          if tracks[i].topleft.y == 33 then
            print(tracks[i].topleft.y)
            print(startingIndex)
            print(tracks[i].topright.y)
            print(endingIndex)
          end

          if tracks[i].topleft.x == startingIndex and tracks[i].topright.x == endingIndex then
            --print("MATCH !")
            found = true        -- Update the boolean
            tracks[i].bottomleft = point.new{startingIndex, lineIndex-1}
            tracks[i].bottomright = point.new{endingIndex, lineIndex-1}
          end
        end

        if not found then
          -- Insert the new loop
          table.insert(tracks, {
            topleft = point.new{startingIndex, lineIndex-1},
            topright = point.new{endingIndex, lineIndex-1},
            bottomleft = nil,
            bottomright = nil,
            junctions = {}
          })
        end

        --print(startingLoop)
        --print(index)
      end
    end
  until startingLoop == nil or index >= #currentLine

  -- TODO assign junction points to the loop (both loop contains 1 junction point)

end

------------------------------------------------------------------------
-- Add a card if found on the line
-- A card is composed by a velocity, an int nextTurn (contains the info to guide him when finding junctions)
-- a current position (could store a list of already visited cells instead..), a current cell the card is on and the future junction the card will meet
------------------------------------------------------------------------
function addCards(currentLine, cards, coordY, cardDirection, velocity)
  local index = 1
  local coordXCard = nil
  repeat
    coordXCard = currentLine:sub(index, #currentLine):find(cardDirection)
    if coordXCard ~= nil then
      -- Add the found card to the struct (nextTurn = 0 mean he will turn left)
      table.insert(cards, {position=point.new{index+coordXCard-2, coordY}, velocity = point.new(velocity), nextTurn=0, currentLoop=nil, nextJunction=nil})

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
function isCardOnLoop(position, velocity, currentLoop)
  return ((position.x == currentLoop.topleft.x or position.x == currentLoop.topright.x) and
            position.y >= currentLoop.topleft.y and position.y <= currentLoop.bottomleft.y and
            (point.equals(velocity, {x=0, y=-1}) or point.equals(velocity, {x=0, y=1})))
          or
          ((position.y == currentLoop.topleft.y or position.y == currentLoop.bottomleft.y) and
            position.x >= currentLoop.topleft.x and position.x <= currentLoop.topright.x and
            (point.equals(velocity, {x=-1, y=0}) or point.equals(velocity, {x=1, y=0})))
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function isPointOnLoop(point, currentLoop)
  -- Vertical alignment
  verticalAlignment = ((point.x == currentLoop.topleft.x or point.x == currentLoop.topright.x) and
    ((point.y >= currentLoop.topleft.y and currentLoop.bottomleft == nil and currentLoop.bottomright == nil) or
    (point.y >= currentLoop.topleft.y and (currentLoop.bottomleft ~= nil and point.y <= currentLoop.bottomleft.y or currentLoop.bottomright ~= nil and point.y <= currentLoop.bottomright.y))))

  -- Horizontal alignment
  horizontalAlignment = ((point.y == currentLoop.topleft.y or (currentLoop.bottomleft ~= nil and point.y == currentLoop.bottomleft.y) or
   (currentLoop.rightleft ~= nil and point.y == currentLoop.rightleft.y)) and point.x >= currentLoop.topleft.x and point.x <= currentLoop.topright.x)

  return verticalAlignment or horizontalAlignment
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function assignLoopToCards(cards, tracks)
  -- For each card provided
  for i = 1, #cards do
    local found = false
    local loopIndex = 0

    print("Cards : position = " .. point.toString(cards[i].position, 2))

    repeat
      loopIndex = loopIndex + 1

      -- Retrieve the current loop
      print(loopIndex)
      local currentLoop = tracks[loopIndex]

      --print("(" .. currentLoop.topleft.x .. ", " .. currentLoop.topleft.y .. "), (" .. currentLoop.topright.x .. ", " .. currentLoop.topright.y .. ") , (" .. currentLoop.bottomleft.x .. ", " .. currentLoop.bottomleft.y .. "), (" .. currentLoop.bottomright.x .. ", " .. currentLoop.bottomright.y .. ")")

      -- Vertical alignment or horizontal alignment
      found = isCardOnLoop(cards[i].position, cards[i].velocity, currentLoop)
      if found then
        --print("FOUNDED")
        cards[i].currentLoop = currentLoop
      end

    until found or loopIndex >= #tracks  -- EVERY card should be on a loop

    print("Cards : loop = " .. point.toString(cards[i].currentLoop.topleft, 2) .. ", " .. point.toString(cards[i].currentLoop.topright, 2))
  end
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function addJunctions(currentLine, coordY, tracks)
  local index = 1
  repeat
    -- Find the first char representing the TOP LEFT of the loop
    junctionIndex = findNextSymbol(currentLine, index, #currentLine, {"%+"})

    print(junctionIndex)

    if junctionIndex ~= nil then
      index = index + select(1, junctionIndex)
      junctionIndex = index - 2

      currentPoint = point.new{junctionIndex, coordY-1}

      print(junctionIndex .. ", " .. coordY-1)

      -- Find the loop the junction belong to
      i = 1
      found = 0
      while i <= #tracks and found < 2 do
        --print("DEBUG 1: " .. tracks[i].topleft.x .. ", " .. tracks[i].topleft.y)
        --print("DEBUG 2: " .. tracks[i].topright.x .. ", " .. tracks[i].topright.y)
        --print(isPointOnLoop(currentPoint , tracks[i]))
        if isPointOnLoop(currentPoint , tracks[i]) then
          found = found + 1
          -- Add the junction as part of the both loop it intersects.
          table.insert(tracks[i].junctions, currentPoint)
          print("---------------------------")
          --print("POINT :" .. point.toString)
        end
        i = i + 1
      end
    end
  until junctionIndex == nil or index >= #currentLine

  print("EEEEEEEEND")
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

    -- JUNCTIONS
    addJunctions(lines[i], i, tracks)      -- Register junctions (which are everything except straight roads)
  end

  assignLoopToCards(cards, tracks)

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
function isCellJunction(position, cells)
  local found = false
  local i = 1
  while i <= #cells and not found do
    found = point.equals(position, cells[i])
    i = i + 1
  end
  return found
end

------------------------------------------------------------------------
-- Return a in based on the border edge
-- 1 : top left
-- 2 : top right
-- 3 : bottom right
-- 4 : bottom left
-- nil : the cell is not a border edge
------------------------------------------------------------------------
function isCellBorderEdge(position, loop)
  return point.equals(position, loop.topleft) or point.equals(position, loop.topright) or point.equals(position, loop.bottomleft) or point.equals(position, loop.bottomright)
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function findFirstCrash (tracks, cards)
  local finalPosition = nil
  local crash = false
  local tick = 1

  -- Keep going until a crash or reach threshold
  while not crash and tick <= 1000000 do
    print("*****TICK " .. tick)

    -- Iterate over all the cards and make them move thanks to their velocity
    for i = 1, #cards do
      -- Apply the velocity and update the current position
      cards[i].position = point.add(cards[i].position, cards[i].velocity, 2)

      print("Card " .. i .. " Position = " .. point.toString(cards[i].position) .. " Velocity = " .. point.toString(cards[i].velocity))

      -- Check, in the current loop, if we meet a junction or not
      if isCellJunction(cards[i].position, cards[i].currentLoop.junctions) then
        print("JUNCTIOOOONS")
        print(cards[i].nextTurn)
        -- Check where the card have to go based on his nextTurn and update his velocity
        if cards[i].nextTurn == 0 then
          print("LEFT")
          -------------------
          -- TURN LEFT
          -------------------
          if point.equals(cards[i].velocity, {x=0, y=-1}) or point.equals(cards[i].velocity, {x=0, y=1}) then
            cards[i].velocity = point.new{cards[i].velocity.y, cards[i].velocity.x}
          else
            cards[i].velocity = point.new{-cards[i].velocity.y, -cards[i].velocity.x}
          end
        elseif cards[i].nextTurn == 1 then
          -------------------
          -- STRAIGHT
          -------------------
          -- no update
        elseif cards[i].nextTurn == 2 then
          print("RIGHT")
          -------------------
          -- TURN RIGHT
          -------------------
          if point.equals(cards[i].velocity, {x=0, y=-1}) or point.equals(cards[i].velocity, {x=0, y=1}) then
            cards[i].velocity = point.new{-cards[i].velocity.y, cards[i].velocity.x}
              print("ICI 1")
          else
            cards[i].velocity = point.new{cards[i].velocity.y, -cards[i].velocity.x}
              print("ICI 2")
          end
        end
        -- Find the new loop and update the cardLoop
        assignLoopToCards({ cards[i] }, tracks)
        cards[i].nextTurn = (cards[i].nextTurn + 1) % 3

      -- Check, in the current loop, if we meet a border edge
      elseif isCellBorderEdge(cards[i].position, cards[i].currentLoop) then
        print("BORDERRRRR")

        -- Change the velocity of the card
        if point.equals(cards[i].position, cards[i].currentLoop.topleft) then
          cards[i].velocity = point.new{-cards[i].velocity.y, -cards[i].velocity.x}
        elseif point.equals(cards[i].position, cards[i].currentLoop.topright) then
          cards[i].velocity = point.new{cards[i].velocity.y, cards[i].velocity.x}
        elseif point.equals(cards[i].position, cards[i].currentLoop.bottomright) then
          cards[i].velocity = point.new{-cards[i].velocity.y, -cards[i].velocity.x}
        elseif point.equals(cards[i].position, cards[i].currentLoop.bottomleft) then
          cards[i].velocity = point.new{cards[i].velocity.y, cards[i].velocity.x}
        end
      end

    end

    -- Check if there is a collision now
    obsCardindex = 0
    repeat
      obsCardindex = obsCardindex + 1

      i = 1
      while i < #cards and not crash do
        if obsCardindex ~= i then
          crash = point.equals(cards[i].position, cards[obsCardindex].position)

          if crash then
            print("COLLISION !")
            finalPosition = cards[i].position
          end
        end
        i = i + 1
      end
    until crash or obsCardindex >= #cards

    tick = tick + 1
  end

  for i = 1, #cards do
    -- Apply the velocity and update the current position
    print("Card " .. i .. " Position = " .. point.toString(cards[i].position) .. " Velocity = " .. point.toString(cards[i].velocity))
  end

  return finalPosition
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
  --[[
  print("NB CARDS FOUND = " .. #cards)
  for i = 1,#cards do
    print("Cards : position = " .. point.toString(cards[i].position, 2) .. ", velocity = " .. point.toString(cards[i].velocity, 2) .. ", loop : " .. point.toString(cards[i].currentLoop.topleft, 2) .. ", " .. point.toString(cards[i].currentLoop.topright, 2) .. ", " .. point.toString(cards[i].currentLoop.bottomleft, 2) .. ", " .. point.toString(cards[i].currentLoop.bottomright, 2))
  end
  --]]

  -- TRACK
  --[[
  NBJUNCTIONS = 0
  print("NB LOOP FOUND = " .. #tracks)
  for i = 1,#tracks do
    if tracks[i].bottomleft ~= nil and tracks[i].bottomright ~= nil then
      print("(" .. tracks[i].topleft.x .. ", " .. tracks[i].topleft.y .. "), (" .. tracks[i].topright.x .. ", " .. tracks[i].topright.y .. ") , (" .. tracks[i].bottomleft.x .. ", " .. tracks[i].bottomleft.y .. "), (" .. tracks[i].bottomright.x .. ", " .. tracks[i].bottomright.y .. ")")
    else
      print(tracks[i].bottomleft)
      print(tracks[i].bottomright)
      print("(" .. tracks[i].topleft.x .. ", " .. tracks[i].topleft.y .. "), (" .. tracks[i].topright.x .. ", " .. tracks[i].topright.y .. ")")
    end
    print(#tracks[i].junctions)
    for j = 1,#tracks[i].junctions do
      print(point.toString(tracks[i].junctions[j], 2))
      NBJUNCTIONS = NBJUNCTIONS + 1
    end
  end
  print("NUMBER OF JUNCTIONS : " .. NBJUNCTIONS)
  --]]

  -- Algorithm that will simulate the tick and find the first crash
  local collisionPosition = findFirstCrash(tracks, cards)

  if collisionPosition ~= nil then
    print("================================================================")
    print("FINAL : (" .. collisionPosition.x .. ", " .. collisionPosition.y .. ")")
    print("================================================================")
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
