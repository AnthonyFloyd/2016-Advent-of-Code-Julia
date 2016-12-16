#
# Advent of Code
# Day 12: Leonardo's Monorail
#

println("Advent of Code")
println("Day 12: Leonardo's Monorail")
println("")

DEBUG = false

# Assembunny
#
# cpy x y copies x (either an integer or the value of a register) into register y.
# inc x increases the value of register x by one.
# dec x decreases the value of register x by one.
# jnz x y jumps to an instruction y away (positive means forward; negative means backward), but only if x is not zero.
#

# Data file
# Input data has been saved to this file
inputDataFileName = "day12-input.txt"

# Read the input data, parse it down to a list of "commands"
inputDataFile = open(inputDataFileName, "r")
inputData = readstring(inputDataFile)
close(inputDataFile)

# inputData = """cpy 41 a
# inc a
# inc a
# dec a
# jnz a 2
# dec a"""

inputDataLines = split(strip(inputData), '\n')

# part 1
#registers = Dict([("a",0),("b",0),("c",0),("d",0)])

# part 2
registers = Dict([("a",0),("b",0),("c",1),("d",0)])

lineCounter = 1

while lineCounter <= length(inputDataLines)
  value = 0 # scope rules are weird
  line = inputDataLines[lineCounter]
  m = match(r"(.{3}) ([\w\d]+)(?:\s?)([-\w]*)", line)
  if m != nothing
    if m.captures[1] == "cpy"
      try
        value = registers[m.captures[2]]
        #if DEBUG println("cpy value: ", value) end
      catch
        value = parse(m.captures[2])
        #if DEBUG println("cpy from register ", m.captures[2], ": ", registers[m.captures[2]]) end
      end
      registers[m.captures[3]] = value
      if DEBUG println("cpy ", value, " to ", m.captures[3]) end
      lineCounter += 1
    elseif m.captures[1] == "inc"
      registers[m.captures[2]] += 1
      if DEBUG println("inc ", m.captures[2], ": ", registers[m.captures[2]]) end
      lineCounter += 1
    elseif m.captures[1] == "dec"
      registers[m.captures[2]] -= 1
      if DEBUG println("dec ", m.captures[2], ": ", registers[m.captures[2]]) end
      lineCounter += 1
    elseif m.captures[1] == "jnz"
      try
        value = registers[m.captures[2]]
      catch
        value = parse(m.captures[2])
      end
      if DEBUG println("jnz value: ", value) end
      if value != 0
        lineCounter += parse(m.captures[3])
        if DEBUG println("jnz to ", lineCounter) end
      else
        if DEBUG println("jnz 0") end
        lineCounter += 1
      end
    end
  else
    if DEBUG println("Unable to parse: ", line) end
  end

  if DEBUG println("line: ", lineCounter) end
end

println("Value in register a: ", registers["a"])
