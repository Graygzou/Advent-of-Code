local P = {} -- packages

if _REQUIREDNAME == nil then
  helpers = P
else
  _G[_REQUIREDNAME] = P
end

-- Private names
local function private ()
  print("I'm private !");
end

-- Private names
local function dumb ()
  print("I'm dumb !");
  private();
end

-- Let us make abstraction of the namespace prefixe for each function.
helpers = {
  dumb = dumb,
}

return helpers
