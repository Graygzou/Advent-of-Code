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

    print("DEBUG" .. i .. ", " .. initialList[i])

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

  --[[
  print("la" .. firstCell.score)
  print("la" .. firstCell.next.score)
  print("la" .. firstCell.next.next.score)
  print("la" .. firstCell.next.next.next.score)

  print("lu" .. firstCell.score)
  print("lu" .. firstCell.previous.score)
  print("lu" .. firstCell.previous.previous.score)
  print("lu" .. firstCell.previous.previous.previous.score)

  print("lo" .. currentCell.next.score)
  print("lo" .. currentCell.next.next.score)
  print("lo" .. currentCell.next.next.next.score)


  print("li" .. currentCell.previous.score)
  print("li" .. currentCell.previous.previous.score)
  print("li" .. currentCell.previous.previous.previous.score)
  --]]


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

    --print(digitsLeft % 10)

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
function addNewRecipeRef(newRecipeNumber, endingCellRef, startingCellRef, startingCellInput, furtherEqualRef)
  local found = false
  local digits = numberToDigitsArray(newRecipeNumber)

  -- Iterate on the new array and create cells for the linked list
  for i = #digits,1,-1 do

    --print("AAAH", furtherEqualRef.score, digits[i])

    -- Check if the score added correspond to our input
    if tonumber(furtherEqualRef.score) == tonumber(digits[i]) then
      --print("EQUALS !")
      -- Move on the input linked list
      if furtherEqualRef.next == startingCellInput then
        --print("WE DID IT !!!!")
        found = true
      else
        --print("ALMOST THERE !")
        furtherEqualRef = furtherEqualRef.next
      end
    else
      -- Reset everything...
      furtherEqualRef = startingCellInput

      -- Test once again..
      if tonumber(furtherEqualRef.score) == tonumber(digits[i]) then
        --print("EQUALS !")
        -- Move on the input linked list
        if furtherEqualRef.next == startingCellInput then
          --print("WE DID IT !!!!")
          found = true
        else
          --print("ALMOST THERE !")
          furtherEqualRef = furtherEqualRef.next
        end
      end
    end

    newRecipe = {score = digits[i], previous = endingCellRef, next = endingCellRef.next}

    -- Update both end of the circular linked list.
    endingCellRef.next = newRecipe
    startingCellRef.previous = newRecipe

    endingCellRef = newRecipe
  end

  return endingCellRef, #digits, furtherEqualRef, found
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
      if nbValueAdded == 0 then
        print("RESULT PART TWO : " .. index-1)
      end
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
  local cells = nil
  local elfs = nil
  local nbRecipes = 0

  -- Create a circular linked list to make easier the loop between the last and the first cell.
  -- The endingCellRef is here to allow adding more recipes.
  startingCellRef, endingCellRef, nbRecipes, elfs = initCellList({3, 7}, {3, 7})

  --- DEBUG CELLS LIST ---
  --printLinkedList(endingCellRef, 10)

  -- DEBUG ELFS
  -- [[
  print("ELFS")
  for i = 1, #elfs do
    print(elfs[i].id .. ", " .. elfs[i].cell.score)
  end
  --]]

  print("END")

  -----------------------
  -- An elf only require the cell to compute everything
  -- (can get the previous score and know the index he's on)
  --for i = 1,nbElfs do
  --  table.insert(elfs, {cell = cells[i]})
  --end
  -----------------------

  -- Start the algorithm
  while nbRecipes < (input) + 10 do
    newRecipeNumber = 0
    -- Compute new recipes
    for i = 1, #elfs do
      --print(elfs[i].cell.score)
      newRecipeNumber = newRecipeNumber + elfs[i].cell.score
    end

    --print("DEBUG VALUE " .. newRecipeNumber)

    endingCellRef, nbRecipeAdded = addNewRecipe(newRecipeNumber, endingCellRef, startingCellRef)

    nbRecipes = nbRecipes + nbRecipeAdded

    --- DEBUG CELLS LIST ---
    --printLinkedList(endingCellRef, 20)

    -- For each elfs, moved in the scoreboard and pick a new current recipe
    for i = 1, #elfs do
      tempCell = elfs[i].cell

      -- Compute the number of steps
      nbSteps = tempCell.score + 1

      --print("ELF " .. i .. ", STEPS = " .. nbSteps)

      local counter = 0
      repeat
        tempCell = tempCell.next
        counter = counter + 1
      until counter >= nbSteps

      elfs[i].cell = tempCell
      --print("ELF " .. i .. ", NEW SCORE = " .. elfs[i].cell.score)
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
  local cells = nil
  local elfs = nil

  local nbRecipes = 0

  -- Create a circular linked list to make easier the loop between the last and the first cell.
  -- The endingCellRef is here to allow adding more recipes.
  startingCellRef, endingCellRef, nbRecipes, elfs = initCellList({3, 7}, {3, 7})

  temp = stringToDigitsArray(input)

  print("DEBUG")
  for i = 1,#temp do
    print(temp[i])
  end

  startingCellInput, endingCellInput = initCellList(stringToDigitsArray(input), nil)

  local finalString = printLinkedList(startingCellInput, 6, 0)

  -- Start the algorithm
  local furtherEqualRef = startingCellInput

  found = false

  while not found and nbRecipes < 50000000 do

    newRecipeNumber = 0
    -- Compute new recipes
    for i = 1, #elfs do
      newRecipeNumber = newRecipeNumber + elfs[i].cell.score
    end

    endingCellRef, nbRecipeAdded, furtherEqualRef, found = addNewRecipeRef(newRecipeNumber, endingCellRef, startingCellRef, startingCellInput, furtherEqualRef)
    nbRecipes = nbRecipes + nbRecipeAdded

    --print("TEMPFOUND = ", found)

    -- For each elfs, moved in the scoreboard and pick a new current recipe
    for i = 1, #elfs do
      tempCell = elfs[i].cell

      -- Compute the number of steps
      nbSteps = tempCell.score + 1

      --print("ELF " .. i .. ", STEPS = " .. nbSteps)

      local counter = 0
      repeat
        tempCell = tempCell.next
        counter = counter + 1
      until counter >= nbSteps

      elfs[i].cell = tempCell
      --print("ELF " .. i .. ", NEW SCORE = " .. elfs[i].cell.score)
    end
  end

  --finalString = printLinkedList(startingCellRef, 19, 9)

  print("@@@@@@@@@@@@@@@@@@@@@@@")
  print(nbRecipes)
  print(endingCellRef.next == startingCellInput)
  print(endingCellRef.next.score)
  print(startingCellInput.score)
  print("@@@@@@@@@@@@@@@@@@@@@@@")

  printLinkedListBack(endingCellRef, 10)

  print("================================================================")
  print("FINAL PART TWO : " .. nbRecipes - #input)
  print("================================================================")

  return nbRecipes - #input;
end


--#################################################################
-- Main - Main function
--#################################################################
function day14Main (filename)
  -- Tests
  --local puzzleInput = 9
  --local puzzleInput = 5
  --local puzzleInput = 18
  --local puzzleInput = 2018

  -- Final
  --local puzzleInput = 074501
  --local nbElfs = 2

  --local resultPartOne = partOne(puzzleInput, nbElfs)


  -- Tests
  --local puzzleInput = "51589"
  --local puzzleInput = "01245"
  --local puzzleInput = "92510"
  --local puzzleInput = "59414"

  -- Final
  local puzzleInput = "074501"

  local resultPartTwo = partTwo(puzzleInput, nbElfs)

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
