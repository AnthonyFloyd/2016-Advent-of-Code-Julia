#
# Advent of Code
# Day 13: A Maze of Twisty Little Cubicles
#

println("Advent of Code")
println("Day 13: A Maze of Twisty Little Cubicles")
println("")

import Base.Collections: PriorityQueue, enqueue!, dequeue!, peek
import Base.Order.Reverse

DEBUG = false

# test case
# SALT = 10
# (STARTX, STARTY) = (2,2)
# (GOALX, GOALY) = (8,5)
# MAZE_SIZE = 10

# part 1
SALT = 1362
(STARTX, STARTY) = (2,2)
(GOALX, GOALY) = (32,40)
MAZE_SIZE = 50

DIRS_X = [1, 0, -1, 0]
DIRS_Y = [0, 1, 0, -1]

MAZE = Dict([0=>".", 1=>"#", 2=>"O", 3=>"S", 4=>"F"])

function generateMaze(width::Int, height::Int)
  newMaze = Array{Int}(width, height)

  for y in 0:(height - 1)
    for x in 0:(width - 1)
      seed = x*x + 3*x + 2*x*y + y + y*y + SALT
      if isodd(sum([parse(string(item)) for item in bin(seed)]))
        # odd? wall.
        newMaze[x+1,y+1] = 1
      else
        # even? open.
        newMaze[x+1,y+1] = 0
      end
    end
  end
  return newMaze
end

function printMaze(maze::Array{Int})
  (rows, columns) = size(maze)
  for y in 1:rows
    row = ""
    for x in 1:columns
      row *= MAZE[maze[x,y]]
    end
    println(row)
  end
end

type Node
  x::Int
  y::Int
  distance::Float64
  priority::Float64
end

function updatePriority(node, goalx, goaly)
  node.priority = node.distance + sqrt((goalx - node.x)^2 + (goaly - node.y)^2) * 10.
end

function findShortestPath(startx::Int, starty::Int, endx::Int, endy::Int, maze::Array{Int})
  #
  # Implements the A* path-finding algorithm, based on example found at
  # http://code.activestate.com/recipes/577519-a-star-shortest-path-algorithm/
  #
  mazeWidth, mazeHeight = size(maze)

  evaluatedNodes = zeros(Float64, (mazeWidth, mazeHeight)) # "closed nodes map"
  potentialNodes = zeros(Float64, (mazeWidth, mazeHeight)) # "open nodes map"
  directions = ones(Int64, (mazeWidth, mazeHeight)) # directions to end

  priorityQueues = Vector{PriorityQueue}()                     # reverse priority queues because
  push!(priorityQueues, PriorityQueue(Node, Float64, Reverse)) # we want to take the highest
  push!(priorityQueues, PriorityQueue(Node, Float64, Reverse)) # priority, not the lowest

  # initialization
  priorityQueueIndex = 1

  startNode = Node(startx, starty, 0., 0.)
  updatePriority(startNode, endx, endy)
  enqueue!(priorityQueues[priorityQueueIndex], startNode, startNode.priority)
  potentialNodes[startx, starty] = startNode.priority

  # A* search
  while length(priorityQueues[priorityQueueIndex]) > 0
    # get next node with highest priority
    nextNode = deepcopy(dequeue!(priorityQueues[priorityQueueIndex]))
    (x, y) = (nextNode.x, nextNode.y)
    potentialNodes[x, y] = 0.
    evaluatedNodes[x, y] = 1.

    # are we there yet?
    if x == endx && y == endy
      # done, work backwards from finish to start
      shortestPath = 0
      maze[x, y] = 4 # finish symbol
      while !(x == startx && y == starty)
        direction = directions[x,y]
        shortestPath += 1
        x -= DIRS_X[direction]
        y -= DIRS_Y[direction]
        maze[x,y] = 2 # path symbol
      end
      maze[x,y] = 3 # start symbol
      return (maze, shortestPath)
    end

    # where to move now?
    for direction in 1:4
      # try each direction
      newx = x + DIRS_X[direction]
      newy = y + DIRS_Y[direction]

      # eliminate disallowed places:
      #    outside the maze
      #    wall
      #    already evaluated

      if !(newx < 1 || newx > mazeWidth || newy < 1 || newy > mazeHeight || maze[newx, newy] == 1 || evaluatedNodes[newx, newy] == 1)
        # make a new node
        newNode = Node(newx, newy, nextNode.distance + 10., nextNode.priority)
        updatePriority(newNode, endx, endy)

        if DEBUG println("New node at ", newx, ", ", newy, " with priority ", newNode.priority) end

        if potentialNodes[newx, newy] == 0.
          # if this wasn't a potential node before, assign the potential w/ new priority
          potentialNodes[newx, newy] = newNode.priority

          # put the node in the priority queue
          enqueue!(priorityQueues[priorityQueueIndex], newNode, newNode.priority)

          # indicate how we got here
          directions[newx, newy] = direction

        elseif potentialNodes[newx, newy] > newNode.priority
          # if we're putting a higher priority node here, swap for it
          potentialNodes[newx, newy] = newNode.priority

          # how did we get here
          directions[newx, newy] = direction

          # swap the old node for this higher-priority node
          while !(peek(priorityQueues[priorityQueueIndex]).x == newx && peek(priorityQueues[priorityQueueIndex]).y == newy)
            tempNode = dequeue!(priorityQueues[priorityQueueIndex])
            enqueue!(priorityQueues[3-priorityQueueIndex], tempNode)
          end

          tempNode = dequeue!(priorityQueues[priorityQueueIndex]) # remove the node

          if length(priorityQueues[priorityQueueIndex]) > length(priorityQueues[1-priorityQueueIndex])
            priorityQueueIndex = 3 -  priorityQueueIndex
          end

          while length(priorityQueues[priorityQueueIndex]) > 0
            tempNode = dequeue!(priorityQueues[priorityQueueIndex])
            enqueue!(priorityQueues[3-priorityQueueIndex], tempNode)
          end

          priorityQueueIndex = 3 -  priorityQueueIndex

          # put the better node on
          enqueue!(priorityQueues[priorityQueueIndex], newNode)
        end
      end
    end
  end

  # didn't find solution

  return (maze, 99999)

end

maze = generateMaze(MAZE_SIZE, MAZE_SIZE)

(maze, shortestPath) = findShortestPath(STARTX, STARTY, GOALX, GOALY, maze)
println("The shortest path is $shortestPath.")
printMaze(maze)

# part 2 is trying to find all the places we can reach within a distance
# of 50 steps

# Just brute force it.

maze = generateMaze(MAZE_SIZE, MAZE_SIZE)

nPaths = 0

for currentx in 1:50
  for currenty in 1:50
    if maze[currentx, currenty] == 0
      validMaze = deepcopy(maze)
      (maze, shortestPath) = findShortestPath(STARTX, STARTY, currentx, currenty, maze)
      if !(shortestPath <= 50)
        maze = validMaze
      else
        nPaths += 1
      end
    end
  end
end

# Now count non-zero and non-one entries

nReached = 0
for currentx in 1:50
  for currenty in 1:50
    if maze[currentx, currenty] > 1
        nReached += 1
    end
  end
end

println("")
println("$nReached distinct locations can be reached within 50 steps, by $nPaths paths.")

printMaze(maze)
