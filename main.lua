--##############################################
--# @author: Grégoire Boiron                   #
--# @date: 12/08/2018                          #
--#                                            #
--# Main function for all the days of the AoC  #
--##############################################

-----------------------------------------------------
-- Import all the packages needed.
-----------------------------------------------------
package.path = package.path .. ';Helpers/?.lua;'
require "helper"
require "list"
require "stack"
require "point"
require "set"

-----------------------------------------------------
-- Import all the days
-----------------------------------------------------
require "Day4_Repose_Record.day4"
require "Day5_Alchemical_Reduction.day5"
require "Day6_Chronal_Coordinates.day6"
require "Day7_The_Sum_of_Its_Parts.day7"
require "Day8_Memory_Maneuver.day8"
require "Day9_Marble_Mania.day9"
require "Day10_The_Stars_Align.day10"
require "Day11_Chronal_Charge.day11"
require "Day12_Subterranean_Sustainability.day12"
require "Day13_Mine_Cart_Madness.day13"
require "Day14_Chocolate_Charts.day14"
require "Day15_Beverage_Bandits.day15"
require "Day16_Chronal_Classification.day16"
require "Day17_Reservoir_Research.day17"
require "Day18_Settlers _of_The_North_Pole.day18"
require "Day19_Go_With_The_Flow.day19"
require "Day20_A_Regular_Map.day20"

-- Variables
local filename = "";

-- Construct the struct used to call main.
local mains = {
  [1] = {day1_main, ""},
  [2] = {day2_main, ""},
  [3] = {day3_main, ""},
  [4] = {day4.day4Main, "Day4_Repose_Record/input.txt"},
  [5] = {day5.day5Main, "Day5_Alchemical_Reduction/input.txt"},
  [6] = {day6.day6Main, "Day6_Chronal_Coordinates/input.txt"},
  [7] = {day7.day7Main, "Day7_The_Sum_of_Its_Parts/input.txt"},
  [8] = {day8.day8Main, "Day8_Memory_Maneuver/input.txt"},
  [9] = {day9.day9Main, "Day9_Marble_Mania/input.txt"},
  [10] = {day10.day10Main, "Day10_The_Stars_Align/input.txt"},
  [11] = {day11.day11Main, "Day11_Chronal_Charge/input.txt"},
  [12] = {day12.day12Main, "Day12_Subterranean_Sustainability/input.txt"},
  [13] = {day13.day13Main, "Day13_Mine_Cart_Madness/input.txt"},
  [14] = {day14.day14Main, ""},
  [15] = {day15.day15Main, "Day15_Beverage_Bandits/input.txt"},
  [16] = {day16.day16Main, "Day16_Chronal_Classification/input.txt"},
  [17] = {day17.day17Main, "Day17_Reservoir_Research/input.txt"},
  [18] = {day18.day18Main, "Day18_Settlers _of_The_North_Pole/input.txt"},
  [19] = {day19.day19Main, "Day19_Go_With_The_Flow/input.txt"},
  [20] = {day20.day20Main, "Day20_A_Regular_Map/example4.txt"},
}

-- Retrieve input from the player
--repeat
  --io.write("Select the days you want to execute : ")
  --io.flush()
  --answer = io.read()
--until tonumber(answer) ~= nil and tonumber(answer) > 0 and mains[tonumber(answer)][1] ~= nil
if tonumber(arg[1]) ~= nil then
  local answer = tonumber(arg[1])

  -- Call the main function
  local mainFunction = mains[tonumber(answer)][1]
  local inputFile = mains[tonumber(answer)][2]

  print("========================================================")
  print("Launch day " .. tonumber(answer) .. " with the file : " .. inputFile)
  print("========================================================")

  if (mainFunction) then
    mainFunction(inputFile);
  end
else
  print("Error. Please provide the day number as first argument.")
end