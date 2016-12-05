#
# Advent of Code
# Day 5: How About a Nice Game of Chess?
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

while foundCounter < 8
  testHash = hexdigest("md5",DOOR_ID * string(counter))
  if testHash[1:5] == "00000"
    foundCounter += 1
    password = password * string(testHash[6])
    println("$password")
  end

  counter += 1
end

println("The part 1 password for $DOOR_ID is $password.")

# part 2
println("\nPart2")

notFound = true
counter = 0
foundCounter = 0
password = "--------"

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

println("The part 2 password for $DOOR_ID is $password.")
