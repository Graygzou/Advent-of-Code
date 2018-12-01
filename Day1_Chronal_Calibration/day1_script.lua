-- Variables
local part1Result = 0; -- this should be a protected variables if the program is multithreated.
local part2Result = 0;
local filename = "input.txt";
local mode = "r";

---------------------------------------
-- Helper function for set data structure
---------------------------------------
function Set (list)
  local set = {};
  for _, l in ipairs (list) do set[l] = true end;
  return set;
end

---------------------------------------
-- function main
---------------------------------------
function main ()
  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, mode));

  --partOne(inputFile);
  partTwo(inputFile);

  -- Finally close the file
  inputFile:close();
end

---------------------------------------
-- function used for the part one
---------------------------------------
function partOne (inputFile)
  -- Read the file line by line
  line = inputFile:read()   -- Call the read method on the handle with the colon syntax
  while line ~= nil do
    part1Result = part1Result + line;
    line = inputFile:read()
  end

  -- Print the final result
  print(result);
end

local precedentSign = '';

---------------------------------------
-- function used for the part two
---------------------------------------
function partTwo (inputFile)
  lines = inputFile:read("*all");

  -- Get the sign of the first number
  --precedentSign = string.sub(lines, 0, 1);
  --print(precedentSign);

  local cumulFrenquency = 0;
  local found = false;
  frequencies = Set{0,};
  repeat
    res = string.gsub(lines, ".-[\n]", function (val)
            -- We do not iterate if the result is already found.
            if not found then
              -- Update the cumul result
              cumulFrenquency = cumulFrenquency + val;
              --print(cumulFrenquency);

              --print(frequencies[cumulFrenquency]);
              if frequencies[cumulFrenquency] then
              -- Update the flag
                found = true;
                part2Result = cumulFrenquency;
              else
                -- Update the set
                frequencies[cumulFrenquency] = true;
                print(frequencies[cumulFrenquency]);
              end

              --[[
              currentSign = string.sub(val, 0, 1);
              if currentSign == precedentSign then
                print(val);
                part2Result = cumulFrenquency;
              else
                -- Check if the goal is reached
                found = (part2Result == 0);
                -- Change the value of the
                precedentSign = string.sub(val, 0, 1);
              end
              --]]
            end
          end);
  until found;
  print(part2Result);
end

---------------------------------------
-- IN PROGRESS (maybe...)
---------------------------------------
function partTwoBis (inputFile)
  lines = inputFile:read("*all");

  -- Get the sign of the first number
  --precedentSign = string.sub(lines, 0, 1);
  --print(precedentSign);

  local cumulFrenquency = 0;
  local found = false;
  frequencies = Set{0,};
  repeat
    res = string.gsub(lines, ".-[\n]", function (val)
              currentSign = string.sub(val, 0, 1);
              if currentSign == precedentSign then
                print(val);
                part2Result = cumulFrenquency;
              else
                -- Check if the goal is reached
                found = (part2Result == 0);
                -- Change the value of the
                precedentSign = string.sub(val, 0, 1);
              end
            end
          end);
  until found;
  print(part2Result);
end

main();
