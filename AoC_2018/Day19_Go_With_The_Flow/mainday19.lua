--##############################################
--# @author: Grégoire Boiron                   #
--# @date: 12/08/2018                          #
--#                                            #
--# Main function for days 19 of the AoC 2018  #
--##############################################

-----------------------------------------------------
-- Import all the packages needed.
-----------------------------------------------------
package.path = package.path .. ';../Helpers/?.lua;'
require "helper"
require "list"
require "stack"
require "point"
require "set"

require "day19"

-- Variables
local filename = nil;

-- Retrieve the input file provided in argument
if (arg[1]) then
  local inputFile = arg[1]

  print("========================================================")
  print("Launch day 19 with the file : " .. inputFile)
  print("========================================================")

  day19.day19Main(inputFile);
else
  print("Error. Please provided a input file has first argument.")
end
