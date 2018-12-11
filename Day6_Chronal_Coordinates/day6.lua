--#################################################################
--# @author: Grégoire Boiron                                      #
--# @date: 12/08/2018                                             #
--#                                                               #
--# Template used for every main script for the day 6 of the AoC  #
--#################################################################

local P = {} -- packages

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  day6 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

------------------------------------------------------------------------
-- computeClosestArea - TODO
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    a list of area which the point belong.
------------------------------------------------------------------------
function computeClosestArea (i, j, areas, currentAreaIndex)
  local finalMinLength = nil

  --print("current Point : (" .. i .. "," .. j .. ")")

  -- Find the closest area for the current point
  finalAreaIndex = {}

  for currentAreaIndex = 1,#areas do
    local currentTotalLength = math.abs(tonumber(areas[currentAreaIndex][1]) - i) + math.abs(tonumber(areas[currentAreaIndex][2]) - j)

    --print("Area center : (" .. areas[currentAreaIndex][1] .. "," .. areas[currentAreaIndex][2] .. ")")

    --if finalMinLength ~= nil then
      --print("Length :" .. currentTotalLength)
    --end

    if finalMinLength == nil then
      -- Init the struct
      finalMinLength = currentTotalLength
      finalAreaIndex = { currentAreaIndex }
    else
      if currentTotalLength == finalMinLength then
        -- Add the area to the struct

        table.insert(finalAreaIndex, currentAreaIndex)
      elseif currentTotalLength < finalMinLength then
        finalMinLength = currentTotalLength;

        -- Reset the struct
        finalAreaIndex = { currentAreaIndex }
      end
    end
  end

  --print("FINAL area : index = " .. finalAreaIndex .. " point : (" .. areas[finalAreaIndex][1] .. "," .. areas[finalAreaIndex][2] .. ")")

  return finalAreaIndex
end

------------------------------------------------------------------------
-- ComputeAreaSize - TODO
-- Params:
--    - areaX : int, y coordinate of the area's center
--    - areaY : int, x coordinate of the area's center
-- Return
--    the area size
------------------------------------------------------------------------
function ComputeAreaSize(areaX, areaY, areas, finalPoints, areaIndex, currentAreaIndex)
  finalSizeArea = 0

  nextPointsX = {}
  nextPointsY = {}
  table.insert(nextPointsX, areaX)
  table.insert(nextPointsY,  areaY+1)

  --for i,point in ipairs(nextPoints) do
  --  print(i, point[1], point[2])
  --end

  --for i,point in ipairs(nextPoints) do
  while nextPoints ~= {} do
    point = {nextPointsX[0], nextPointsY[0]} -- Get the next value

    print(point[1])
    print(point[2])

    print(nextPointsX[0])
    print(nextPointsY[0])

    index = computeClosestArea(point[1], point[2], areas, currentAreaIndex)
    print(index == areaIndex)
    if index == areaIndex then
      print(point[1] .. "," .. point[2])
      -- Update for visualization
      finalPoints[tonumber(point[1])][tonumber(point[2])] = areaIndex

      finalSizeArea = finalSizeArea + 1

      table.remove(nextPointsX, 0)   -- Remove the current point
      table.remove(nextPointsY, 0)   -- Remove the current point

      -- Add the 4 adjacent point from that point
      -- Top point
      if finalPoints[tonumber(point[1])][tonumber(point[2]+1)] ~= "." then
        finalPoints[tonumber(point[1])][tonumber(point[2]+1)] = areaIndex
        table.insert(nextPointsX, tonumber(point[1]))
        table.insert(nextPointsY, tonumber(point[2]+1))

        table.insert(finalPoints, {point[1], point[2]+1})
      end
      -- Bottom point
      --[[
      if finalPoints[tonumber(point[1])][tonumber(point[2]-1)] ~= "." then
        finalPoints[tonumber(point[1])][tonumber(point[2]-1)] = areaIndex
        table.insert(nextPointsX, point[1]))
        table.insert(nextPointsY, point[2]-1)

        table.insert(finalPoints, {point[1], point[2]-1})
      end
      -- Left point
      if finalPoints[tonumber(point[1]-1)][tonumber(point[2])] ~= "." then
        finalPoints[tonumber(point[1]-1)][tonumber(point[2])] = areaIndex
        table.insert(nextPointsX, point[1]-1))
        table.insert(nextPointsY, point[2])

        table.insert(finalPoints, {point[1]-1, point[2]})
      end
      -- Right point
      if finalPoints[tonumber(point[1]+1)][tonumber(point[2])] ~= "." then
        finalPoints[tonumber(point[1]+1)][tonumber(point[2])] = areaIndex
        table.insert(nextPointsX, point[1]+1))
        table.insert(nextPointsY, point[2])

        table.insert(finalPoints, {point[1]+1, point[2]})
      end
      --]]
    else
      print("ENDDDD")
    end

    for i,point in ipairs(nextPoints) do
      print(i, point[1], point[2])
    end

  end

  return finalSizeArea, finalPoints
end

------------------------------------------------------------------------
-- printVisualization - TODO
-- Params:
--    - MaxX : int, x max coordinate of the set of points.
--    - MaxY : int, y max coordinate of the set of points.
--    - areas : {}, list of areas points.
--    - removedAreas : {}, list of areas that are considered removed.
------------------------------------------------------------------------
function printVisualization(MaxX, MaxY, areas, removedAreas)
  file = io.open("Day6_Chronal_Coordinates/visualization.txt", "w");
  io.output(file);

  for y = 1,MaxY do
    for x = 1,MaxX do
      local found = false
      local index = nil
      for currentAreaIndex = 1,#areas do
        if x == tonumber(areas[currentAreaIndex][1]) and y == tonumber(areas[currentAreaIndex][2]) then
          found = true
          index = currentAreaIndex
        end
      end
      if found then
        if removedAreas[index] then
          io.write("@");
        else
          io.write(index);
        end
      else
        io.write(".");
      end
    end
    io.write("\n");
  end
  io.close(file);
end

------------------------------------------------------------------------
-- printVisualization - TODO
-- Params:
--    - MaxX : int, x max coordinate of the set of points.
--    - MaxY : int, y max coordinate of the set of points.
--    - areas : {}, list of areas points.
--    - removedAreas : {}, list of areas that are considered removed.
------------------------------------------------------------------------
function printVisualizationMatrix(finalPoints, i)
  file = io.open("Day6_Chronal_Coordinates/visualization" .. i .. ".txt", "w");
  io.output(file);

  for x = 1,#finalPoints do
    for y = 1,#finalPoints[x] do
      if finalPoints[x][y] == nil then
        io.write("+" .. "XX" .. "+");
      elseif tonumber(finalPoints[x][y]) >= 10 then
        io.write("-" .. finalPoints[x][y] .. "-");
      else
        io.write("-" .. finalPoints[x][y] .. "--");
      end
    end
    io.write("\n");
  end

  io.close(file);
end


function removeInfiniteArea(i, j, area, currentAreaIndex, removedAreas)
  index = computeClosestArea(i, j, areas, currentAreaIndex)
  -- Tag the arrow that contains that point.
  for i, v in ipairs(index) do
    print(i, v)
    if not removedAreas[v] then
      removedAreas[v] = true
    end
  end
end

------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
function partOne (inputFile)
  local areas = {}
  local removedAreas = helper.Set{};
  local areasIndex = {}
  local coordinates = {}
  local points = helper.saveLinesToArray(inputFile)

  local MaxX = 0;
  local MaxY = 0;

  for i = 1,#points do
    areas[i] = helper.splitString(points[i], {", ", "\n"})

    table.insert(areasIndex, i)

    if MaxX < tonumber(areas[i][1]) then
      MaxX = tonumber(areas[i][1])
    end
    if MaxY < tonumber(areas[i][2]) then
      MaxY = tonumber(areas[i][2])
    end
  end

  -- Now we have a full rectangle, tag the border of it to remove infinite areas.

  local finalAreaIndex = 0

  -- TOP side.
  local j = 1;
  for i=1,MaxX do
    removeInfiniteArea(i, j, area, currentAreaIndex, removedAreas)
  end

  -- BOTTOM side
  local j = MaxY;
  for i=1,MaxX do
    removeInfiniteArea(i, j, area, currentAreaIndex, removedAreas)
  end

  -- RIGHT side
  local i = MaxX;
  for j=1,MaxY do
    removeInfiniteArea(i, j, area, currentAreaIndex, removedAreas)
  end

  -- LEFT side
  local i = 1;
  for j=1,MaxY do
    removeInfiniteArea(i, j, area, currentAreaIndex, removedAreas)
  end

  -- Print in file the result
  printVisualization(MaxX, MaxY, areas, removedAreas)

  finalPoints = {}  -- create the matrix
  for i=1,MaxX do
    finalPoints[i] = {}     -- create a new row
    for j=1,MaxY do
      finalPoints[i][j] = "."
    end
  end

  largestAreaSize = 0
  --[[
  -- WIP
  -- For all the areas left (should be finite), we compute their area.
  for i=1,#areas do
    if removedAreas[i] then
      print("ELIMINATED : Index = " .. i .. ", Point = (" .. areas[i][1] .. "," .. areas[i][2] .. ")")
    else
      -- Compute all the point for this area and increment a number
      currentAreaSize, finalPoints = ComputeAreaSize(areas[i][1], areas[i][2]+1, areas, finalPoints, i, currentAreaIndex)
      currentAreaSize, finalPoints = ComputeAreaSize(areas[i][1], areas[i][2]-1, areas, finalPoints, i, currentAreaIndex)
      currentAreaSize, finalPoints = ComputeAreaSize(areas[i][1]-1, areas[i][2], areas, finalPoints, i, currentAreaIndex)
      currentAreaSize, finalPoints = ComputeAreaSize(areas[i][1]+1, areas[i][2], areas, finalPoints, i, currentAreaIndex)

      -- Print in file the result
      printVisualizationMatrix(finalPoints, i)

      print("Final area size = " .. currentAreaSize .. ", for area = (" .. areas[i][1] .. "," .. areas[i][2] .. ")")
    end

    if currentAreaSize > largestAreaSize then
      largestAreaSize = currentAreaSize
    end
  end
  -- end WIP
  --]]

  finalAreas = {}

  for i=1,#areas do
    finalAreas[i] = 0;
  end

  for i=1,MaxX do
    for j=1,MaxY do

      -- Assign this point to a zone
      index = computeClosestArea(i, j, areas, currentAreaIndex)

      -- Increment the struct
      if #index == 1 then
        finalAreas[index[1]] = finalAreas[index[1]] + 1

        finalPoints[i][j] = index[1]
      else
        finalPoints[i][j] = nil
      end
    end
  end

  largestAreaSize = 0
  largestAreaIndex = nil
  for index=1,#areas do
    if not removedAreas[index] then
      if largestAreaSize < finalAreas[index] then
        largestAreaSize = finalAreas[index];
        largestAreaIndex = index
      end
      finalAreas[i] = 0;
    end
  end

  print("INDEX " .. largestAreaIndex)

  -- Print in file the result
  printVisualizationMatrix(finalPoints, 0)

  return largestAreaSize;
end
----
--
--
-------
function computeGridPoint (refX, refY, x, y, array1, array2, areas)
  print(tonumber(x))

  finalPoints[x][y] = finalPoints[refX][refY] + tonumber(#array1) - tonumber(#array2)
  print(array2[arrayIndex])
  for arrayIndex = 1,#array2 do
    if array2[arrayIndex] ~= nil then
      if tonumber(x) <= tonumber(areas[array2[arrayIndex]][1]) then

        table.remove(array2, index)
        table.insert(array1, index)
        finalPoints[x][y] = finalPoints[x][y] - 1
      end
    end
  end

  return finalPoints[x][y], array1, array2
end

------------------------------------------------------------------------
-- partTwo - function used for the part 2
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 2.
------------------------------------------------------------------------
function partTwo (inputFile)
  local areas = {}
  local finalAreaSize = 0
  local areasIndex = {}

  local MaxX = 0;
  local MaxY = 0;
  local points = helper.saveLinesToArray(inputFile)

  for i = 1,#points do
    areas[i] = helper.splitString(points[i], {", ", "\n"})

    table.insert(areasIndex, i)

    if MaxX < tonumber(areas[i][1]) then
      MaxX = tonumber(areas[i][1])
    end
    if MaxY < tonumber(areas[i][2]) then
      MaxY = tonumber(areas[i][2])
    end
  end

  --print(MaxX)
  --print(MaxY)

  -- Init the matrix
  finalPoints = {}  -- create the matrix
  for i=1,MaxX do
    finalPoints[i] = {}     -- create a new row
    for j=1,MaxY do
      finalPoints[i][j] =  0
    end
  end

  -- Take the middle point
  local halfMaxX= math.floor(MaxX / 2)
  local halfMaxY = math.floor(MaxY / 2)

  --print("X" .. halfMaxX)
  --print("Y" .. halfMaxY)

  -- Compute the distance from all the area center.
  -- Register all the point in cardinals arrays
  local left = {}
  local right = {}
  local bottom = {}
  local top = {}

  for index=1,#areas do
    finalPoints[halfMaxX][halfMaxY] = finalPoints[halfMaxX][halfMaxY] + math.abs(halfMaxX - areas[index][1]) + math.abs(halfMaxY - areas[index][2]);
    if tonumber(areas[index][1]) < halfMaxX then
      table.insert(left, index)
    elseif tonumber(areas[index][1]) > halfMaxX then
      table.insert(right, index)
    end
    if tonumber(areas[index][2]) > halfMaxY then
      table.insert(bottom, index)
    elseif tonumber(areas[index][2]) < halfMaxY then
      table.insert(top, index)
    end
  end

  --print("DEBUG :" ..  areas[35][1] .. "," .. areas[35][2])

  print(finalPoints[halfMaxX][halfMaxY])

  if finalPoints[halfMaxX][halfMaxY] < 10000 then
    finalAreaSize = finalAreaSize + 1
  end

  print(finalPoints[halfMaxX][halfMaxY])

  print("LEFT")
  print(#left)

  print("RIGHT")
  print(#right)

  print("TOP")
  print(#top)

  print("BOTTOM")
  print(#bottom)

  -- Compute his 4 neighbors.
  -- Left
  --finalPoints[halfMaxX-1][halfMaxY] = computeGridPoint(halfMaxX, halfMaxY, halfMaxX-1, halfMaxY, right, left, areas)

  --print(tonumber(halfMaxX-1))
  --finalPoints[halfMaxX-1][halfMaxY] = finalPoints[halfMaxX][halfMaxY] + tonumber(#right) - tonumber(#left)
  --for leftIndex = 1,#left do
  --  if tonumber(halfMaxX-1) <= tonumber(areas[left[leftIndex]][1]) then
  --    print("REMOVE" .. tonumber(areas[left[leftIndex]][1]))
  --    table.remove(left, index)
  --    finalPoints[halfMaxX-1][halfMaxY] = finalPoints[halfMaxX-1][halfMaxY] - 1
  --  end
  --end

  print("Left Point" .. finalPoints[halfMaxX-1][halfMaxY])

  print(#left)
  print(#right)

  -- Left
  --finalPoints[halfMaxX+1][halfMaxY], left, right = computeGridPoint(halfMaxX, halfMaxY, halfMaxX+1, halfMaxY, left, right, areas)

  --finalPoints[halfMaxX+1][halfMaxY] = finalPoints[halfMaxX][halfMaxY] - tonumber(#right) + tonumber(#left)
  --for rightIndex = 1,#right do
  --  if tonumber(halfMaxX+1) >= tonumber(areas[right[rightIndex]][1]) then
  --    print("REMOVE" .. tonumber(areas[right[rightIndex]][1]))
  --    table.remove(right, index)
  --    finalPoints[halfMaxX+1][halfMaxY] = finalPoints[halfMaxX+1][halfMaxY] - 1
  --  end
  --end

  print("Right Point" .. finalPoints[halfMaxX+1][halfMaxY])

  for index=1,#areas do
    --finalPoints[halfMaxX-1][halfMaxY] = finalPoints[halfMaxX-1][halfMaxY] + math.abs(halfMaxX-1 - areas[index][1]) + math.abs(halfMaxY-1 - areas[index][2]);
    -- Update the struct
    if left[index] ~= nil and tonumber(areas[index][1]) == halfMaxX-1 then
      table.remove(left, index)
    elseif right[index] ~= nil and tonumber(areas[index][1]) == halfMaxX-1 then
      table.remove(right, index)
    end
  end

  if finalPoints[halfMaxX-1][halfMaxY] < 10000 then
    finalAreaSize = finalAreaSize + 1
  end

  print(finalPoints[halfMaxX-1][halfMaxY])

  -- foreach point in the grid
  -- Maybe later
  finalAreaSize = 0
  for i=1,MaxX do
    for j=1,MaxY do
      for index=1,#areas do
        finalPoints[i][j] = finalPoints[i][j] + math.abs(i - areas[index][1]) + math.abs(j - areas[index][2]);
      end
      if finalPoints[i][j] < 10000 then
        finalAreaSize = finalAreaSize + 1
      end
    end
  end

    -- Does this point should be included in the area

  return finalAreaSize;
end


--#################################################################
-- Main - Main function
--#################################################################
function day6Main (filename)
  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  -- Launch and print the final result
  --print("Result part one :", partOne(inputFile));

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

day6 = {
  day6Main = day6Main,
}

return day6
