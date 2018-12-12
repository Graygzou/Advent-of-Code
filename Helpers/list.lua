--################################
--# @author: Grégoire Boiron     #
--# @date: 12/08/2018            #
--################################

local P = {} -- packages

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  List = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Private functions
--#################################################################

--#################################################################
-- Public functions
--#################################################################

function new ()
  return {first = 0, last = -1}
end

function pushleft (list, value)
  local first = list.first - 1
  list.first = first
  list[first] = value
end

function pushright (list, value)
  local last = list.last + 1
  list.last = last
  list[last] = value
end

function popleft (list)
  local first = list.first
  if first > list.last then return nil end
  local value = list[first]
  list[first] = nil        -- to allow garbage collection
  list.first = first + 1
  return value
end

function popright (list)
  local last = list.last
  if list.first > last then return nil end
  local value = list[last]
  list[last] = nil         -- to allow garbage collection
  list.last = last - 1
  return value
end

function printstack (list)
  for k, v in pairs(list) do
    if k ~= "first" and k ~= "last" then
      print(k .. " => " .. v)
    end
  end
end

function getSize (list)
  local size = 0
  for k, v in pairs(list) do
    if k ~= "first" and k ~= "last" then
      size = size + 1
    end
  end
  return size
end

function sortstack(list)
  tempArray = {}
  local oldIndex = nil
  local oldRes = ""
  for i=getSize(list),1,-1 do
    for k, v in pairs(list) do
      if k ~= "first" and k ~= "last" then
        if oldRes == "" and oldIndex == nil then
          print("--key " .. k .. " , " .. v)
          oldRes = v
          oldIndex = k
        else
          print("OLDkey " .. oldIndex .. " , " .. oldRes)
          print("key " .. k .. " , " .. v)
          if string.byte(oldIndex) < string.byte(v) then
            print("SWAP")
            temp = list[oldIndex]
            list[oldIndex] = v
            list[k] = oldRe
          end
        end
      end
    end
  end
end

--#################################################################
-- Package end
--#################################################################

-- Let us make abstraction of the namespace prefixe for each function.
-- All the functions here are public outside the package
List = {
  new = new,
  pushleft = pushleft,
  pushright = pushright,
  popleft = popleft,
  popright = popright,
  printstack = printstack,
  sortstack = sortstack,
}

return helper
