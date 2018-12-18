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
  toString = toString,
}

return point
