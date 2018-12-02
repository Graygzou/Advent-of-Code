-- Variables
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
-- function used for the part one
---------------------------------------
function partOne (inputFile)
  local result = 0;

  -- Read the file line by line
  line = inputFile:read()   -- Call the read method on the handle with the colon syntax
  while line ~= nil do
    result = result + line;
    line = inputFile:read()
  end
  return result;
end

---------------------------------------
-- function used for the part two
---------------------------------------
function partTwo (inputFile)
  local result = 0;
  local cumulFrenquency = 0;
  local found = false;
  frequencies = Set{0};

  -- Read the entire file at once.
  lines = inputFile:read("*all");

  -- Start the algorithm
  repeat
    res = string.gsub(lines, ".-[\n]", function (val)
            -- We do not iterate if the result is already found.
            if not found then
              -- Update the cumul result
              cumulFrenquency = cumulFrenquency + val;

              if frequencies[cumulFrenquency] then
              -- Update the flag
                found = true;
                result = cumulFrenquency;
              else
                -- Update the set
                frequencies[cumulFrenquency] = true;
              end
            end
          end);
  until found;
  return part2Result;
end

---------------------------------------
-- function main
---------------------------------------
function main ()
  -- Read the input file and put it in a file handle
  local inputFile = assert(io.open(filename, mode));

  -- Launch and print the final result
  print("Result part one :", partOne(inputFile));

  -- Reset the file handle position to the beginning to use it again
  inputFile:seek("set");

  -- Launch and print the final result
  print("Result part two :", partTwo(inputFile));

  -- Finally close the file
  inputFile:close();
end

---------------------------------------
-- IN PROGRESS (maybe...)
---------------------------------------
local precedentSign = '';
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
          end);
  until found;
  print(part2Result);
end

main();
