#
# Advent of Code
# Day 4: Security Through Obscurity
#

println("Advent of Code")
println("Day 4: Security Through Obscurity")
println("")

function pairSorter(pair::Pair{Char,Int})
  fullString = string(pair[2]) * string(pair[1])
  return fullString
end

function parseRooms(inputDataLines)
  total = 0

  for line in inputDataLines
    letterDict = Dict{Char, Int}()

    inSector = false
    sectorID = ""

    inChecksum = false
    checksum = ""

    # evaluate all the letters one by one
    for letter in line
      # check if we have [A-za-z]
      if isalpha(letter)
        # if we've started the checksum, add the letter to the checksum
        if inChecksum
          checksum = checksum * string(letter)
        # if not, and we haven't seen this letter before, start the count
        elseif !haskey(letterDict, letter)
          letterDict[letter] = 1
        # otherwise, increment the count
        else
          letterDict[letter] += 1
        end
      # but if we have a number, we must be in the sectorID
      elseif isnumber(letter)
        # check if we've been in the sectorID yet
        if !inSector
          # we're just starting building the sector string
          sectorID = string(letter)
          inSector = true
        else
          # or, add to the sector string
          sectorID = sectorID * string(letter)
        end
      # If it's not a letter or number, maybe we're starting the checksum
      elseif letter == '['
        if !inChecksum
          inChecksum = true
        end
      end
    end

    # generate the calculated checksum
    generatedChecksum = ""
    letterList = Vector{Pair{Char,Int}}()

    # we need to reverse the numbers for the sort
    lineLength = length(line)

    # get the key, value pairs into a list
    for kv in letterDict
      kv = Pair(kv[1], lineLength - kv[2])
      push!(letterList, kv)
    end

    # sort the list by the values, then the key
    sort!(letterList,by=pairSorter)

    # grab the first five (if they exist)
    if length(letterList) >= 5
      for item in letterList[1:5]
        generatedChecksum = generatedChecksum * string(item[1])
      end

      # compare the generatedChecksum to the checksum
      # and if it matches, then grab the value of the sectorID
      # and then add it to the total

      if generatedChecksum == checksum
        total += parse(sectorID)
      end
    end
  end

  return total

end

# Data file
# Input data has been saved to this file
inputDataFileName = "day04-input.txt"

# Read the input data, parse it down to a list of "commands"
inputDataFile = open(inputDataFileName, "r")
inputData = readstring(inputDataFile)
close(inputDataFile)

#inputData = "aaaaa-bbb-z-y-x-123[abxyz]\n"
#inputData *= "a-b-c-d-e-f-g-h-987[abcde]\n"
#inputData *= "not-a-real-room-404[oarel]\n"
#inputData *= "totally-real-room-200[decoy]\n"


inputDataLines = split(strip(inputData), '\n')

part1Total = parseRooms(inputDataLines)

println("Part 1 total: $part1Total")
