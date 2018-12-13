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
  day8 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function parseTree(nbChild, nbMetadata, tree)
  local metadataSum = 0
  print(nbChild)
  print(nbMetadata)
  if tonumber(nbChild) > 0 then
    for i = 1, nbChild do
      currentMetadataSum, tree = parseTree(tree[1], tree[2], table.move(tree, 3, #tree, 1, {}))
      metadataSum = metadataSum + currentMetadataSum
    end
  end

  -- Collect the sum of metadata
  for i = 1, nbMetadata do
    metadataSum = metadataSum + tree[i]
  end
  print("METADATA = " .. metadataSum)

  return metadataSum, table.move(tree, nbMetadata+1, #tree, 1, {});
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function computeRootNodeValue(nbChild, nbMetadata, tree)
  local metadataSum = 0
  print(nbChild)
  print(nbMetadata)

  local oldtree = tree
  if tonumber(nbChild) > 0 then
    --print("FOUND CHILD")
    local childrenMetadataSum = {}
    for i = 1,nbChild do
      --print("CHILD " .. i)
      currentMetadataSum, tree = computeRootNodeValue(tree[1], tree[2], table.move(tree, 3, #tree, 1, {}))
      print("child value = " .. currentMetadataSum)
      table.insert(childrenMetadataSum, currentMetadataSum)
      print(i)
      print(childrenMetadataSum[i])
    end

    print(#tree)

    -- Collect the sum of metadata
    print("nbMetadata = " .. nbMetadata)
    for i = 1, nbMetadata do
      print("INDEX = " .. tree[i])
      print(childrenMetadataSum[tonumber(tree[i])])
      -- Add child value
      print(childrenMetadataSum[tonumber(tree[i])])
      if childrenMetadataSum[tonumber(tree[i])] ~= nil then
        metadataSum = metadataSum + childrenMetadataSum[tonumber(tree[i])]
      end
    end
  else
    for i = 1, nbMetadata do
      metadataSum = metadataSum + tree[i]
    end
  end

  print("METADATA = " .. metadataSum)

  return metadataSum, table.move(tree, nbMetadata+1, #tree, 1, {});
end

------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (inputFile)

  -- Read the entire file at once.
  linearTree = inputFile:read("*all")

  print(linearTree)

  tree = helper.splitString(linearTree, {" "})

  return parseTree(tree[1], tree[2], table.move(tree, 3, #tree, 1, {}));
end

------------------------------------------------------------------------
-- partTwo - function used for the part 2
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 2.
------------------------------------------------------------------------
local function partTwo (inputFile)

  -- Read the entire file at once.
  linearTree = inputFile:read("*all")

  print(linearTree)

  tree = helper.splitString(linearTree, {" "})

  return computeRootNodeValue(tree[1], tree[2], table.move(tree, 3, #tree, 1, {}));
end


--#################################################################
-- Main - Main function
--#################################################################
function day8Main (filename)
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

day8 = {
  day8Main = day8Main,
}

return day8
