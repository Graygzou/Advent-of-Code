-- Variables
local filename = "input.txt";
local mode = "r";

day2 = {}

---------------------------------------
-- Helper function for set data structure
---------------------------------------
function Set (list)
  local set = {};
  for _, l in ipairs (list) do set[l] = true end;
  return set;
end

---------------------------------------
-- Helpers function to retrieve a character from a string
---------------------------------------
function retrieveCharacter (string, indice)
  return string.sub(string, indice, indice);
end

--------------------------------------
-- Helpers function to execute a bubble sort
---------------------------------------
function bubbleSort (string)
  local resStr = string
  for i=#resStr,1,-1 do
    for j=1,#resStr-1 do
      if string.byte(retrieveCharacter(resStr, j+1)) < string.byte(retrieveCharacter(resStr, j)) then
        resStr = string.sub(resStr, 1, j-1) .. retrieveCharacter(resStr, j+1) .. retrieveCharacter(resStr, j) .. string.sub(resStr, j+2, #resStr)
      end
    end
  end
  return resStr;
end

---------------------------------------
-- function used for the part one
---------------------------------------
function partOne (inputFile)
  local nbTwoLetters = 0;
  local nbThreeLetters = 0;

  -- Read the entire file at once.
  lines = inputFile:read("*all");

  -- Start the algorithm
  res = string.gsub(lines, ".-[\n]", function (val)
          local containsTwoLetters = false;
          local containsThreeLetters = false;
          local characterIndice = 1;          -- Lua string starts at 1

          while val ~= "" and (not containsTwoLetters or not containsThreeLetters) do

            -- Iterate on both returned elements
            val,nb = string.gsub(val, retrieveCharacter(val,characterIndice), "");

            -- Update booleans
            containsTwoLetters = containsTwoLetters or nb == 2;
            containsThreeLetters = containsThreeLetters or nb == 3;
          end

          if containsTwoLetters then
            nbTwoLetters = nbTwoLetters + 1;
          end
          if containsThreeLetters then
            nbThreeLetters = nbThreeLetters + 1;
          end
        end);
  return nbTwoLetters * nbThreeLetters;
end


---------------------------------------
-- function used for the part two
---------------------------------------
function partTwo (inputFile)
  local nbTwoLetters = 0;
  local nbThreeLetters = 0;

  -- Read the entire file at once.
  lines = inputFile:read("*all");

  newLines = {};
  indice = 1

  -- Pro Processing : order characters in the every string
  lines = string.gsub(lines, ".-[\n]", function (val)
          local finalString = "";
          local characterIndice = 1;          -- Lua string starts at 1

          --newLines[indice] = bubbleSort(val);
          newLines[indice] = val;

          --print(val);
          --string.gsub(val, retrieveCharacter(val,characterIndice), "");
          indice = indice + 1;
        end);

  --local newLines = lines;

  for i = 1, #newLines do
    --print(newLines[i]);
  end

  -- Retrieve the length of one string
  stringLength = #newLines[1];
  print(stringLength);

  local matching = false

  -- For every character, remove the current character and find if their are matching strings
  for i=1,stringLength do
    -- Iterate on every IDs and find if their is a matching one.
    for id1 = 1, #newLines do
      for id2 = 1, #newLines do
        if id1 ~= id2 then
          matching = string.sub(newLines[id1], 1, i-1) .. string.sub(newLines[id1], i+1, stringLength) == string.sub(newLines[id2], 1, i-1) .. string.sub(newLines[id2], i+1, stringLength);
          if matching then
            print(newLines[id1]);
            print(newLines[id2]);

            print(string.sub(newLines[id1], 1, i-1) .. string.sub(newLines[id1], i+1, stringLength));
            print(string.sub(newLines[id2], 1, i-1) .. string.sub(newLines[id2], i+1, stringLength));
          end
        end
      end -- End for 3
    end -- End for 2
  end -- End for 1

  --print(newLines);
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

main();
