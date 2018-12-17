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
------------------------------------------------------------------------
function Point(list)
  local point = nil
  if #list == 2 then
    point = {x = list[1], y = list[2]}
  elseif #list == 3 then
    point = {x = list[1], y = list[2], z = list[3]}
  else
    -- Don't care of that case
  end
  return point
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function addNewLoop (currentLine, lineIndex, tracks)
  local index = 1

  repeat
    -- Find the first char representing the TOP LEFT of the loop
    startingLoop = currentLine:sub(index, #currentLine):find("/%-")

    if startingLoop ~= nil then
      index = index + select(1, startingLoop)
      local startingIndex = index-1   -- x variable top-left

      print(startingLoop)
      print("CURRENT STARTING", currentLine:sub(index, #currentLine))

      -- Find the first char representing the TOP RIGHT of the loop
      endingLoop = string.find(currentLine:sub(index, #currentLine), "%-\\")

      if endingLoop ~= nil then
        index = index + select(1, endingLoop)
        endingIndex = index-1   -- x variable top-right

        print(endingLoop)
        print("CURRENT ENDING", currentLine:sub(index, #currentLine))

        table.insert(tracks, {topleft = Point{lineIndex, startingIndex}, topright = Point{lineIndex, endingIndex}, bottomleft = nil, bottomright = nil})

        print(startingLoop)
        --print(lines[i]:find("(%/.*)+"))

        print(index)
      end
    end
  until startingLoop == nil or index >= #currentLine

  for i = 1,#tracks do
    print("(" .. tracks[i].topleft.x .. ", " .. tracks[i].topleft.y .. "), (" .. tracks[i].topright.x .. ", " .. tracks[i].topright.y .. ")")
  end
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function closeExistingLoop (currentLine, lineIndex, tracks)
  local index = 1
  repeat
    -- Find the first char representing the TOP LEFT of the loop
    startingLoop = currentLine:sub(index, #currentLine):find("\\%-")

    print(startingLoop)
    if startingLoop ~= nil then
      index = index + select(1, startingLoop)
      local startingIndex = index-1   -- x variable top-left

      print(startingLoop)
      print("CURRENT STARTING END", currentLine:sub(index, #currentLine))

      -- Find the first char representing the TOP RIGHT of the loop
      endingLoop = string.find(currentLine:sub(index, #currentLine), "%-/")

      if endingLoop ~= nil then
        index = index + select(1, endingLoop)
        endingIndex = index-1   -- x variable top-right

        print(endingLoop)
        print("CURRENT ENDING END", currentLine:sub(index, #currentLine))

        for i = 1, #tracks do
          print(tracks[i].topleft.y)
          print(startingIndex)

          print(tracks[i].topright.y)
          print(endingIndex)
          if tracks[i].topleft.y == startingIndex and tracks[i].topright.y == endingIndex then
            print("MATCH !")
            tracks[i].bottomleft = Point{lineIndex, startingIndex}
            tracks[i].bottomright = Point{lineIndex, endingIndex}
          end
        end

        --print(tracks[i].topleft .. ", " .. tracks[i].topright .. ", " .. tracks[i].bottomleft .. ", " .. tracks[i].bottomright)

        --print(index)
      end
    end
  until startingLoop == nil or index >= #currentLine
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function constructTracks(lines)

  local tracks = {}

  -- For each lines in the file
  for i = 1, #lines do
    -- Add new loop to the struct
    addNewLoop(lines[i], i, tracks)

    --for i = 1,#tracks do
    --  print("(" .. tracks[i].topleft.x .. ", " .. tracks[i].topleft.y .. "), (" .. tracks[i].topright.x .. ", " .. tracks[i].topright.y .. ")")
    --end

    closeExistingLoop(lines[i], i, tracks)

  end

  for i = 1,#tracks do
    print("(" .. tracks[i].topleft.x .. ", " .. tracks[i].topleft.y .. "), (" .. tracks[i].topright.x .. ", " .. tracks[i].topright.y .. ") , (" .. tracks[i].bottomleft.x .. ", " .. tracks[i].bottomleft.y .. "), (" .. tracks[i].bottomright.x .. ", " .. tracks[i].bottomright.y .. ")")
  end
end
------------------------------------------------------------------------
-- Tests
------------------------------------------------------------------------
print("------------------------------------------------------------------------")
print("Tests constructTacks function :")
constructTracks({ "    /----\\   /------\\    ", "    \\----/   \\------/    " })
--constructTracks({ "    /----\\   /------\\    ", "  /------\\    /-----\\      " , "    \\----/   \\------/    " })
constructTracks({ "tttt----fez---fezf-----------" })


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
  constructTacks(fileLines)

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
