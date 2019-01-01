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
function isArithmeticOpcode(regBefore, instruction, regAfter, mode, opcodeFunction, ...)
  local temp = list.copy(regBefore)
  local args = {...}

  if mode == 0 then
    -- Register mode
    print("A = ", tonumber(temp[tonumber(instruction[2])+1]))
    print("B = ", tonumber(temp[tonumber(instruction[3])+1]))
    temp[tonumber(instruction[4])+1] = opcodeFunction(tonumber(temp[tonumber(instruction[2])+1]), tonumber(temp[tonumber(instruction[3])+1]), args)
  else
    -- Immediate mode
    print("A = ", tonumber(temp[tonumber(instruction[2])+1]))
    print("B = ", tonumber(instruction[3]))
    temp[tonumber(instruction[4])+1] = opcodeFunction(tonumber(temp[tonumber(instruction[2])+1]), tonumber(instruction[3]), args)
  end

  --for i = 1, #temp do
  --  print(temp[i])
  --end

  return list.equals(temp, regAfter, function(a, b)
    return tonumber(a) == tonumber(b)
  end)
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function isAssignmentOpcode(regBefore, instruction, regAfter, mode)
  local temp = list.copy(regBefore)

  if mode == 0 then
    -- Register mode
    print("A = ", tonumber(temp[tonumber(instruction[2])+1]))
    temp[tonumber(instruction[4])+1] = tonumber(temp[tonumber(instruction[2])+1])
  else
    -- Immediate mode
    print("A = ", tonumber(instruction[2]))
    temp[tonumber(instruction[4])+1] = tonumber(instruction[2])
  end

  return list.equals(temp, regAfter, function(a, b)
    return tonumber(a) == tonumber(b)
  end)
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function isComparaisonOpcode(regBefore, instruction, regAfter, mode, opcodeFunction)
  local temp = list.copy(regBefore)

  if mode == 0 then
    -- immediate/register mode
    print("A = ", tonumber(instruction[2]))
    print("B = ", tonumber(temp[tonumber(instruction[3])+1]))
    if opcodeFunction(tonumber(instruction[2]), tonumber(temp[tonumber(instruction[3])+1])) then
      temp[tonumber(instruction[4])+1] = 1
    else
      temp[tonumber(instruction[4])+1] = 0
    end
  elseif mode == 1 then
    -- register/immediate mode
    print("A = ", tonumber(temp[tonumber(instruction[2])+1]))
    print("B = ", tonumber(instruction[3]))
    if opcodeFunction(tonumber(temp[tonumber(instruction[2])+1]), tonumber(instruction[3])) then
      temp[tonumber(instruction[4])+1] = 1
    else
      temp[tonumber(instruction[4])+1] = 0
    end
  else
    -- register/register mode
    print("A = ", tonumber(temp[tonumber(instruction[2])+1]))
    print("B = ", tonumber(temp[tonumber(instruction[3])+1]))
    if opcodeFunction(tonumber(temp[tonumber(instruction[2])+1]), tonumber(temp[tonumber(instruction[3])+1])) then
      temp[tonumber(instruction[4])+1] = 1
    else
      temp[tonumber(instruction[4])+1] = 0
    end
  end
  return list.equals(temp, regAfter, function(a, b)
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

  for i = 1, #fileLines do
    local nbTruths = 0

    -- Test if the following line is a sample (before registers states, an instruction and an after register states)
    if fileLines[i]:find("Before") ~= nil then
      print("BEFORE", fileLines[i]:sub(fileLines[i]:find("%["), #fileLines[i]))
      print("INSTRUCTION", fileLines[i+1])
      print("AFTER", fileLines[i+2]:sub(fileLines[i+2]:find("%["), #fileLines[i+2]))

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

      print("isAddr = ", isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 0, function (a, b) return a + b; end))
      if isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 0, function (a, b) return a + b; end) then
        nbTruths = nbTruths + 1
      end

      print("isAddi = ", isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 1, function (a, b) return a + b; end))
      if isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 1, function (a, b) return a + b; end) then
        nbTruths = nbTruths + 1
      end

      print("isMulr = ", isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 0, function (a, b) return a * b; end))
      if isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 0, function (a, b) return a * b; end) then
        nbTruths = nbTruths + 1
      end
      print("isMuli = ", isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 1, function (a, b) return a * b; end))
      if isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 1, function (a, b) return a * b; end) then
        nbTruths = nbTruths + 1
      end

      -----------------

      print("setr = ", isAssignmentOpcode(initRegistersValues, instruction, finalRegistersValues, 0))
      if isAssignmentOpcode(initRegistersValues, instruction, finalRegistersValues, 0) then
        nbTruths = nbTruths + 1
      end
      print("seti = ", isAssignmentOpcode(initRegistersValues, instruction, finalRegistersValues, 1))
      if isAssignmentOpcode(initRegistersValues, instruction, finalRegistersValues, 1) then
        nbTruths = nbTruths + 1
      end

      -----------------

      print("isEqir = ", isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 0, function (a, b) return tonumber(a) == tonumber(b); end))
      if isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 0, function (a, b) return tonumber(a) == tonumber(b); end) then
        nbTruths = nbTruths + 1
      end
      print("isEqri = ", isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 1, function (a, b) return tonumber(a) == tonumber(b); end))
      if isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 0, function (a, b) return tonumber(a) == tonumber(b); end) then
        nbTruths = nbTruths + 1
      end
      print("isEqrr = ", isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 2, function (a, b) return tonumber(a) == tonumber(b); end))
      if isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 2, function (a, b) return tonumber(a) == tonumber(b); end) then
        nbTruths = nbTruths + 1
      end

      -----------------

      print("isGtir = ", isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 0, function (a, b) return tonumber(a) > tonumber(b); end))
      if isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 0, function (a, b) return tonumber(a) > tonumber(b); end) then
        nbTruths = nbTruths + 1
      end
      print("isGtri = ", isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 1, function (a, b) return tonumber(a) > tonumber(b); end))
      if isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 1, function (a, b) return tonumber(a) > tonumber(b); end) then
        nbTruths = nbTruths + 1
      end
      print("isGtrr = ", isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 2, function (a, b) return tonumber(a) > tonumber(b); end))
      if isComparaisonOpcode(initRegistersValues, instruction, finalRegistersValues, 2, function (a, b) return tonumber(a) > tonumber(b); end) then
        nbTruths = nbTruths + 1
      end

      -----------------
      print("isBanr = ", isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 0, binaryOperation, function (a, b) return a & b; end))
      if isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 0, binaryOperation, function (a, b) return a & b; end) then
        nbTruths = nbTruths + 1
      end
      print("isBani = ", isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 1, binaryOperation, function (a, b) return a & b; end))
      if isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 1, binaryOperation, function (a, b) return a & b; end) then
        nbTruths = nbTruths + 1
      end
      print("isBorr = ", isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 0, binaryOperation, function (a, b) return a | b; end))
      if isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 0, binaryOperation, function (a, b) return a | b; end) then
        nbTruths = nbTruths + 1
      end
      print("isBori = ", isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 1, binaryOperation, function (a, b) return a | b; end))
      if isArithmeticOpcode(initRegistersValues, instruction, finalRegistersValues, 1, binaryOperation, function (a, b) return a | b; end) then
        nbTruths = nbTruths + 1
      end

      if nbTruths >= 3 then
        resultPartOne = resultPartOne + 1

        -- Collected the sample for part 2
        table.insert(inputs, initRegistersValues)
        table.insert(instructions, instruction)
        table.insert(outputs, finalRegistersValues)
      end

      -- Skip the three lines we just processed
      -- Doesn't work.
      --i = i + 3
    end

    --io.write("PRESSED FOR GO TO THE NEXT SAMPLE : ")
    --io.flush()
    --io.read()

  end

  print("==================================================================")
  print("FINAL RESULT PART ONE", resultPartOne)
  print("==================================================================")

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

  local partTwoResult = partTwo(inputs, instructions, outputs)

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
