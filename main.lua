--##############################################
--# @author: Grégoire Boiron                   #
--# @date: 12/08/2018                          #
--#                                            #
--# Main function for all the days of the AoC  #
--##############################################

-- Import all the packages needed.
package.path = package.path .. ';Helpers/?.lua;'
require "helper"
require "Day4_Repose_Record.day4"
require "Day5_Alchemical_Reduction.day5"

-- Variables
local filename = "";

-- Construct the struct used to call main.
local mains = {
  [1] = {day1_main, ""},
  [2] = {day2_main, ""},
  [3] = {day3_main, ""},
  [4] = {day4.day4Main, "Day4_Repose_Record/input.txt"},
  [5] = {day5.day5Main, "Day5_Alchemical_Reduction/input.txt"},
}

-- Retrieve input from the player
repeat
  io.write("Select the days you want to execute : ")
  io.flush()
  answer = io.read()
until tonumber(answer) ~= nil and tonumber(answer) > 0 and mains[tonumber(answer)][1] ~= nil

-- Call the main function
local mainFunction = mains[tonumber(answer)][1]
local inputFile = mains[tonumber(answer)][2]

print("========================================================")
print("Launch day " .. tonumber(answer) .. " with the file : " .. inputFile)
print("========================================================")

if (mainFunction) then
  mainFunction(inputFile);
end
