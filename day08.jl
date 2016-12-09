#
# Advent of Code
# Day 8: Two-Factor Authentication
#
println("Advent of Code")
println("Day 8: Two-Factor Authentication")
println("")

# Data file
# Input data has been saved to this file
inputDataFileName = "day07-input.txt"

# Read the input data, parse it down to a list of "commands"
inputDataFile = open(inputDataFileName, "r")
inputData = readstring(inputDataFile)
close(inputDataFile)

#
# Lexicon
#
# 'rect AxB' where A,B are ints, turn on all pixels at top-left, A wide, B tall
# 'rotate row y=n by m' where n and m are ints
