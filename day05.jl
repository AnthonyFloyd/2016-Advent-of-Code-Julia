#
# Advent of Code
# Day 5: How About a Nice Game of Chess?
#

using Nettle

println("Advent of Code")
println("Day 5: How About a Nice Game of Chess?")
println("")

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
  end

  counter += 1
end

println("The password for $DOOR_ID_EX is $password.")
