#
# Advent of Code
# Day 6: Signals and Noise
#
println("Advent of Code")
println("Day 6: Signals and Noise")
println("")

NCOLS = 8

# Data file
# Input data has been saved to this file
inputDataFileName = "day06-input.txt"

# Read the input data, parse it down to a list of "commands"
inputDataFile = open(inputDataFileName, "r")
inputData = readstring(inputDataFile)
close(inputDataFile)

inputDataLines = split(strip(inputData), '\n')

# Set up a vector of dicts - character:frequency
signalDict = Vector{Dict{Char,Int}}(NCOLS)
# Can we initialize the dicts without doing this loop?
for counter in 1:NCOLS
  signalDict[counter] = Dict{Char,Int}()
end

# For every line, loop through each character,
# and count the occurances
for line in inputDataLines
  for (counter, letter) in enumerate(line)
    try
      signalDict[counter][letter] += 1
    catch error
      if isa(error, KeyError)
        signalDict[counter][letter] = 1
      end
    end
  end
end

signal1 = ""
signal2 = ""

# for every column, find the most frequent (part 1) and
# least frequent character (part 2) and concatenate them
# together

for subDict in signalDict
  maxCount = 0
  maxChar = 'a'

  minCount = 99999
  minChar = 'a'

  for (k, v) in subDict
    if v > maxCount
      maxCount = v
      maxChar = k
    elseif v < minCount
      minCount = v
      minChar = k
    end
  end
  signal1 = signal1 * string(maxChar)
  signal2 = signal2 * string(minChar)
end

println("The part 1 signal is: $signal1")
println("The part 2 signal is: $signal2")
