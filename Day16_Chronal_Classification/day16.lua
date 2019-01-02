--#################################################################
--# @author: Grégoire Boiron                                      #
--# @date: 12/31/2018                                             #
--#                                                               #
--# Template used for every main script for the day 16 of the AoC #
--#################################################################

local P = {} -- packages
local PRINT_TEST = true

--#################################################################
-- Package settings
--#################################################################

if _REQUIREDNAME == nil then
  day16 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (inputFile)

  -- TODO

  return 0;
end

------------------------------------------------------------------------
-- partTwo - function used for the part 2
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 2.
------------------------------------------------------------------------
local function partTwo (inputs, instructions, outputs)

  for i = 1, #inputs do
    print(list.toString(inputs[i]))
    print(list.toString(instructions[i]))
    print(list.toString(outputs[i]))
    print()
  end

  return 0;
end


------------------------------------------------------------------------
--
------------------------------------------------------------------------
function applyArithmeticOpcode(registers, instruction, mode, opcodeFunction, args)
  local A = nil
  local B = nil
  if mode == 0 then
    -- Register mode
    A = tonumber(registers[tonumber(instruction[2])+1])
    B = tonumber(registers[tonumber(instruction[3])+1])
  elseif mode == 1 then
    -- Immediate mode
    A = tonumber(registers[tonumber(instruction[2])+1])
    B = tonumber(instruction[3])
  end
  --print("A = ", A)
  --print("B = ", B)
  registers[tonumber(instruction[4])+1] = opcodeFunction(A, B, args)
  return registers
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function applyAssignmentOpcode(registers, instruction, mode)
  local A = nil
  if mode == 0 then
    -- Register mode
    A = tonumber(registers[tonumber(instruction[2])+1])
  elseif mode == 1 then
    -- Immediate mode
    A = tonumber(instruction[2])
  end
  --print("A = ", A)
  registers[tonumber(instruction[4])+1] = A
  return registers
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function applyComparaisonOpcode(registers, instruction, mode, opcodeFunction)
  local A = nil
  local B = nil
  if mode == 0 then
    -- immediate/register mode
    A = tonumber(instruction[2])
    B = tonumber(registers[tonumber(instruction[3])+1])
  elseif mode == 1 then
    -- register/immediate mode
    A = tonumber(registers[tonumber(instruction[2])+1])
    B = tonumber(instruction[3])
  elseif mode == 2 then
    -- register/register mode
    A = tonumber(registers[tonumber(instruction[2])+1])
    B = tonumber(registers[tonumber(instruction[3])+1])
  end
  --print("A = ", A)
  --print("B = ", B)
  if opcodeFunction(A, B) then
    registers[tonumber(instruction[4])+1] = 1
  else
    registers[tonumber(instruction[4])+1] = 0
  end
  return registers
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function isArithmeticOpcode(regBefore, instruction, regAfter, mode, opcodeFunction, ...)
  local temp = list.copy(regBefore)

  return list.equals(applyArithmeticOpcode(temp, instruction, mode, opcodeFunction, {...}), regAfter, function(a, b)
    return tonumber(a) == tonumber(b)
  end)
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function isAssignmentOpcode(regBefore, instruction, regAfter, mode)
  local temp = list.copy(regBefore)

  return list.equals(applyAssignmentOpcode(temp, instruction, mode), regAfter, function(a, b)
    return tonumber(a) == tonumber(b)
  end)
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function isComparaisonOpcode(regBefore, instruction, regAfter, mode, opcodeFunction)
  local temp = list.copy(regBefore)

  return list.equals(applyComparaisonOpcode(temp, instruction, mode, opcodeFunction), regAfter, function(a, b)
    return tonumber(a) == tonumber(b)
  end)
end

------------------------------------------------------------------------
-- bitwiseOp
--
-- Pre-condition : length(binaryA) == length(binaryB)
------------------------------------------------------------------------
function bitwiseOp (binaryA, binaryB, op)
  local binaryRes = ""
  for i = 1, #binaryA do
    binaryRes = binaryRes .. op(tonumber(binaryA:sub(i,i)), tonumber(binaryB:sub(i,i)))
  end
  return binaryRes
end
------------------------------------------------------------------------
-- Tests
------------------------------------------------------------------------
if PRINT_TEST then
  print("== Tests bitwiseOp function with AND ==")
  print(bitwiseOp("1111", "1111", function (a, b) return a & b; end) == "1111")
  print(bitwiseOp("0101", "0010", function (a, b) return a & b; end) == "0000")
  print(bitwiseOp("0101", "0011", function (a, b) return a & b; end) == "0001")
  print(bitwiseOp("0011", "0010", function (a, b) return a & b; end) == "0010")
  print(bitwiseOp("0110", "1011", function (a, b) return a & b; end) == "0010")
  print(bitwiseOp("0110", "0001", function (a, b) return a & b; end) == "0000")

  print("== Tests bitwiseOp function with OR ==")
  print(bitwiseOp("1111", "1111", function (a, b) return a | b; end) == "1111")
  print(bitwiseOp("0101", "0010", function (a, b) return a | b; end) == "0111")
  print(bitwiseOp("0101", "0011", function (a, b) return a | b; end) == "0111")
  print(bitwiseOp("0010", "1000", function (a, b) return a | b; end) == "1010")
end

------------------------------------------------------------------------
-- binaryProcess
--
------------------------------------------------------------------------
function binaryOperation (a, b, binaryDigitOpe)
  local result = nil
  -- Binary decomposition
  local binaryA = helper.decimalToBinary(a)
  local binaryB = helper.decimalToBinary(b)

  --print("BINARY A", binaryA)
  --print("BINARY B", binaryB)

  -- Apply the binary operation here
  local temp = bitwiseOp(binaryA, binaryB, binaryDigitOpe[1])

  --function (a, b) return a & b; end

  --print("temp", temp)
  --print("temp converted", helper.binaryToDecimal(temp))

  -- Convert and return the result into decimal
  return helper.binaryToDecimal(temp)
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function preprocessing (nbRegisters, inputFile)
  local fileLines = helper.saveLinesToArray(inputFile);

  local resultPartOne = 0

  -- a sample is composed of 1 input, 1 instruction and 1 output.
  local samples = {}

  local inputs = {}
  local instructions = {}
  local outputs = {}

  -- Part 2
  local correspondanceTable = {}
  local truthCounter = {}
  for i = 1, 16 do
    correspondanceTable[i] = nil
    truthCounter[i] = {}
    for j = 1, 16 do
      truthCounter[i][j] = true
    end
  end

  local functionsRef = {
    [1]  = function(r, i) applyArithmeticOpcode(r, i, 0, function (a, b) return a + b; end); end,                                  -- addr
    [2]  = function(r, i) applyArithmeticOpcode(r, i, 1, function (a, b) return a + b; end); end,                                  -- addi
    [3]  = function(r, i) applyArithmeticOpcode(r, i, 0, function (a, b) return a * b; end); end,                                  -- mulr
    [4]  = function(r, i) applyArithmeticOpcode(r, i, 1, function (a, b) return a * b; end); end,                                  -- muli
    [5] = function(r, i) applyArithmeticOpcode(r, i, 0, binaryOperation, function (a, b) return a & b; end); end,                  -- banr
    [6] = function(r, i) applyArithmeticOpcode(r, i, 1, binaryOperation, function (a, b) return a & b; end); end,                  -- bani
    [7] = function(r, i) applyArithmeticOpcode(r, i, 0, binaryOperation, function (a, b) return a | b; end); end,                  -- borr
    [8] = function(r, i) applyArithmeticOpcode(r, i, 1, binaryOperation, function (a, b) return a | b; end); end,                  -- bori
    [9] = function(r, i) applyAssignmentOpcode(r, i, 0); end,                                                                      -- setr
    [10] = function(r, i) applyAssignmentOpcode(r, i, 1); end,                                                                     -- seti
    [11]  = function(r, i, m, f, a) applyComparaisonOpcode(r, i, 0, function (a, b) return tonumber(a) < tonumber(b); end); end,   -- gtir
    [12]  = function(r, i, m, f, a) applyComparaisonOpcode(r, i, 1, function (a, b) return tonumber(a) < tonumber(b); end); end,   -- gtri
    [13]  = function(r, i, m, f, a) applyComparaisonOpcode(r, i, 2, function (a, b) return tonumber(a) < tonumber(b); end); end,   -- gtrr
    [14]  = function(r, i, m, f, a) applyComparaisonOpcode(r, i, 0, function (a, b) return tonumber(a) == tonumber(b); end); end,  -- eqir
    [15]  = function(r, i, m, f, a) applyComparaisonOpcode(r, i, 1, function (a, b) return tonumber(a) == tonumber(b); end); end,  -- eqri
    [16]  = function(r, i, m, f, a) applyComparaisonOpcode(r, i, 2, function (a, b) return tonumber(a) == tonumber(b); end); end,  -- eqrr
  }

  for i = 1, #fileLines do
    local nbTruths = 0
    local invalidIndex = {}

    -- Test if the following line is a sample (before registers states, an instruction and an after register states)
    if fileLines[i]:find("Before") ~= nil then

      -- We consider there is at least one register
      local matchingString = "(%d+)"
      -- Construct the matchingString (depend on the number of registers)
      for nbReg = 2, nbRegisters do
        matchingString = matchingString .. ",*%s*(%d+)"
      end

      -- Use capture to ONLY retrieve interesting information from the sample
      local initRegistersValues = { string.match(fileLines[i],  "%[" .. matchingString .. "%]") }
      local instruction = { string.match(fileLines[i+1], matchingString) }
      local finalRegistersValues = { string.match(fileLines[i+2],  "%[" .. matchingString .. "%]") }

      ----------------
      if isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 0, function (a, b) return a + b; end) then
        nbTruths = nbTruths + 1
      else
        table.insert(invalidIndex, 1)
      end

      if isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 1, function (a, b) return a + b; end) then
        nbTruths = nbTruths + 1
      else
        table.insert(invalidIndex, 2)
      end

      if isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 0, function (a, b) return a * b; end) then
        nbTruths = nbTruths + 1
      else
        table.insert(invalidIndex, 3)
      end

      if isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 1, function (a, b) return a * b; end) then
        nbTruths = nbTruths + 1
      else
        table.insert(invalidIndex, 4)
      end
      -----------------
      if isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 0, binaryOperation, function (a, b) return a & b; end) then
        nbTruths = nbTruths + 1
      else
        table.insert(invalidIndex, 5)
      end
      if isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 1, binaryOperation, function (a, b) return a & b; end) then
        nbTruths = nbTruths + 1
      else
        table.insert(invalidIndex, 6)
      end

      if isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 0, binaryOperation, function (a, b) return a | b; end) then
        nbTruths = nbTruths + 1
      else
        table.insert(invalidIndex, 7)
      end

      if isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 1, binaryOperation, function (a, b) return a | b; end) then
        nbTruths = nbTruths + 1
      else
        table.insert(invalidIndex, 8)
      end
      -----------------

      if isAssignmentOpcode(initRegistersValues, instruction, finalRegistersValues, 0) then
        nbTruths = nbTruths + 1
      else
        table.insert(invalidIndex, 9)
      end

      if isAssignmentOpcode(initRegistersValues, instruction, finalRegistersValues, 1) then
        nbTruths = nbTruths + 1
      else
        table.insert(invalidIndex, 10)
      end
      -----------------

      if isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 0, function (a, b) return tonumber(a) > tonumber(b); end) then
        nbTruths = nbTruths + 1
      else
        table.insert(invalidIndex, 11)
      end

      if isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 1, function (a, b) return tonumber(a) > tonumber(b); end) then
        nbTruths = nbTruths + 1
      else
        table.insert(invalidIndex, 12)
      end

      if isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 2, function (a, b) return tonumber(a) > tonumber(b); end) then
        nbTruths = nbTruths + 1
      else
        table.insert(invalidIndex, 13)
      end
      -----------------

      if isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 0, function (a, b) return tonumber(a) == tonumber(b); end) then
        nbTruths = nbTruths + 1
      else
        table.insert(invalidIndex, 14)
      end

      if isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 1, function (a, b) return tonumber(a) == tonumber(b); end) then
        nbTruths = nbTruths + 1
      else
        table.insert(invalidIndex, 15)
      end

      if isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 2, function (a, b) return tonumber(a) == tonumber(b); end) then
        nbTruths = nbTruths + 1
      else
        table.insert(invalidIndex, 16)
      end

      -- Part 1
      if nbTruths >= 3 then
        resultPartOne = resultPartOne + 1

        -- Collected the sample for part 2
        table.insert(inputs, initRegistersValues)
        table.insert(instructions, instruction)
        table.insert(outputs, finalRegistersValues)
      end

      -- Part 2
      -- Increment the total of truth for all index
      for index = 1, #invalidIndex do
        -- We start at 1 (not 0) so instruction[1] + 1
        truthCounter[tonumber(instruction[1])+1][invalidIndex[index]] = false
      end

      if tonumber(instruction[1])+1 == 11 then
        --print("BEFORE", fileLines[i]:sub(fileLines[i]:find("%["), #fileLines[i]))
        print("INSTRUCTION", fileLines[i+1])
        --print("AFTER", fileLines[i+2]:sub(fileLines[i+2]:find("%["), #fileLines[i+2]))

        print("isAddr = ", isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 0, function (a, b) return a + b; end))
        print("isAddi = ", isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 1, function (a, b) return a + b; end))
        print("isMulr = ", isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 0, function (a, b) return a * b; end))
        print("isMuli = ", isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 1, function (a, b) return a * b; end))
        print("isBanr = ", isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 0, binaryOperation, function (a, b) return a & b; end))
        print("isBani = ", isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 1, binaryOperation, function (a, b) return a & b; end))
        print("isBorr = ", isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 0, binaryOperation, function (a, b) return a | b; end))
        print("isBori = ", isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 1, binaryOperation, function (a, b) return a | b; end))
        print("setr = ", isAssignmentOpcode(initRegistersValues, instruction, finalRegistersValues, 0))
        print("seti = ", isAssignmentOpcode(initRegistersValues, instruction, finalRegistersValues, 1))
        print("isGtir = ", isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 0, function (a, b) return tonumber(a) > tonumber(b); end))
        print("isGtri = ", isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 1, function (a, b) return tonumber(a) > tonumber(b); end))
        print("isGtrr = ", isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 2, function (a, b) return tonumber(a) > tonumber(b); end))
        print("isEqir = ", isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 0, function (a, b) return tonumber(a) == tonumber(b); end))
        print("isEqri = ", isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 1, function (a, b) return tonumber(a) == tonumber(b); end))
        print("isEqrr = ", isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 2, function (a, b) return tonumber(a) == tonumber(b); end))

        for i = 1, #truthCounter do
          print(list.toString(truthCounter[i]))
        end
      end

      --io.write("STOP : ")
      --io.flush()
      --io.read()

      -- Skip the three lines we just processed
      -- Doesn't work.
      --i = i + 3
    end                         -- end if
  end                           -- end for

  print("==================================================================")
  print("FINAL RESULT PART ONE", resultPartOne)
  print("==================================================================")

  for i = 1, #truthCounter do
    print(list.toString(truthCounter[i]))
  end

  io.write("STOP 2 : ")
  io.flush()
  io.read()

  -- Tests if we're currently finding the current number
  --print(instructionsResolved[instruction[1]+1])

  local i = 1
  local nbAdded = 0
  local instructionsResolved = Set{}
  print("START", #instructionsResolved)
  while nbAdded < 16 do
  --  print(i)
    --print(instructionsResolved[i])
    if instructionsResolved[i] == nil then
      local nbTrue = 0
      local index = nil

      for j = 1, 16 do
        if truthCounter[i][j] == true then
          nbTrue = nbTrue + 1
          index = j
        end
      end

      print("FOUND", i, index, nbTrue)

      -- Identify an operation
      if nbTrue == 1 then
        print("ADD")
        -- Update the truthCounter table to eliminate that value
        for newIndex = 1, 16 do
          truthCounter[newIndex][index] = false
        end
        -- Update all struct
        correspondanceTable[i] = index
        -- Tag it has resolved
        instructionsResolved[i] = true
        nbAdded = nbAdded + 1
      end
    end

    -- Update the counter i
    i = (i % 16) + 1
  end

  print("END", #instructionsResolved)

  for i = 1, #correspondanceTable do
    print(i, correspondanceTable[i])
  end

  return inputs, instructions, outputs
end


--#################################################################
-- Main - Main function
--#################################################################
function day16Main (filename)

  local nbRegisters = 4

  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  local inputs, instructions, outputs = preprocessing(nbRegisters, inputFile)

  --local partTwoResult = partTwo(inputs, instructions, outputs)

  -- Finally close the file
  inputFile:close();

  print("Result part one :", partOneResult);
  print("Result part two :", partTwoResult);

end

--#################################################################
-- Package end
--#################################################################

day16 = {
  day16Main = day16Main,
}

return day16
