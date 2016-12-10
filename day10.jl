#
# Advent of Code
# Day 10: Balance Bots
#

println("Advent of Code")
println("Day 10: Balance Bots")
println("")

DEBUG = false

# Data file
# Input data has been saved to this file
inputDataFileName = "day10-input.txt"

inputDataFile = open(inputDataFileName, "r")
inputData = readstring(inputDataFile)
close(inputDataFile)

#inputData ="""
#value 5 goes to bot 2
#bot 2 gives low to bot 1 and high to bot 0
#value 3 goes to bot 1
#bot 1 gives low to output 1 and high to bot 0
#bot 0 gives low to output 2 and high to output 0
#value 2 goes to bot 2
#"""
#TARGET = [2, 5]

TARGET = [17, 61]

inputDataLines = split(strip(inputData), '\n')

NONE = 0
BOT = 1
OUTPUT = 2

DESTINATION = Dict(["bot" => BOT, "output" => OUTPUT])


type Bot
  inventory::Vector{Int}
  lowType::Int
  lowDestination::Int
  highType::Int
  highDestination::Int
end


bots = Dict{Int,Bot}()
outputs = Dict{Int, Vector{Int}}()

function runBot(bot::Int)
  #
  # Do the things the bot should do
  #

  # only do stuff if we have two items

  if haskey(bots, bot)
    myBot = bots[bot]
    if length(myBot.inventory) == 2
      if DEBUG println("\nBot $bot is processing its instructions.") end

      (lowValue, highValue) = sort(myBot.inventory)

      if [lowValue, highValue] == TARGET
        println("\n\nBot $bot is responsible for comparing ", lowValue, " to ", highValue, ".")
        #exit()
      end

      # process the values
      process(lowValue, myBot.lowType, myBot.lowDestination)
      process(highValue, myBot.highType, myBot.highDestination)

      # get rid of the tokens
      shift!(myBot.inventory)
      shift!(myBot.inventory)
    end

    if DEBUG println("") end

  else
    println("Tried to process bot $bot but it doesn't exist")
  end
end

function process(value::Int, myType::Int, destination::Int)
  if myType == BOT
    if DEBUG println("... giving $value to bot $destination") end

    if haskey(bots, destination)
      push!(bots[destination].inventory, value)
    else
      bots[destination] = Bot(Vector{Int}([value]), NONE, 0, NONE, 0)
    end
    runBot(destination)

  elseif myType == OUTPUT
    if DEBUG println("... putting $value in output $destination") end
    if haskey(outputs, destination)
      push!(outputs[destination], value)
    else
      outputs[destination] = Vector{Int}([value])
    end
  else
    println("Unknown type $myType")
  end
end

for line in inputDataLines
  # parse the instruction
  # use regex

  m = match(r"(value|bot) (\d+) (?:goes|gives low) to (bot|output) (\d+)(?: and high to (bot|output) (\d+))?", line)

  if m != nothing
    if m.captures[1] == "value"
      value = parse(m.captures[2])
      bot = parse(m.captures[4])
      if haskey(bots, bot)
        push!(bots[bot].inventory, value)
      else
        bots[bot] = Bot(Vector{Int}([value]), NONE, 0, NONE, 0)
      end

      if DEBUG println("Bot $bot was given $value.") end

      #runBot(bot)

    elseif m.captures[1] == "bot"
      bot = parse(m.captures[2])
      lowType = DESTINATION[m.captures[3]]
      lowDestination = parse(m.captures[4])
      highType = DESTINATION[m.captures[5]]
      highDestination = parse(m.captures[6])

      if haskey(bots, bot)
        inventory = bots[bot].inventory
      else
        inventory = Vector{Int}()
      end

      bots[bot] = Bot(inventory, lowType, lowDestination, highType, highDestination)

      if DEBUG println("Bot $bot was given new instructions.") end

      #runBot(bot)
    else
      println("Unknown directive: ", m.captures[1])
    end
  else
    println("No regex match to: $line")
  end
end

for botID in keys(bots)
  runBot(botID)
end

result = outputs[0][1] * outputs[1][1] * outputs[2][1]

println("Multiplication of 0, 1, 2: $result")
