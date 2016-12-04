#
# Advent of Code
# Day 3: Squares With Three Sides
#

println("Advent of Code")
println("Day 3: Squares With Three Sides")
println("")

DEBUG = false

function countPossibleTriangles(inputDataBits)

  nPossibleTriangles = 0

  for sidesString in inputDataBits
    sides = map(parse, split(sidesString))
    sort!(sides)
    if (sides[1] + sides[2] > sides[3])
      nPossibleTriangles += 1
    end
  end

  return nPossibleTriangles
end

# part 1 data file
# Input data has been saved to this file
inputDataFileName = "day03-input.txt"

# Read the input data, parse it down to a list of "commands"
inputDataFile = open(inputDataFileName, "r")
inputData = readstring(inputDataFile)
close(inputDataFile)

# part 1 example
#inputData = "5 10 25\n5 10 25\n"

# like python split, break the string into bits on spaces
inputDataBits = split(strip(inputData), '\n')

# in-place map function to strip the white spaces off of each inputDataBit
map!(strip,inputDataBits)

if DEBUG println("inputDataBits\n", inputDataBits) end

part1nPossibleTriangles = countPossibleTriangles(inputDataBits)
println("There are $part1nPossibleTriangles possible triangles in part1.")
