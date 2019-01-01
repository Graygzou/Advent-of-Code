--#################################################################
--# @author: Grégoire Boiron                                      #
--# @date: 12/31/2018                                             #
--#                                                               #
--# Template used for every main script for the day 16 of the AoC #
--#################################################################

local P = {} -- packages

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
local function partTwo (inputFile)

  -- TODO

  return 0;
end


------------------------------------------------------------------------
--
------------------------------------------------------------------------
function isAddr(regBefore, instruction, regAfter)
  local temp = regBefore

  temp[tonumber(instruction[4])+1] = tonumber(temp[tonumber(instruction[2])+1]) + tonumber(temp[tonumber(instruction[3])+1])

  for i = 1, #temp do
    print(temp[i])
  end

  return list.equalsList(temp, regAfter)
end

------------------------------------------------------------------------
--
------------------------------------------------------------------------
function isAddi(regBefore, instruction, regAfter)
  local temp = list.copy(regBefore)

  print(tonumber(temp[tonumber(instruction[2])+1]))

  temp[tonumber(instruction[4])+1] = tonumber(temp[tonumber(instruction[2])+1]) + tonumber(instruction[3])

  print("TEST")
  for i = 1, #regBefore do
    print(regBefore[i])
  end

  return list.equals(temp, regAfter)
end


------------------------------------------------------------------------
--
------------------------------------------------------------------------
function preprocessing (nbRegisters, inputFile)
  local fileLines = helper.saveLinesToArray(inputFile);

  -- a sample is composed of 1 input, 1 instruction and 1 output.
  local samples = {}

  local inputs = {}
  local instructions = {}
  local outputs = {}

  for i = 1, #fileLines do
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

      print("isAddr = ", isAddr(initRegistersValues, instruction, finalRegistersValues))
      print("isAddi = ", isAddi(initRegistersValues, instruction, finalRegistersValues))


      -- Skip the three lines we just processed
      i = i + 3
    else
      -- Nothing right now
    end

    io.write("PRESSED FOR GO TO THE NEXT SAMPLE : ")
    io.flush()
    io.read()

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

  local partOneResult = partOne(inputs, instructions, outputs)

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

day16 = {
  day16Main = day16Main,
}

return day16
