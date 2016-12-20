#
# Advent of Code
# Day 14: One-Time Pad
#
using Nettle

println("Advent of Code")
println("Day 14: One-Time Pad")
println("")

STRETCH = true

# test
#SALT = "abc"

# part 1 and 2
SALT = "qzyelonm"

function getHash(key::String, stretch::Bool)
  hash = hexdigest("md5",key)

  if stretch
    for i in 1:2016
      hash = hexdigest("md5", hash)
    end
  end

  return hash
end

# generate 1000 hashes first

hashes = Vector{String}(1001)

for counter in 1:1001
  hashes[counter] = getHash(SALT * string(counter), STRETCH)
end

hashCounter = 1
nKeys = 0

while nKeys < 64
  # check to see if there is a repeat of 3 characters in this hash
  m = match(r"(.)\1{2}", hashes[1])
  if m != nothing
    matchCharacter = m[1]
    # now search the remaining hashes for the same repeating character
    for counter in 2:1001
      m1 = match(Regex("(" * matchCharacter * ")\\1{4}"), hashes[counter])
      if m1 != nothing
        nKeys += 1
        println("Key $nKeys found at $hashCounter")
        break
      end
    end
  end

  if nKeys < 64
    # get rid of the first one
    shift!(hashes)
    # put a new one on the end
    hashCounter += 1
    push!(hashes, getHash(SALT * string(hashCounter + 1000), STRETCH))
  end

  if hashCounter % 1000 == 0
    println("Hash index $hashCounter")
  end
end

println("Hash number $hashCounter is the 64th key.")
