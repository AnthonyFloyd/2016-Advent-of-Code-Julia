#
# Advent of Code
# Day 5: How About a Nice Game of Chess?
#

# Part 1 completes in: 12.37s
# Part 2 completes in: 31.63s
#
# In Python 2.7.10 (32-bit)
# Part 1 takes ~23.54s
# Part 2 takes ~63.59s
#
# In Python 2.7.12 (64-bit)
# Part 1 takes ~20.71s
# Part 2 takes ~57.06s
#
# In Python 3.5.2 (64-bit)
# Part 1 takes ~28.07s
# Part 2 takes ~75.11s
#
# Using DV's C++ implementation,
# Part 1 takes 66.097s / 38.344s with /Ox
# Part 2 takes 187.31s / 106.322s with /Ox
#
# Using MZ's Python implementation (2.7.10, 32-bit)
# Part 1 takes ~27.52s
# Part 2 takes ~76.02s
#
#
using Nettle

println("Advent of Code")
println("Day 5: How About a Nice Game of Chess?")
println("")
println("Part 1")

#DOOR_ID = "abc"
DOOR_ID = "ojvtpuvg"

notFound = true
counter = 0
foundCounter = 0
password = ""

tic()

while foundCounter < 8
  testHash = hexdigest("md5",DOOR_ID * string(counter))
  if testHash[1:5] == "00000"
    foundCounter += 1
    password = password * string(testHash[6])
    println("$password")
  end

  counter += 1
end

toc()

println("The part 1 password for $DOOR_ID is $password ($counter iterations).")

# part 2
println("\nPart2")

notFound = true
counter = 0
foundCounter = 0
password = "--------"

tic()

while foundCounter < 8
  testHash = hexdigest("md5",DOOR_ID * string(counter))
  if testHash[1:5] == "00000"
    if isnumber(testHash[6])
      position = parse(string(testHash[6])) + 1
      if position <= 8
        if password[position] == '-'
          password = password[1:position-1] * string(testHash[7]) * password[position+1:end]
          foundCounter += 1
          println("$password")
        end
      end
    end
  end
  counter += 1
end
toc()

println("The part 2 password for $DOOR_ID is $password ($counter iterations).")
