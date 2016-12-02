#
# Advent of Code
# Day 1
#
# My First Julia Program
#

# Input data has been saved to this file
inputDataFileName = "day1-input.txt"

# Read the input data, parse it down to a list of "commands"
inputDataFile = open(inputDataFileName, "r")
inputData = readstring(inputDataFile)
close(inputDataFile)

# like python split, break the string into bits on commas
inputDataBits = split(inputData, ",")

# in-place map function to strip the white spaces off of each inputDataBit
map!(strip,inputDataBits)

# lets find where we go!
location = [0, 0]
direction = 0

# a strange for loop
state = start(inputDataBits)
while !done(inputDataBits, state)
  (item, state) = next(inputDataBits, state)

  # deal with the item, which should be a string and an integer
  turnDirection = lowercase(item[1])
  distance = parse(Int,item[2:end])

  # work out the new direction
  if turnDirection == "l"
    direction -= 1
    if direction < 0
      direction += 4
    end
  else
    direction += 1
    if direction > 3
      direction -= 4
    end
  end

  if direction == 0
    location[2] += distance
  elseif direction == 1
    location[1] += distance
  elseif direction == 2
    location[2] -= distance
  else
    location[1] -= distance
  end
end

println("Final location:")
println(location)

totalDistance = abs(location[1]) + abs(location[2])
println("Distance:")
println(totalDistance)
