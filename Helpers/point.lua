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
function equalsList(list1, list2)
  if #list1 ~= #list2 then return end
  local equals = true
  for i = 1, #list2 do
    equals = equals and list1[i] == list2[i]
  end
  return equals
end
------------------------------------------------------------------------
-- Tests
------------------------------------------------------------------------
print("|-------------------------------------------|")
print("| Tests equals function for point :         |")
print("|-------------------------------------------|")
print(equalsList({4,8}, {4,8}) == true)
print(equalsList({4,8}, {8,4}) == false)
print(equalsList({0,9}, {0,8}) == false)
print(equalsList({9,0}, {9,0}) == true)
print(equalsList({6,9}, {2,9}) == false)

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function equals(point1, point2, dimension)
  if #point1 ~= #point2 then return end
  if dimension == nil then
    dimension = 2
  end
  local equals = true
  equals = equals and point1.x == point2.x
  equals = equals and point1.y == point2.y
  if dimension == 3 then
    equals = equals and point1.z == point2.z
  end
  return equals
end


------------------------------------------------------------------------
--
------------------------------------------------------------------------
function addList(list1, list2)
  if #list1 ~= #list2 then return end
  local newPoint = list1
  for i = 1, #list2 do
    newPoint[i] = newPoint[i] + list2[i]
  end
  return newPoint
end
------------------------------------------------------------------------
-- Tests
------------------------------------------------------------------------
print("|-------------------------------------------|")
print("| Tests ADD function for list :             |")
print("|-------------------------------------------|")
print(equalsList(addList({6,5}, {0,0}), {6,5}))
print(equalsList(addList({6,5}, {0,0}), {6,5}))
print(equalsList(addList({0,0}, {6,5}), {6,5}))
print(equalsList(addList({2,2}, {2,2}), {4,4}))
print(equalsList(addList({2,2}, {-2,-2}), {0,0}))

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
  equals = equals,
  toString = toString,
}

return point
