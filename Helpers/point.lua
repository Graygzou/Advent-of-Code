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
function add(list1, list2)
  if #list1 ~= #list2 then return end
  local newPoint = list1
  for i = 1, #list2 do
    newPoint[i] = newPoint[i] + list2[i]
  end
  return newPoint
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function equals(list1, list2)
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
print("Tests equals function for point : ")
print(equals({4,8}, {4,8}) == true)
print(equals({4,8}, {8,4}) == false)
print(equals({0,9}, {0,8}) == false)
print(equals({9,0}, {9,0}) == true)
print(equals({6,9}, {2,9}) == false)

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function toString(currentPoint, dimension)
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
