--################################
--# @author: Grégoire Boiron     #
--# @date: 12/18/2018            #
--################################

local P = {} -- packages

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  point = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Private functions
--#################################################################

--#################################################################
-- Public functions
--#################################################################

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function new(list)
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
function equals(point1, point2, dimension)
  if #point1 ~= #point2 then return end
  if dimension == nil then
    dimension = 2
  end
  local equals = true
  equals = equals and point1.x == point2.x and point1.y == point2.y
  if dimension == 3 then
    equals = equals and point1.z == point2.z
  end
  return equals
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function add(point1, point2, dimension)
  if #point1 ~= #point2 then return end
  if dimension == nil then
    dimension = 2
  end
  local newPoint = point1
  newPoint.x = newPoint.x + point2.x
  newPoint.y = newPoint.y + point2.y
  if dimension == 3 then
    newPoint.z = newPoint.z + point2.z
  end
  return newPoint
end

-----------------------------------------------------
-- Helpers function to execute a bubble sort
-----------------------------------------------------
function bubbleSortPoints (points, swapFunction, ...)
  local resStruct = points
  local arg = {...}

  for i=#points,1,-1 do
    for j=1,#points-1 do
      if swapFunction(points[j].position, points[j+1].position, arg[1]) then
        local temp = resStruct[j];
        resStruct[j] = resStruct[j+1];
        resStruct[j+1] = temp;
      end
    end -- end for 2
  end -- end for 1
  return resStruct;
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function toString(currentPoint, dimension)
  if dimension == nil then
    dimension = 2
  end
  finalString = ""
  if dimension == 2 then
    finalString = finalString .. "(" .. currentPoint.x .. ", " .. currentPoint.y .. ")"
  elseif dimension == 3 then
    finalString = finalString .. "(" .. currentPoint.x .. ", " .. currentPoint.y .. ", " .. currentPoint.z .. ")"
  end
  return finalString
end

--#################################################################
-- Package end
--#################################################################

-- Let us make abstraction of the namespace prefixe for each function.
-- All the functions here are public outside the package
point = {
  new = new,
  add = add,
  bubbleSortPoints = bubbleSortPoints,
  equals = equals,
  toString = toString,
}

return point
