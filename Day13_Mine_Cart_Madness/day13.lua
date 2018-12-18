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

  print("GOGOGOGOGO")

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

      --endingLoop = string.find(currentLine:sub(index, #currentLine), endingSymbols[1])

      --if endingLoop == nil then
      --  endingLoop = string.find(currentLine:sub(index, #currentLine), endingSymbols[2])
      --end

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

          if tracks[i].topleft.y == startingIndex and tracks[i].topright.y == endingIndex then
            print("MATCH !")
            found = true        -- Update the boolean
            tracks[i].bottomleft = point.new{lineIndex-1, startingIndex}
            tracks[i].bottomright = point.new{lineIndex-1, endingIndex}
          end
        end

        if not found then
          -- Insert the new loop
          table.insert(tracks, {topleft = point.new{lineIndex-1, startingIndex},
                                topright = point.new{lineIndex-1, endingIndex},
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
--
------------------------------------------------------------------------
function addCards(currentLine, cards, coordX, cardDirection, velocity)
  local index = 1
  local coordYCard = nil
  repeat
    coordYCard = currentLine:sub(index, #currentLine):find(cardDirection)
    if coordYCard ~= nil then
      -- Add the found card to the struct
      table.insert(cards, {velocity = point.new(velocity), path = {point.new{coordX, index + coordYCard - 2}}})

      index = index + coordYCard    --Update the index to move on
    end
  until coordYCard == nil or index >= #currentLine
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

  -- DEBUG CARDS
  print("NB CARDS FOUND = " .. #cards)
  for i = 1,#cards do
    print("Cards : velocity = (" .. cards[i].velocity.x .. "," .. cards[i].velocity.y .. ")")

    pathString = ""
    for j = 1, #cards[i].path do
      pathString = pathString .. point.toString(cards[i].path[j], 2)
    end
    print("Path = " .. pathString)
  end

  -- DEBUG TRACK
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
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (inputFile)

  local fileLines = helper.saveLinesToArray(inputFile);

  -- Construct the tracks with custom struct
  constructTracks(fileLines)

  local loop1 = {topRight = "",
                 topLeft = "",
                 bottomRight = "",
                 bottomLeft = "",
                 junctions = {}}

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
