#
# Advent of Code
# Day 1: No Time for a Taxicab
#
# My First Julia Program
#

println("Advent of Code")
println("Day 1: No Time for a Taxicab")
println("")

DIRECTIONS  = ["North", "East", "South", "West"]
DEBUG = false

function travel(inputDataBits, isPart2)
  # lets find where we go!
  location = [0, 0]
  direction = 0
  visitedLocations = Vector{Int}[]
  foundIt = false

  # a strange while loop
  state = start(inputDataBits)
  while !done(inputDataBits, state)
    (item, state) = next(inputDataBits, state)

    if DEBUG println("Instruction: $item") end

    # deal with the item, which should be a string and an integer
    turnDirection = lowercase(item[1])
    distance = parse(Int,item[2:end])

    # work out the new direction
    if turnDirection == 'l'
      if DEBUG println("Turning left") end
      direction -= 1
      if direction < 0
        direction += 4
      end
    else
      if DEBUG println("Turning right") end
      direction += 1
      if direction > 3
        direction -= 4
      end
    end

    if DEBUG @printf("Facing %s, moving %d\n", DIRECTIONS[direction+1], distance) end

    #
    # We want to keep track of *everywhere* we've been,
    # not just destinations
    #

    for counter in range(1, distance)
      if direction == 0
        location[2] += 1
      elseif direction == 1
        location[1] += 1
      elseif direction == 2
        location[2] -= 1
      else
        location[1] -= 1
      end

      # Check our list of places we've been,
      # and if we've already been there, set the found flag
      # otherwise, add the current location to the list of
      # past locations

      if isPart2
        if !in(location, visitedLocations)
          push!(visitedLocations, copy(location))
        else
          foundIt = true
          break
        end
      end
    end

    # we need to break out of the iterating loop too
    if foundIt
      break
    end
  end

  return location
end

# Data file
# Input data has been saved to this file
inputDataFileName = "day01-input.txt"

# Read the input data, parse it down to a list of "commands"
inputDataFile = open(inputDataFileName, "r")
inputData = readstring(inputDataFile)
close(inputDataFile)

# Part 1 test data
#inputData = "R2, L3"
#inputData = "R2, R2, R2"
#inputData=  "R5, L5, R5, R3"

# Part 2 test data
#inputData = "R8, R4, R4, R8"

# like python split, break the string into bits on commas
inputDataBits = split(inputData, ",")

# in-place map function to strip the white spaces off of each inputDataBit
map!(strip,inputDataBits)

part1Location = travel(inputDataBits, false)
println("In part 1, you end up at ", part1Location, " which is at a distance of ", abs(part1Location[1]) + abs(part1Location[2]), " blocks.")

part2Location = travel(inputDataBits, true)
println("In part 2, you end up at ", part2Location, " which is at a distance of ", abs(part2Location[1]) + abs(part2Location[2]), " blocks.")
