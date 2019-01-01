--################################
--# @author: Grégoire Boiron     #
--# @date: 12/08/2018            #
--################################

local P = {} -- packages
local PRINT_TEST = true

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  list = P
else
  _G[_REQUIREDNAME] = P
end

if PRINT_TEST then
  print("|*******************************************|")
  print("|Package LIST : BEGIN TESTS                 |")
  print("|*******************************************|")
end

--#################################################################
-- Private functions
--#################################################################




--#################################################################
-- Public functions
--#################################################################

---------------------------------------
-- Set - function to create set data structure
-- Params:
--    - list : existing (can be empty) list.
-- Return:
--     the set datastructure.
---------------------------------------
function Set (list)
  local set = {};
  for _, l in ipairs (list) do set[l] = true end;
  return set;
end

-----------------------------------------------------
-- Helpers function to execute a bubble sort
-----------------------------------------------------
function bubbleSortList (list, swapFunction, ...)
  local resStruct = list
  local arg = {...}

  for i=#list,1,-1 do
    for j=1,#list-1 do
      if swapFunction(resStruct[j], resStruct[j+1], arg[1]) then
        local temp = resStruct[j];
        resStruct[j] = resStruct[j+1];
        resStruct[j+1] = temp;
      end
    end -- end for 2
  end -- end for 1
  return resStruct;
end

------------------------------------------------------------------------------------
-- Helpers function know if an element is contained into a list
-- Return (true, index) if the element is inside the list, (false, nil) otherwise
------------------------------------------------------------------------------------
function contains(l, element, equalFunction)
  if #l > 0 then
    local found = false
    local finalIndex = nil
    local i = 0

    repeat
      i = i + 1
      if equalFunction == nil then
        found = l[i] == element
      else
        found = equalFunction(l[i], element)
      end
      if found then
        finalIndex = i
      end
    until i >= #l or found
    return found, finalIndex
  else
    return false, nil
  end
end
---------------------------------------------
-- Tests
---------------------------------------------
if PRINT_TEST then
  print("++ Tests contains function ++")
  print(contains({}, 2) == false)
  print(contains({2}, 3) == false)
  print(contains({8}, 8) == true)
  print(contains({8,4,6,2}, 3) == false)
  print(contains({8,4,6,2}, 4) == true)
  print(contains({8,4,6,2}, 2) == true)
  print(contains({8,4,6,2}, 6) == true)
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
if PRINT_TEST then
  print("|-------------------------------------------|")
  print("| Tests ADD function for list :             |")
  print("|-------------------------------------------|")
  print(list.equals(addList({6,5}, {0,0}), {6,5}))
  print(list.equals(addList({6,5}, {0,0}), {6,5}))
  print(list.equals(addList({2,2}, {2,2}), {4,4}))
  print(list.equals(addList({0,0}, {6,5}), {6,5}))
  print(list.equals(addList({2,2}, {-2,-2}), {0,0}))
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function equals(list1, list2)
  if #list1 ~= #list2 then return end
  local isEquals = true
  for i = 1, #list2 do
    isEquals = isEquals and list1[i] == list2[i]
  end
  return isEquals
end
------------------------------------------------------------------------
-- Tests
------------------------------------------------------------------------
if PRINT_TEST then
  print("++ Tests equals function for list ++")
  print(equals({4,8}, {4,8}) == true)
  print(equals({4,8}, {8,4}) == false)
  print(equals({0,9}, {0,8}) == false)
  print(equals({9,0}, {9,0}) == true)
  print(equals({6,9}, {2,9}) == false)
end

------------------------------------------------------------------------
-- Not a deepcopy function.
------------------------------------------------------------------------
function copy(list)
  local newList = {}
  for i = 1,#list do
    newList[i] = list[i]
  end
  return newList
end
if PRINT_TEST then
  print("++ Tests copy function for list ++")
  print(equals(copy({}), {}) == true)
  print(equals(copy({4,8}), {4,8}) == true)
  print(equals(copy({4,8}), {8,4}) == false)
  print(equals(copy({8,4}), {4,8}) == false)
  print(equals(copy({20,15,1005,0,82}), {20,15,1005,0,82}) == true)
end



if PRINT_TEST then
  print("|*******************************************|")
  print("|Package LIST : END TESTS                   |")
  print("|*******************************************|")
end
--#################################################################
-- Package end
--#################################################################

-- Let us make abstraction of the namespace prefixe for each function.
-- All the functions here are public outside the package
list = {
  Set = Set,
  bubbleSortList = bubbleSortList,
  contains = contains,
  equals = equals,
  copy = copy,
}

return list
