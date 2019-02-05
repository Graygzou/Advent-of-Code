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
  day19 = P
else
  _G[_REQUIREDNAME] = P
end

--#################################################################
-- Work needs to be here
--#################################################################

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function applyArithmeticOpcode(registers, instruction, mode, opcodeFunction, args)
  local A = nil
  local B = nil
  if mode == 0 then
    -- Register mode
    A = tonumber(registers[tonumber(instruction[1])+1])
    B = tonumber(registers[tonumber(instruction[2])+1])
  elseif mode == 1 then
    -- Immediate mode
    A = tonumber(registers[tonumber(instruction[1])+1])
    B = tonumber(instruction[2])
  end
  --print("A = ", A)
  --print("B = ", B)
  registers[tonumber(instruction[3])+1] = opcodeFunction(A, B, args)
  return registers
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function applyAssignmentOpcode(registers, instruction, mode)
  local A = nil
  if mode == 0 then
    -- Register mode
    A = tonumber(registers[tonumber(instruction[1])+1])
  elseif mode == 1 then
    -- Immediate mode
    A = tonumber(instruction[1])
  end
  --print("A = ", A)
  registers[tonumber(instruction[3])+1] = A
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
    A = tonumber(instruction[1])
    B = tonumber(registers[tonumber(instruction[2])+1])
  elseif mode == 1 then
    -- register/immediate mode
    A = tonumber(registers[tonumber(instruction[1])+1])
    B = tonumber(instruction[2])
  elseif mode == 2 then
    -- register/register mode
    A = tonumber(registers[tonumber(instruction[1])+1])
    B = tonumber(registers[tonumber(instruction[2])+1])
  end
  --print("A = ", A)
  --print("B = ", B)
  if opcodeFunction(A, B) then
    registers[tonumber(instruction[3])+1] = 1
  else
    registers[tonumber(instruction[3])+1] = 0
  end
  return registers
end


function loopOptimization(instructions, markedInstructions, currentInstructionPointer, previousInstructionPointer)
  -- 1) Find the condition of the loop
  -- The condition is composed of the condition instruction + the jump instruction to avoid the loop + the jump instruction for the loop.
  -- The output of the condition instruction should be in the jump instruction WITH the instruction pointer.
  -- The last jump instruction should be a seti.


  -- 2)
  -- We want to remove all possible instructions from the loop vy "fast-forwarding" all the operations.




end


function assemblyTranslation (instructions, regInstruc)
  local finalTranslation = ""

  -- String lists
  local instructionsStrings = {}
  for i = 1, #instructions do
    instructionsStrings[i] = ""
  end

  local indexes = stack.new{}
  local markedInstructions = stack.new{}

  local i = 1;
  local ifStatement = false
  local elseStatement = false
  local endStatement = false
  while i < #instructions do

    local currentInstruction = ""

    -- Retrieve the next instruction
    if not stack.contains(markedInstructions, instructions[i].ip) then
      stack.pushleft(indexes, i-1)

      --stack.printstack(markedInstructions, function(x) return x end)
      --print(stack.contains(markedInstructions, instructions[i+1].ip))
      -- Marked the current instruction
      --table.insert(markedInstructions, instructions[i+1].ip)
      stack.pushleft(markedInstructions, instructions[i].ip)
    end

    if elseStatement then
      currentInstruction = currentInstruction .. "  "
      ifStatement = false
      endStatement = true
    end
    if ifStatement then
      currentInstruction = currentInstruction .. "  "
      ifStatement = false
      elseStatement = true
    end

    currentInstruction = currentInstruction .. "  "

    if instructions[i].name == "addr" then
      currentInstruction = currentInstruction .. " [" .. instructions[i].output .. "] = [" .. instructions[i].input[1] .. "] + [" ..  instructions[i].input[2] .. "];"
    elseif instructions[i].name == "addi" then
      currentInstruction = currentInstruction .. " [" .. instructions[i].output .. "] = [" .. instructions[i].input[1] .. "] + " ..  instructions[i].input[2] .. ";"
    elseif instructions[i].name == "seti" then
      currentInstruction = currentInstruction .. " [" .. instructions[i].output .. "] = " .. instructions[i].input[1] .. ";"
    elseif instructions[i].name == "setr" then
      currentInstruction = currentInstruction .. " [" .. instructions[i].output .. "] = [" .. instructions[i].input[1] .. "];"
    elseif instructions[i].name == "mulr" then
      currentInstruction = currentInstruction .. " [" .. instructions[i].output .. "] = [" .. instructions[i].input[1] .. "] * [" ..  instructions[i].input[2] .. "];"
    elseif instructions[i].name == "muli" then
      currentInstruction = currentInstruction .. " [" .. instructions[i].output .. "] = [" .. instructions[i].input[1] .. "] * " ..  instructions[i].input[2] .. ";"
    end
    instructionsStrings[i] = currentInstruction

    if endStatement then
      currentInstruction = currentInstruction .. "\n    END"
      elseStatement = false
      endStatement = false
    end

    if elseStatement then
      currentInstruction = currentInstruction .. "\n    ELSE"
      elseStatement = false
      endStatement = true
    end

    if instructions[i].name == "eqrr" then
      -- Check if the next instruction will use this result
      if not (tonumber(instructions[i].output) == tonumber(instructions[i+1].input[1]) or (#instructions[i+1].input > 1 and tonumber(instructions[i].output) == tonumber(instructions[i+1].input[2]))) then
        currentInstruction = currentInstruction .. "\n  [" .. instructions[i].output .. "] = 1;\n"
        currentInstruction = currentInstruction .. "else\n"
        currentInstruction = currentInstruction .. "  [" .. instructions[i].output .. "] = 0;"
        instructionsStrings[i] = currentInstruction
      else

        if (tonumber(instructions[i+2].input[1]) == tonumber(regInstruc) and tonumber(instructions[i+2].input[2]) == 1) or
            (tonumber(instructions[i+2].input[2]) == tonumber(regInstruc) and tonumber(instructions[i+2].input[1]) == 1) then
          -- Negative condition
          currentInstruction = currentInstruction .. " IF [" .. instructions[i].input[1] .. "] != [" .. instructions[i].input[2] .. "] THEN"
          instructionsStrings[i] = currentInstruction
          endStatement = true
          i = i + 1
        else
          -- Positive condition
          currentInstruction = currentInstruction .. " IF [" .. instructions[i].input[1] .. "] == [" .. instructions[i].input[2] .. "] THEN"
          instructionsStrings[i] = currentInstruction
          ifStatement = true
        end
        i = i + 1
      end

    elseif instructions[i].name == "gtrr" then
      -- Check if the next instruction will use this result
      if not (tonumber(instructions[i].output) == tonumber(instructions[i+1].input[1]) or (#instructions[i+1].input > 1 and tonumber(instructions[i].output) == tonumber(instructions[i+1].input[2]))) then
        currentInstruction = currentInstruction .. "\n  [" .. instructions[i].output .. "] = 1;\n"
        currentInstruction = currentInstruction .. "else\n"
        currentInstruction = currentInstruction .. "  [" .. instructions[i].output .. "] = 0;"
      else
        if (tonumber(instructions[i+2].input[1]) == tonumber(regInstruc) and tonumber(instructions[i+2].input[2]) == 1) or
            (tonumber(instructions[i+2].input[2]) == tonumber(regInstruc) and tonumber(instructions[i+2].input[1]) == 1) then
          -- Check if this condition is part of a do ... while statement
          if (#instructions[i+3].input == 1) and (tonumber(instructions[i+3].output) == tonumber(regInstruc)) then
            -- Do ... while
            instructionsStrings[tonumber(instructions[i+2].input[1])+1] = "DO\n       " .. instructionsStrings[tonumber(instructions[i+2].input[1])+1]

            -- Add missing tabulation
            for counter = tonumber(instructions[i+2].input[1])+1, i do
              instructionsStrings[counter] = "  " .. instructionsStrings[counter]
            end

            instructionsStrings[i] = currentInstruction .. " WHILE [" .. instructions[i].input[1] .. "] <= [" .. instructions[i].input[2] .. "] END"
            --instructionsStrings[i] = currentInstruction
            i = i + 1
          else
            -- Negative condition
            currentInstruction = currentInstruction .. " IF [" .. instructions[i].input[1] .. "] <= [" .. instructions[i].input[2] .. "] THEN"
            instructionsStrings[i] = currentInstruction
            endStatement = true
            i = i + 1
          end
        else
          -- Check if this condition is part of a do ... while statement
          if (#instructions[i+2].input == 1) and (tonumber(instructions[i+2].output) == tonumber(regInstruc)) then
            -- Do ... while
            instructionsStrings[tonumber(instructions[i+2].input[1])+1] = "DO\n       " .. instructionsStrings[tonumber(instructions[i+2].input[1])+1]

            -- Add missing tabulation
            for counter = tonumber(instructions[i+2].input[1])+1, i do
              instructionsStrings[counter] = "  " .. instructionsStrings[counter]
            end

            instructionsStrings[i] = currentInstruction .. " WHILE [" .. instructions[i].input[1] .. "] > [" .. instructions[i].input[2] .. "] END"
            --instructionsStrings[i] = currentInstruction
            --ifStatement = true
          else
            -- Positive condition
            currentInstruction = currentInstruction .. " IF [" .. instructions[i].input[1] .. "] > [" .. instructions[i].input[2] .. "] THEN"
            instructionsStrings[i] = currentInstruction
            ifStatement = true
          end
        end
        i = i + 1
      end
    end

    instructionsStrings[i] = currentInstruction
    i = i + 1
  end

  for i = 1, #instructionsStrings do
    print(i-1 .. "  " .. instructionsStrings[i])
  end

end


------------------------------------------------------------------------
-- partOne - function used for the part 1
-- Params:
--    - inputFile : file handler, input handle.
-- Return
--    the final result for the part 1.
------------------------------------------------------------------------
local function partOne (nbRegisters, inputFile)
  local registerBoundInstruction = nil
  local instructions = {}

  local functionsRef = {
    ["addr"]  = function(r, i) return applyArithmeticOpcode(r, i, 0, function (a, b) return a + b; end); end,                          -- addr
    ["addi"]  = function(r, i) return applyArithmeticOpcode(r, i, 1, function (a, b) return a + b; end); end,                          -- addi
    ["mulr"]  = function(r, i) return applyArithmeticOpcode(r, i, 0, function (a, b) return a * b; end); end,                          -- mulr
    ["muli"]  = function(r, i) return applyArithmeticOpcode(r, i, 1, function (a, b) return a * b; end); end,                          -- muli
    ["banr"]  = function(r, i) return applyArithmeticOpcode(r, i, 0, binaryOperation, {function (a, b) return bit32.band(a, b); end}); end,       -- banr
    ["bani"]  = function(r, i) return applyArithmeticOpcode(r, i, 1, binaryOperation, {function (a, b) return bit32.band(a, b); end}); end,       -- bani
    ["borr"]  = function(r, i) return applyArithmeticOpcode(r, i, 0, binaryOperation, {function (a, b) return bit32.bor(a, b); end}); end,       -- borr
    ["bori"]  = function(r, i) return applyArithmeticOpcode(r, i, 1, binaryOperation, {function (a, b) return bit32.bor(a, b); end}); end,       -- bori
    ["setr"]  = function(r, i) return applyAssignmentOpcode(r, i, 0); end,                                                             -- setr
    ["seti"] = function(r, i) return applyAssignmentOpcode(r, i, 1); end,                                                             -- seti
    ["gtir"] = function(r, i) return applyComparaisonOpcode(r, i, 0, function (a, b) return tonumber(a) > tonumber(b); end); end,     -- gtir
    ["gtri"] = function(r, i) return applyComparaisonOpcode(r, i, 1, function (a, b) return tonumber(a) > tonumber(b); end); end,     -- gtri
    ["gtrr"] = function(r, i) return applyComparaisonOpcode(r, i, 2, function (a, b) return tonumber(a) > tonumber(b); end); end,     -- gtrr
    ["eqir"] = function(r, i) return applyComparaisonOpcode(r, i, 0, function (a, b) return tonumber(a) == tonumber(b); end); end,    -- eqir
    ["eqri"] = function(r, i) return applyComparaisonOpcode(r, i, 1, function (a, b) return tonumber(a) == tonumber(b); end); end,    -- eqri
    ["eqrr"] = function(r, i) return applyComparaisonOpcode(r, i, 2, function (a, b) return tonumber(a) == tonumber(b); end); end,    -- eqrr
  }

  -- We consider there is at least one register
  local matchingString = "(%d+)"
  -- Construct the matchingString (depend on the number of registers)
  for nbReg = 2, nbRegisters do
    matchingString = matchingString .. ",*%s*(%d+)"
  end
  local fileLines = helper.saveLinesToArray(inputFile);

  -- Retrieve all instructions in order and seperate input/ output registers.
  for lineIndex = 1, #fileLines do
    if fileLines[lineIndex]:find("#ip") then
      registerBoundInstruction = string.match(fileLines[lineIndex], "%d")
    else
      local registersInput = {}
      local registersOutput = nil
      local nextInstructionPointer = nil

      local instruction = { string.match(fileLines[lineIndex], matchingString) }
      if fileLines[lineIndex]:find("setr") or fileLines[lineIndex]:find("seti") then
        registersInput = { instruction[1] }
        registersOutput = instruction[3]
      else
        registersInput = { instruction[1], instruction[2] }
        registersOutput = instruction[3]
      end

      table.insert(instructions, {
        ip = lineIndex-2,
        name = fileLines[lineIndex]:sub(1,4),
        instruct = instruction,
        input = registersInput,
        output = registersOutput,
      })
    end
  end

  print("instruc", registerBoundInstruction)

  for i = 1, #instructions do
    string = "#ip " .. instructions[i].ip .. " // "
    for j = 1, #instructions[i].input do
      string = string .. " " .. instructions[i].input[j]
    end
    string = string .. " // " .. instructions[i].output
    print(string)
  end

  assemblyTranslation (instructions, registerBoundInstruction)

  -- Try to identify loop in the program
  local markedInstructions = stack.new{}

  local previousInstructionPointer = 0
  local currentInstructionPointer = 0
  local registers = { 0, 0, 0, 0, 0, 0 }

  local currentIteration = 0
  local limitNbIteration = 1000000
  local stop = false
  while not stop and currentIteration < limitNbIteration do
    local debugString = ""

    -- Test
    --print("instruction pointer = ", currentInstructionPointer)

    --[[
    if not stack.contains(markedInstructions, instructions[currentInstructionPointer+1].ip) then
      stack.printstack(markedInstructions, function(x) return x end)
      --print(stack.contains(markedInstructions, instructions[currentInstructionPointer+1].ip))
      -- Marked the current instruction
      --table.insert(markedInstructions, instructions[currentInstructionPointer+1].ip)
      stack.pushleft(markedInstructions, instructions[currentInstructionPointer+1].ip)
    else
      print("Loop detected ! Previous = " + previousInstructionPointer + " current = " + currentInstructionPointer)

      loopOptimization(instructions, markedInstructions, currentInstructionPointer, previousInstructionPointer)

      stop = true
    end
    --]]

    -- Write instruction pointer to the register just before the instruction is executed
    registers[tonumber(registerBoundInstruction)+1] = currentInstructionPointer

    --[[
    debugString = "ip=" .. instructions[currentInstructionPointer+1].ip .. " "
    debugString = debugString .. "["
    for reg = 1, #registers do
      debugString = debugString .. registers[reg] .. ", "
    end
    debugString = debugString .. "] "
    debugString = debugString .. instructions[currentInstructionPointer+1].name .. " "
    for reg = 1, #instructions[currentInstructionPointer+1].instruct do
      debugString = debugString .. instructions[currentInstructionPointer+1].instruct[reg] .. " "
    end
    --]]

    -- Write the value of the current instruction in the register
    registers[tonumber(registerBoundInstruction)+1] = currentInstructionPointer

    -- Go the next instruction
    if tonumber(instructions[currentInstructionPointer+1].output) == tonumber(registerBoundInstruction) then
      -- Modify the register 0 => Identify a jump
      previousInstructionPointer = currentInstructionPointer

      -- Compute it
      --print("Compute ", instructions[currentInstructionPointer+1].name)
      registers = functionsRef[instructions[currentInstructionPointer+1].name](registers, instructions[currentInstructionPointer+1].instruct)
    else
      -- normal execution = go to the next line
      -- just compute
      registers = functionsRef[instructions[currentInstructionPointer+1].name](registers, instructions[currentInstructionPointer+1].instruct)
    end

    --[[
    debugString = debugString .. "["
    for reg = 1, #registers do
      debugString = debugString .. registers[reg] .. ", "
    end
    debugString = debugString .. "] "
    --]]

    previousInstructionPointer = currentInstructionPointer



    -- Write back the value of the register into the instruction pointer
    -- And move to the next instruction
    currentInstructionPointer = registers[tonumber(registerBoundInstruction)+1]
    currentInstructionPointer = currentInstructionPointer + 1

    print(registers[5])
    --print(currentIteration)

    if (currentInstructionPointer+1) > #instructions or (currentInstructionPointer+1) < 1 then
      stop = true
    end

    currentIteration = currentIteration + 1
  end

  print("Stop due to garde fou = ", currentIteration >= limitNbIteration)

  --print(previousInstructionPointer)
  --print(currentInstructionPointer-1)

  --[[
  for i =1, #markedInstructions do
    print(markedInstructions[i])
  end
  --]]
  stack.printstack(markedInstructions, function(x) return x end)

  --[[
  local currentInstructionPointer = nil
  for lineIndex = 1, #fileLines do
    if fileLines[lineIndex]:find("#ip") then
      firstInstructionPointer = string.match(fileLines[lineIndex], "%d")
      currentInstructionPointer = firstInstructionPointer
    else
      local registers = { 0, 0, 0, 0, 0 }
      local registersInput = {}
      local registersOutput = nil
      local nextInstructionPointer = nil

      local instruction = { string.match(fileLines[lineIndex], matchingString) }
      if fileLines[lineIndex]:find("setr") or fileLines[lineIndex]:find("seti") then
        registersInput = { instruction[1] }
        registersOutput = instruction[3]
      else
        registersInput = { instruction[1], instruction[2] }
        registersOutput = instruction[3]
      end

      print("o",registersOutput)
      print("c",currentInstructionPointer)
      if tonumber(registersOutput) == tonumber(currentInstructionPointer) then
      --if tonumber(registersOutput) == i then
        -- Compute it
        print("Compute ", fileLines[lineIndex]:sub(1,4))
        finalRegisters = functionsRef[fileLines[lineIndex]:sub(1,4)](registers, instruction)

        for i = 1, #finalRegisters do
          print("yy", finalRegisters[i])
        end

        registers = finalRegisters
        nextInstructionPointer = finalRegisters[tonumber(currentInstructionPointer)+1]
        print(nextInstructionPointer)
      else
        nextInstructionPointer = currentInstructionPointer + 1
      end

      table.insert(instructions, {
        input = registersInput,
        output = registersOutput,
        instructPointeur = currentInstructionPointer,
        nextInstructPointeur = nextInstructionPointer,
        registers = registers,
      })
      currentInstructionPointer = nextInstructionPointer
    end
  end
  --]]


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
local function partTwo (inputFile)

  -- TODO

  return 0;
end


--#################################################################
-- Main - Main function
--#################################################################
function day19Main (filename)

  local nbRegisters = 3

  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, "r"));

  local partOneResult = partOne(nbRegisters, inputFile)

  -- Reset the file handle position to the beginning to use it again
  inputFile:seek("set");

  local partTwoResult = partTwo(inputFile)

  -- Finally close the file
  inputFile:close();

  print("Result part one :", partOneResult);
  print("Result part two :", partTwoResult);

end

--#################################################################
-- Package end
--#################################################################

day19 = {
  day19Main = day19Main,
}

return day19
