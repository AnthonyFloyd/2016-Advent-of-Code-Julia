#
# Advent of Code
# Day 9:
#

println("Advent of Code")
println("Day 9: ")
println("")

# Data file
# Input data has been saved to this file
inputDataFileName = "day09-input.txt"

inputDataFile = open(inputDataFileName, "r")
inputData = readstring(inputDataFile)
close(inputDataFile)

#inputData ="""
#ADVENT
#A(1x5)BC
#(3x3)XYZ
#A(2x2)BCD(2x2)EFG
#(6x1)(1x3)A
#X(8x2)(3x3)ABCY
#"""

inputDataLines = split(strip(inputData), '\n')

function calculateExpandedLength(sourceData::SubString{String}, expandInternal::Bool)
  #
  # Recursive function that calculates the length of the given SubString
  # Either expands internally discovered markers or not, depending on
  # the expandInternal flag
  #

  charCounter = 1
  expandedLength = 0

  # version 1: don't decompress internal markers
  # version 2: expand internal markers too

  while charCounter <= length(sourceData)
    # if we discover a marker, process it
    # could use regex for this, I guess
    if sourceData[charCounter] == '('
      # find how many characters to repeat,
      # process digits up to finding the 'x'
      foundX = false
      charCounter += 1
      nCharactersString = string(sourceData[charCounter])

      while !foundX
        charCounter += 1
        if sourceData[charCounter] == 'x'
          foundX = true
        else
          nCharactersString = nCharactersString * string(sourceData[charCounter])
        end
      end

      # convert the digits into an int
      nCharacters = parse(nCharactersString)

      # now find how many repeats by processing digits again
      foundClose = false
      charCounter += 1
      nRepeatsString = string(sourceData[charCounter])

      while !foundClose
        charCounter += 1
        if sourceData[charCounter] == ')'
          foundClose = true
        else
          nRepeatsString = nRepeatsString * string(sourceData[charCounter])
        end
      end

      # convert the digits to an int
      nRepeats = parse(nRepeatsString)

      if expandInternal
        # find the repeat string
        charCounter += 1 # first char outside bracket
        repeatString = sourceData[charCounter:charCounter + nCharacters - 1]
        # call this function again, using the repeat string as the base substring
        lengthOfRepeatString = calculateExpandedLength(repeatString, true)
      else
        # if we're not expanding, just use the number of characters directly
        lengthOfRepeatString = nCharacters
      end

      # we have to repeat the expanded (or not) repeatString
      expandedLength += nRepeats * lengthOfRepeatString

      # the charCounter operates on the unexpanded string
      charCounter += nCharacters # first char outside repeatString
    else
      # no marker found, just add the character
      expandedLength += 1
      charCounter += 1
    end
  end
  return expandedLength
end

# Part 1
totalLength = 0

for line in inputDataLines
  totalLength += calculateExpandedLength(line, false)
end

println("Part 1 total decompressed length: $totalLength")

# Part 2
totalLength = 0

for line in inputDataLines
  totalLength += calculateExpandedLength(line, true)
end

println("Part 2 total decompressed length: $totalLength")
