#
# Advent of Code
# Day 8: Two-Factor Authentication
#
println("Advent of Code")
println("Day 8: Two-Factor Authentication")
println("")

# Data file
# Input data has been saved to this file
inputDataFileName = "day08-input.txt"

# Read the input data, parse it down to a list of "commands"
inputDataFile = open(inputDataFileName, "r")
inputData = readstring(inputDataFile)
close(inputDataFile)

#inputData = """
#rect 3x2
#rotate column x=1 by 1
#rotate row y=0 by 4
#rotate column x=1 by 1
#"""

inputDataLines = split(strip(inputData), '\n')

screen = zeros(Int,(6,50))
#screen = zeros(Int,(3,7)) # test screen size

for line in inputDataLines
  lineBits = split(line)
  if lineBits[1] == "rect"
    (x,y) = map(parse,split(lineBits[2],'x'))
    screen[1:y,1:x] = 1
  else
    if lineBits[2] == "column" # shift everything in column x down by y
      x = parse(split(lineBits[3],'=')[2]) + 1
      y = parse(lineBits[end])
      column = screen[:,x]
      screen[:,x] = circshift(column,y)
    else
      y = parse(split(lineBits[3],'=')[2]) + 1
      x = parse(lineBits[end])
      row = screen[y,:]
      screen[y,:] = circshift(row, x)
    end
  end
end

nLit = sum(screen)

println("Part 1: $nLit are lit.")

# convert screen to characters, and pretty print them
for counter in 0:9
  character = screen[:,(counter*5+1):(counter*5+4)]
  for rowCounter in 1:6
    rowString = ""
    for item in character[rowCounter,:]
      if item == 1
        rowString = rowString * "*"
      else
        rowString = rowString * " "
      end
    end
    println(rowString)
  end
  println("")

end
