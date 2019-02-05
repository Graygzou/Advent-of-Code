--################################
--# @author: Grégoire Boiron     #
--# @date: 05/01/2018            #
--################################

local P = {} -- packages
local PRINT_TEST = true

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  set = P
else
  _G[_REQUIREDNAME] = P
end

if PRINT_TEST then
  print("|*******************************************|")
  print("|Package SET : BEGIN TESTS                  |")
  print("|*******************************************|")
end

--#################################################################
-- Private functions
--#################################################################

--#################################################################
-- Public functions
--#################################################################

-----------------------------------------------------
-- Set - function to create set data structure
-- Params:
--    - list : existing (can be empty) list.
-- Return:
--     the set datastructure.
-----------------------------------------------------
function Set (list)
  local set = {};
  for _, l in ipairs (list) do set[l] = true end;
  return set;
end

-----------------------------------------------------
--
-----------------------------------------------------
function addKey(set, key, hash)
  if hash == nil then
    hash = function (x) return x end
  end
  -- Hashed the key in order to be added
  local keyHashed = hash(key)
  -- add the hashedKey to the set
  set[keyHashed] = {key = key}
end

-----------------------------------------------------
--
-----------------------------------------------------
function addKeyValue(set, key, value, hash)
  if hash == nil then
    hash = function (x) return x end
  end
  -- Hashed the key in order to be added
  local keyHashed = hash(key)
  -- add the hashedKey to the set
  set[keyHashed] = {key = key, value = value}
end

-----------------------------------------------------
--
-----------------------------------------------------
function containsKey(set, key, hash)
  if hash == nil then
    hash = function (x) return x end
  end
  -- Hashed the key in order to be added
  local keyHashed = hash(key)
  -- return true if the set contains the key, false otherwise.
  return set[keyHashed] ~= nil
end

-----------------------------------------------------
-- Return :
--      array of the keys of the set
-----------------------------------------------------
function getKeys (s)
  local keyset = {}
  for k,v in pairs(s) do
    table.insert(keyset, k)
  end
  return keyset
end

-----------------------------------------------------
-- Return :
--      array of the values of the set
-----------------------------------------------------
function getValues (s)
  local valueset = {}
  for k,v in pairs(s) do
    table.insert(valueset, v)
  end
  return valueset
end

if PRINT_TEST then
  print("|*******************************************|")
  print("|Package SET : END TESTS                    |")
  print("|*******************************************|")
end
--#################################################################
-- Package end
--#################################################################

-- Let us make abstraction of the namespace prefixe for each function.
-- All the functions here are public outside the package
set = {
  Set = Set,
  addKey = addKey,
  addKeyValue = addKeyValue,
  containsKey = containsKey,
  getKeys = getKeys,
  getValues = getValues,
}

return set
