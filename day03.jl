#
# Advent of Code
# Day 3: Squares With Three Sides
#

println("Advent of Code")
println("Day 3: Squares With Three Sides")
println("")

DEBUG = false

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

part1nPossibleTriangles = 0

# for each row in the input data,
for sidesString in inputDataBits
  # convert the strings to ints
  sides = map(parse, split(sidesString))

  # sort from low to high
  sort!(sides)

  # check for a possible triangle
  if (sides[1] + sides[2] > sides[3])
    part1nPossibleTriangles += 1
  end
end

println("There are $part1nPossibleTriangles possible triangles in part 1.")

# For Part 2, change the data storage

# sidesVectors is going to be stored as columns of numbers, not rows
# due to Julia's column-major storage

sidesVectors = Array{Int}(3,0)

# step through the data in groups of 3 lines
for lineIndex in 1:3:length(inputDataBits)

  # convert each line to a vector of ints
  line1Data = map(parse, split(inputDataBits[lineIndex]))
  line2Data = map(parse, split(inputDataBits[lineIndex+1]))
  line3Data = map(parse, split(inputDataBits[lineIndex+2]))

  # convert the rows to columns, and sort from low to high
  column1 = sort([line1Data[1], line2Data[1], line3Data[1]])
  column2 = sort([line1Data[2], line2Data[2], line3Data[2]])
  column3 = sort([line1Data[3], line2Data[3], line3Data[3]])

  # append the 3 columns to the main array
  sidesVectors = hcat(sidesVectors, column1, column2, column3)
end

part2nPossibleTriangles = 0

# now, step through each column, check for possible triangles
for column in 1:size(sidesVectors, 2)
  if sidesVectors[1, column] + sidesVectors[2, column] > sidesVectors[3, column]
    part2nPossibleTriangles += 1
  end
end

println("There are $part2nPossibleTriangles possible triangles in part 2.")
