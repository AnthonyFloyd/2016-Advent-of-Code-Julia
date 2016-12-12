#
# Advent of Code
# Day 11: Radioisotope Thermoelectric Generators
#

println("Advent of Code")
println("Day 11: Radioisotope Thermoelectric Generators")
println("")

BIG = typemax(Int64)

# Test inputs
# The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
# The second floor contains a hydrogen generator.
# The third floor contains a lithium generator.
# The fourth floor contains nothing relevant.
#

# Test setup

MH = 1
MLi = 2
GH = -1
GLi = -2

floors = Vector{Vector{Int}}(4)
floors[1] = [MH, MLi]
floors[2] = [GH]
floors[3] = [GLi,]
floors[4] = []

elevator = Vector{Int}(2)

# Part 1 inputs
# The first floor contains a promethium generator and a promethium-compatible microchip.
# The second floor contains a cobalt generator, a curium generator, a ruthenium generator, and a plutonium generator.
# The third floor contains a cobalt-compatible microchip, a curium-compatible microchip, a ruthenium-compatible microchip, and a plutonium-compatible microchip.
# The fourth floor contains nothing relevant.

# Part  1 setup

# MPr = 1
# GPr = -1
# MCo = 2
# GCo = -2
# MCu = 3
# GCu = -3
# MRu = 4
# GRu = -4
# MPl = 5
# GPl = -5
#
# floors = Vector{Vector{Int}}(4)
# floors[1] = [GPr, MPr]
# floors[2] = [GCo, GCu, GRu, GPl]
# floors[3] = [MCo, MCu, MRu, MPl]
# floors[4] = []
#
# elevator = Vector{Int}(2)

elevatorFloor = 1
elevatorTrips = 0

# The goal is to get everything to the 4th floor with the fewest elevator moves
# But:
#  The elevator stops at each floor
#  The elevator can only hold two items at once
#  The elevator can only move if it has a generator or a chip
#  Chips get fried in the presence of a incompatible generator
#

# Brute force this.
# Somehow.

function changeConfiguration(unloadCounter1, unloadCounter2, loadCounter1, loadCounter2, startingFloors, startingElevator, elevatorFloor, newFloors, newElevator)

  newFloors = deepcopy(startingFloors)
  newElevator = deepcopy(startingElevator)
  startingElevatorLoad = length(startingElevator)
  startingFloorLoad = length(startingFloors[elevatorFloor])

  abort = false

  # unload 1
  if unloadCounter1 > 0
    if newElevator[unloadCounter1] != 0
      push!(newFloors[elevatorFloor], newElevator[unloadCounter1])
      newElevator[unloadCounter1] = 0
    else
      abort = true
    end
  end

  # unload 2
  if unloadCounter2 > 0 && !abort
    if newElevator[unloadCounter2] != 0
      push!(newFloors[elevatorFloor], newElevator[unloadCounter2])
      newElevator[unloadCounter2] = 0
    else
      abort = true
    end
  end

  if !abort
    # only load if there is space
    availableSpaces = IntSet([1,2])

    if newElevator[1] != 0
      delete!(availableSpaces, 1)
    end

    if newElevator[2] != 0
      delete!(availableSpaces, 2)
    end

    # load 1
    if loadCounter1 != 0
      if length(availableSpaces) > 0
        newElevator[pop!(availableSpaces)] = startingFloors[elevatorFloor][loadCounter1]
        deleteat!(newFloors[elevatorFloor], getindex(newFloors[elevatorFloor],startingFloors[elevatorFloor][loadCounter1]))
      else
        abort = true
      end
    end

    if !abort
      if loadCounter2 != 0
        if length(availableSpaces) > 0
          newElevator[pop!(availableSpaces)] = startingFloors[elevatorFloor][loadCounter2]
          deleteat!(newFloors[elevatorFloor], getindex(newFloors[elevatorFloor],startingFloors[elevatorFloor][loadCounter2]))
        else
          abort = true
        end
      end
    end

    if !abort
      # ok, we've loaded and unloaded the elevator, let's check to see if we have a valid configuration

      # first, the elevator needs something to make it go
      if length(newElevator) == 0
        abort = true
      end

      # things in the elevator must be compatible
      if length(newElevator) == 2
        if newElevator[1] != -newElevator[2]
          abort = true
        end
      end

      # things left on the floor must be compatible
      # which means no chips on this floor with an incompatible generator

      for item1 in newFloors[elevatorFloor]
        if item1 > 0 # it's a chip find all generators
          for item2 in newFloors[elevatorFloor]
            if item2 < 0 && item1 != -item2
              abort = true
              break
            end
          end
          if abort
            break
          end
        end
      end
    end
  end

  if abort
    isValidConfiguration = false
  end

  return isValidConfiguration
end

function findMinimumTrips(elevatorFloor::Int, startingFloors::Vector{Vector{Int}}, startingElevator::Vector{Int})

  minimumTrips = BIG

  # Current options include:
  #  * unload zero, one, or two things from the elevator
  #  * load zero, one, or two compatible things in the elevator
  # Then
  #  * move the elevator up or down

  newElevator = deepcopy(startingElevator)
  newFloors = deepcopy(floors)
  startingElevatorLoad = length(startingElevator)
  currentFloorLoad = length(startingFloors[elevatorFloor])

  for unloadCounter1 in 0:2
    for unloadCounter2 in 0:2
      for loadCounter1 in 0:currentFloorLoad
        for loadCounter2 in 0:currentFloorLoad
          isValidConfiguration = changeConfiguration(unloadCounter1, unloadCounter2, loadCounter1, loadCounter2, startingFloors, startingElevator, elevatorFloor, newFloors, newElevator)

          if isValidConfiguration
            minTripsUp = BIG
            minTripsDown = BIG

            if elevatorFloor < 4
              minTripsUp = findMinimumTrips(elevatorFloor + 1, newFloors, newElevator)
            end

            if elevatorFloor > 1
              minTripsDown = findMinimumTrips(elevatorFloor - 1, newFloors, newElevator)
            end

            minimumTrips = min(minimumTrips, minTripsUp, minTripsDown)
          end
        end
      end
    end
  end

  return minimumTrips
end

overallMinimumTrips = findMinimumTrips(elevatorFloor, floors, elevator)

println("The minimum number of trips is: $minimumTrips")
