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
  day14 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function initCellList(initialList, elfsInitialCellScore)
  local elfs = {}
  local elfId = 1

  local firstCell = nil

  local currentCell = firstCell
  local i = 0
  repeat
    i = i + 1   -- Regular update

    -- Create the next empty node
    local nextCell = {score = initialList[i], previous=nil, next = nil}

    -- Register the cell if it belong to the elf
    if elfsInitialCellScore ~= nil and elfsInitialCellScore[elfId] == nextCell.score then
      table.insert(elfs, {id=elfId, cell=nextCell})
      elfId = elfId + 1
    end

    -- Update the next value with the new created cell
    if i == 1 then
      firstCell = nextCell
    else
      nextCell.previous = currentCell
      currentCell.next = nextCell
    end

    -- Replace the current cell
    currentCell = nextCell

  until i >= #initialList

  -- Link the last cell to the first one to created a circular list
  -- No need anymore
  firstCell.previous = currentCell
  currentCell.next = firstCell
  firstCell.previous = currentCell

  return firstCell, currentCell, i, elfs
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function numberToDigitsArray(number)
  digitsArray = {}

  local digitsLeft = tonumber(number)
  repeat
    -- Create a new ref for the current digit
    table.insert(digitsArray, digitsLeft % 10)

    -- Update the digitLeft to treat
    digitsLeft = digitsLeft // 10
  until digitsLeft == 0

  return digitsArray
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function stringToDigitsArray(stringNumber)
  digitsArray = {}

  local digitsLeft = stringNumber
  for i = 1, #stringNumber do
    -- Create a new ref for the current digit
    table.insert(digitsArray, stringNumber:sub(i,i))
  end

  return digitsArray
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function addNewRecipe(newRecipeNumber, endingCellRef, startingCellRef)
  local digits = numberToDigitsArray(newRecipeNumber)

  -- Iterate on the new array and create cells for the linked list
  for i = #digits,1,-1 do
    newRecipe = {score = digits[i], previous = endingCellRef, next = endingCellRef.next}

    -- Update both end of the circular linked list.
    endingCellRef.next = newRecipe
    startingCellRef.previous = newRecipe

    endingCellRef = newRecipe
  end

  return endingCellRef, #digits
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function addNewRecipeRef(nbRecipes, newRecipeNumber, endingCellRef, startingCellRef, startingCellInput, inputStruct)
  local digits = numberToDigitsArray(newRecipeNumber)

  -- Iterate on the new array and create cells for the linked list
  for i = #digits,1,-1 do

    if tonumber(inputStruct.node.score) ~= tonumber(digits[i]) then
      -- Reset everything...
      inputStruct.node = startingCellInput
      inputStruct.found = false
      inputStruct.index = nbRecipes + (#digits - i) + 1
    end

    -- Check if the score (which need to be added) correspond to our input current node.
    if tonumber(inputStruct.node.score) == tonumber(digits[i]) then
      -- Move on the input linked list
      if inputStruct.node.next == startingCellInput then
        inputStruct.found = true
      else
        inputStruct.node = inputStruct.node.next
      end
    end

    newRecipe = {score = digits[i], previous = endingCellRef, next = endingCellRef.next}

    -- Update both end of the circular linked list.
    endingCellRef.next = newRecipe
    startingCellRef.previous = newRecipe

    endingCellRef = newRecipe
  end

  return endingCellRef, (nbRecipes + #digits), inputStruct
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function printLinkedList(nodeRef, MaxValue, threshold)
  l = nodeRef
  index = 1
  nbValueAdded = 0
  local finalString = ""
  while l and index <= MaxValue do
    if index > tonumber(threshold) and nbValueAdded < 10 then
      finalString = finalString .. l.score
      nbValueAdded = nbValueAdded + 1
    end
    l = l.next
    index = index + 1
  end
  return finalString
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function printLinkedListBack(nodeRef, threshold)
  l = nodeRef
  index = 1
  finalString = ""
  while l and index <= threshold do
    finalString = l.score .. finalString
    l = l.previous
    index = index + 1
  end
  print(finalString)
end


------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - input : int, number of recipes we have to generate before computing the 10 last recipes.
--    - nbElfs : int, number of elfs who participate to the process
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (input, nbElfs)
  local endingCellRef = nil
  local startingCellRef = nil
  local elfs = nil
  local nbRecipes = 0

  -- Create a circular linked list to make easier the loop between the last and the first cell.
  -- The endingCellRef is here to allow adding more recipes.
  startingCellRef, endingCellRef, nbRecipes, elfs = initCellList({3, 7}, {3, 7})

  -- Start the algorithm
  while nbRecipes < input + 10 do
    newRecipeNumber = 0
    -- Compute new recipes
    for i = 1, #elfs do
      newRecipeNumber = newRecipeNumber + elfs[i].cell.score
    end

    endingCellRef, nbRecipeAdded = addNewRecipe(newRecipeNumber, endingCellRef, startingCellRef)
    nbRecipes = nbRecipes + nbRecipeAdded

    -- For each elfs, moved in the scoreboard and pick a new current recipe
    for i = 1, #elfs do
      tempCell = elfs[i].cell

      -- Compute the number of steps
      nbSteps = tempCell.score + 1

      local counter = 0
      repeat
        tempCell = tempCell.next
        counter = counter + 1
      until counter >= nbSteps

      elfs[i].cell = tempCell
    end
  end

  finalString = printLinkedList(startingCellRef, nbRecipes, input)

  print("================================================================")
  print("FINAL PART ONE : " .. finalString)
  print("================================================================")

  return finalString;
end

------------------------------------------------------------------------
-- partTwo - function used for the part 2
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 2.
------------------------------------------------------------------------
local function partTwo (input, nbElfs)
  local endingCellRef = nil
  local startingCellRef = nil
  local elfs = nil

  local nbRecipes = 0

  -- Create a circular linked list to make easier the loop between the last and the first cell.
  -- The endingCellRef is here to allow adding more recipes.
  startingCellRef, endingCellRef, nbRecipes, elfs = initCellList({3, 7}, {3, 7})
  startingCellInput, endingCellInput = initCellList(stringToDigitsArray(input), nil)

  -- Start the algorithm
  local inputStruct = {node=startingCellInput, found=false, index=nbRecipes}

  while (not inputStruct.found) and nbRecipes < 50000000 do

    newRecipeNumber = 0
    -- Compute new recipes
    for i = 1, #elfs do
      newRecipeNumber = newRecipeNumber + elfs[i].cell.score
    end

    endingCellRef, nbRecipes, inputStruct = addNewRecipeRef(nbRecipes, newRecipeNumber, endingCellRef, startingCellRef, startingCellInput, inputStruct)

    -- For each elfs, moved in the scoreboard and pick a new current recipe
    for i = 1, #elfs do
      tempCell = elfs[i].cell

      -- Compute the number of steps
      nbSteps = tempCell.score + 1

      local counter = 0
      repeat
        tempCell = tempCell.next
        counter = counter + 1
      until counter >= nbSteps

      elfs[i].cell = tempCell
    end
  end

  print("================================================================")
  print("FINAL PART TWO : " .. inputStruct.index)
  print("================================================================")

  return inputStruct.index;
end


--#################################################################
-- Main - Main function
--#################################################################
function day14Main (filename)
  local nbElfs = 2

  local puzzleInput1 = 9
  local puzzleInput2 = "51589"

  --local puzzleInput1 = 5
  --local puzzleInput2 = "01245"

  --local puzzleInput1 = 18
  --local puzzleInput2 = "92510"

  --local puzzleInput1 = 2018
  --local puzzleInput2 = "59414"

  --local puzzleInput1 = 074501
  --local puzzleInput2 = "074501"

  local resultPartOne = partOne(puzzleInput1, nbElfs)
  local resultPartTwo = partTwo(puzzleInput2, nbElfs)

  -- Launch and print the final result
  print("Result part one :", resultPartOne);

  -- Launch and print the final result
  print("Result part two :", resultPartTwo);

end

--#################################################################
-- Package end
--#################################################################

day14 = {
  day14Main = day14Main,
}

return day14
