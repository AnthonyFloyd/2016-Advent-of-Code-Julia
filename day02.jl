#
# Advent of Code
# Day 2: Bathroom Security
#

println("Advent of Code")
println("Day 2: Bathroom Security")
println("")

DEBUG = false
KEYPAD = [[1, 2, 3],[4,5,6],[7,8,9]]

if DEBUG println("Keypad\n",KEYPAD) end
#
# Keypad looks like this:
#
# 1 2 3
# 4 5 6
# 7 8 9
#
function getNumbers(inputDataBits, isPart2)
  # do nothing yet
  numbers = Vector{Int}()
  currentLocation = [2,2] # start at number 5

  for controlString in inputDataBits
    if DEBUG println("controlString: $controlString") end

    for direction in controlString
      direction = uppercase(direction)
      if DEBUG println("Direction: $direction") end

      if direction == 'U'
        if DEBUG println("Up from ", currentLocation[1]) end
        if currentLocation[1] > 1
          currentLocation[1] -= 1
        end
      elseif direction == 'D'
        if DEBUG println("Down from ", currentLocation[1]) end
        if currentLocation[1] < 3
          currentLocation[1] += 1
        end
      elseif direction == 'R'
        if DEBUG println("Right from ", currentLocation[2]) end
        if currentLocation[2] < 3
          currentLocation[2] += 1
        end
      elseif direction == 'L'
        if DEBUG println("Left from ", currentLocation[2]) end
        if currentLocation[2] > 1
          currentLocation[2] -= 1
        end
      else
        println("Unknown direction: $direction")
        quit()
      end
    end
    if DEBUG println("Current location: ", currentLocation) end
    if DEBUG println("Keypad number: ", KEYPAD[currentLocation[1]][currentLocation[2]]) end

    push!(numbers,KEYPAD[currentLocation[1]][currentLocation[2]])
  end

  return numbers
end

# part 1 data file
# Input data has been saved to this file
inputDataFileName = "day02-input.txt"

# Read the input data, parse it down to a list of "commands"
inputDataFile = open(inputDataFileName, "r")
inputData = readstring(inputDataFile)
close(inputDataFile)

# part 1 example
#inputData = "ULL\nRRDDD\nLURDL\nUUUUD\n"

# like python split, break the string into bits on commas
inputDataBits = split(inputData)

# in-place map function to strip the white spaces off of each inputDataBit
map!(strip,inputDataBits)

if DEBUG println("inputDataBits\n", inputDataBits) end

part1Code = getNumbers(inputDataBits, true)
println("The part1 code is ", part1Code)
