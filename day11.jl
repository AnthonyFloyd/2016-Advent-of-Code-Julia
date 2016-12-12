#
# Advent of Code
# Day 11: Radioisotope Thermoelectric Generators
#

println("Advent of Code")
println("Day 11: Radioisotope Thermoelectric Generators")
println("")

DEBUG = false

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

elevator = [0,0]

ALLCHIPS = IntSet([MH, MLi])

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
# elevator = [0,0]

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

function changeConfiguration(unloadCounter1, unloadCounter2, loadCounter1, loadCounter2, startingFloors, startingElevator, elevatorFloor)

  newFloors = deepcopy(startingFloors)
  newElevator = deepcopy(startingElevator)
  startingElevatorLoad = length(startingElevator)
  startingFloorLoad = length(startingFloors[elevatorFloor])


  # println("Changing configuration")
  # println("Unload: $unloadCounter1, $unloadCounter2")
  # println("Load: $loadCounter1, $loadCounter2")
  # println("Floor: $elevatorFloor")
  # println("Starting Floor: ", startingFloors[elevatorFloor])
  # println("Starting Elevator: ", startingElevator)
  # println("")

  abort = false

  # wait a minute, we can't remove the same thing from the elevator
  # or load the same thing on to the elevator
  #
  # But doing nothing is an option.
  #

  if (unloadCounter1 == unloadCounter2) && unloadCounter1 != 0
    if DEBUG println("Abort: unloading the same thing twice ($unloadCounter1, $unloadCounter2)") end
    abort = true
  elseif (loadCounter1 == loadCounter2) && loadCounter1 != 0
    if DEBUG println("Abort: loading same thing twice ($loadCounter1, $loadCounter2)") end
    abort = true
  end

  if !abort
    # unload 1
    if unloadCounter1 > 0
      if newElevator[unloadCounter1] != 0
        push!(newFloors[elevatorFloor], newElevator[unloadCounter1])
        newElevator[unloadCounter1] = 0
      else
        if DEBUG println("Abort: Nothing to unload (1)") end
        abort = true
      end
    end

    # unload 2
    if unloadCounter2 > 0 && !abort
      if newElevator[unloadCounter2] != 0
        push!(newFloors[elevatorFloor], newElevator[unloadCounter2])
        newElevator[unloadCounter2] = 0
      else
        if DEBUG println("Abort: Nothing to unload (2)") end
        abort = true
      end
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
      if length(availableSpaces) > 0 && length(newFloors[elevatorFloor]) > 0
        elevatorSpot = pop!(availableSpaces)
        thing = startingFloors[elevatorFloor][loadCounter1]
        #println("Putting ", thing, " in the elevator spot $elevatorSpot")
        newElevator[elevatorSpot] = thing
        thingIndex = findin(newFloors[elevatorFloor], thing)[1]
        #println("Trying to remove ", thing, " from ", newFloors[elevatorFloor], " at index ", thingIndex)
        deleteat!(newFloors[elevatorFloor], thingIndex)
      else
        if DEBUG println("Abort: No room to load elevator (1)") end
        abort = true
      end
    end

    # load 2
    if !abort
      if loadCounter2 != 0
        if length(availableSpaces) > 0 && length(newFloors[elevatorFloor]) > 0
          elevatorSpot = pop!(availableSpaces)
          thing = startingFloors[elevatorFloor][loadCounter2]
          #println("Putting ", thing, " in the elevator spot $elevatorSpot")
          newElevator[elevatorSpot] = thing
          thingIndex = findin(newFloors[elevatorFloor], thing)[1]
          #println("Trying to remove ", thing, " from ", newFloors[elevatorFloor], " at index ", thingIndex)
          deleteat!(newFloors[elevatorFloor], thingIndex)
        else
          if DEBUG println("Abort: No room to load elevator (2)") end
          abort = true
        end
      end
    end

    if !abort
      # ok, we've loaded and unloaded the elevator, let's check to see if we have a valid configuration

      # first, the elevator needs something to make it go
      if newElevator[1] == 0 && newElevator[2] == 0
        if DEBUG println("Abort: Nothing in the elevator") end
        abort = true
      end

      # things in the elevator must be compatible
      if newElevator[1] != 0 && newElevator[2] != 0
        if newElevator[1] != -newElevator[2]
          if DEBUG println("Abort: Incompatible items in elevator (", newElevator[1],",",newElevator[2],")") end
          abort = true
        end
      end

      # things left on the floor must be compatible
      # which means no chips on this floor with an incompatible generator

      for item1 in newFloors[elevatorFloor]
        if item1 > 0 # it's a chip find all generators
          for item2 in newFloors[elevatorFloor]
            if item2 < 0 && item1 != -item2
              if DEBUG println("Abort: Incompatible items on floor (", item1,",",item2,")") end
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
  else
    isValidConfiguration = true

    # println("Valid change")
    # println("Starting Floor: ", startingFloors[elevatorFloor])
    # println("Starting Elevator: ", startingElevator)
    # println("Unload: $unloadCounter1, $unloadCounter2")
    # println("Load: $loadCounter1, $loadCounter2")
    # println("Ending Floor: ", newFloors[elevatorFloor])
    # println("Ending Elevator: ", newElevator)
  end


  return (isValidConfiguration, newFloors, newElevator)
end

function printFloors(floors::Vector{Vector{Int}}, elevatorFloor::Int)
  for counter in 4:-1:1
    if counter == elevatorFloor
      line = " E "
    else
      line = "   "
    end

    for item in floors[counter]
      line *= string(item)
      line *= " "
    end
    println("$counter: $line")
  end
end

function findMinimumTrips(recursionDepth::Int, elevatorFloor::Int, startingFloors::Vector{Vector{Int}}, startingElevator::Vector{Int})

  minimumTrips = BIG

  recursionDepth += 1

  # println("Recursion depth: $recursionDepth")

  if recursionDepth > 15
    # too many steps, try something else
    recursionDepth -= 1
    return minimumTrips
  end

  # Current options include:
  #  * unload zero, one, or two things from the elevator
  #  * load zero, one, or two compatible things in the elevator
  # Then
  #  * move the elevator up or down

  newElevator = deepcopy(startingElevator)
  newFloors = deepcopy(floors)
  startingElevatorLoad = length(startingElevator)
  currentFloorLoad = length(startingFloors[elevatorFloor])

  found = false
  abort = false

  for unloadCounter1 in 0:2
    for unloadCounter2 in 0:2
      for loadCounter1 in 0:currentFloorLoad
        for loadCounter2 in 0:currentFloorLoad
          (isValidConfiguration, newFloors, newElevator) = changeConfiguration(unloadCounter1, unloadCounter2, loadCounter1, loadCounter2, startingFloors, startingElevator, elevatorFloor)

          if isValidConfiguration
            #
            # Before moving the elevator, check to see if we have all the chips on the top floor
            #

            # println("Valid change")
            # println("Starting Floor: ", startingFloors[elevatorFloor])
            # println("Starting Elevator: ", startingElevator)
            # println("Unload: $unloadCounter1, $unloadCounter2")
            # println("Load: $loadCounter1, $loadCounter2")
            # println("Ending Floor: ", newFloors[elevatorFloor])
            # println("Ending Elevator: ", newElevator)
            #
            # println("")
            #
            # printFloors(newFloors, elevatorFloor)
            #
            # println("")

            # found = true

            # for item in ALLCHIPS
            #   if !(item in newFloors[4])
            #     found = false
            #   end
            # end

            if length(newFloors[4]) == 2
              if MH in newFloors[4]
                if MLi in newFloors[4]
                  found = true
                end
              end
            end

            if found
              # VICTORY
              println("Found one!")
              exit()
            else
              # No victory yet, move again
              minTripsUp = BIG
              minTripsDown = BIG

              println("\u1b[1H")
              printFloors(newFloors, elevatorFloor)

              if elevatorFloor < 4
                minTripsUp = findMinimumTrips(recursionDepth, elevatorFloor + 1, newFloors, newElevator)
              end

              if elevatorFloor > 1
                minTripsDown = findMinimumTrips(recursionDepth, elevatorFloor - 1, newFloors, newElevator)
              end

              currentTrips = min(minTripsUp, minTripsDown) + 1

              if currentTrips > minimumTrips
                abort = true
              else
                minimumTrips = currentTrips
              end
            end
          end
          if found || abort break end
        end
        if found || abort break end
      end
      if found || abort break end
    end
    if found || abort break end
  end

  recursionDepth -= 1
  return minimumTrips
end

recursionDepth = 0

overallMinimumTrips = findMinimumTrips(recursionDepth, elevatorFloor, floors, elevator)

println("The minimum number of trips is: $overallMinimumTrips")
