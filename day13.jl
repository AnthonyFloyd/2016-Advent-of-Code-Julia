#
# Advent of Code
# Day 13: A Maze of Twisty Little Cubicles
#

println("Advent of Code")
println("Day 13: A Maze of Twisty Little Cubicles")
println("")

import Base.Collections: PriorityQueue, enqueue!, dequeue!, peek
import Base.Order.Reverse

DEBUG = true
SALT = 10 # test case
(STARTX, STARTY) = (2,2)
(GOALX, GOALY) = (8,5)

DIRS_X = [1, 0, -1, 0]
DIRS_Y = [0, 1, 0, -1]

MAZE = Dict([0=>".", 1=>"#", 2=>"S", 3=>"O", 4=>"F"])

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

type node
  x::Int
  y::Int
  distance::Float64
  priority::Float64
end

function updatePriority(node, goalx, goaly)
  node.priority = node.distance + sqrt((goalx - node.x)^2 + (goaly - node.y)^2) * 10.
end

function findShortestPath(startx::Int, starty::Int, endx::Int, endy::Int, maze::Array{Int})

  mazeWidth, mazeHeight = size(maze)

  evaluatedNodes = zeros(Float64, (mazeWidth, mazeHeight)) # "closed nodes map"
  potentialNodes = ones(Float64, (mazeWidth, mazeHeight)) # "open nodes map"
  directions = zeros(Float64, (mazeWidth, mazeHeight)) # directions to end

  priorityQueues = Vector{PriorityQueue}()
  push!(priorityQueues, PriorityQueue(Node, Float64, Reverse))
  push!(priorityQueues, PriorityQueue(Node, Float64, Reverse))

  # initialize
  priorityQueueIndex = 0

  startNode = node(startx, starty, 0., 0.)
  updatePriority(startNode)
  enqueue!(priorityQueues[priorityQueueIndex], startNode, startNode.priority)
  potentialNodes[startx, starty] = startNode.priority

  # A* search
  while length(priorityQueues[priorityQueueIndex]) > 0
    # get node with highest priority
    currentNode = dequeue!(priorityQueues[priorityQueueIndex])
    duplicateNode = deepcopy(currentNode)
    (x, y) = (duplicateNode.x, duplicateNode.y)
    potentialNodes[x, y] = 0.
    evaluatedNodes[x, y] = 1.

    # are we there yet?
    if x == GOALX and y == GOALY
      # done, work backwards from finish to start
      shortestPath = 0
      maze[x, y] = 4
      while !(x == startx && y == starty)
        direction = directions[x,y]
        shortestPath += 1
        x += DIRS_X[direction]
        y += DIRS_Y[direction]

        maze[x,y] = 3
      end

      maze[x,y] = 2

      return (maze, shortestPath)
    end

    # where to move now?
    for direction in 1:4
      newx = x + DIRS_X[direction]
      newy = y + DIRS_Y[direction]
      if !(newx < 1 || newx > mazeWidth || newy < 1 || newy > mazeHeight || maze[newx, newy] == 1 || evaluatedNodes[newx, newy] == 1)
        # make a new node
        newNode = node(newx, newy, duplicateNode.distance + 10., duplicateNode.priority)
        updatePriority(newNode)

        if potentialNodes[newx, newy] == 0.
          potentialNodes[newx, newy] = newNode.priority
          enqueue!(priorityQueues[priorityQueueIndex], newNode, newNode.priority)
          push!(directions, direction)
        elseif potentialNodes[newx, newy] > newNode.priority
          potentialNodes[newx, newy] = newNode.priority
          directions[newx, newy] = direction
          # swap the old node for this higher-priority node
          while !(peek(priorityQueues[priorityQueueIndex]).x == newx && peek(priorityQueues[priorityQueueIndex]).y == newy)
            tempNode = dequeue!(priorityQueues[priorityQueueIndex])
            enqueue!(priorityQueues[1-priorityQueueIndex], tempNode)
          end

          tempNode = dequeue!(priorityQueues[priorityQueueIndex]) # remove the node

          if length(priorityQueues[priorityQueueIndex]) > length(priorityQueues[1-priorityQueueIndex])
            priorityQueueIndex = 1 -  priorityQueueIndex
          end

          while length(priorityQueues[priorityQueueIndex]) > 0
            tempNode = dequeue!(priorityQueues[priorityQueueIndex])
            enqueue!(priorityQueues[1-priorityQueueIndex], tempNode)
          end

          priorityQueueIndex = 1 -  priorityQueueIndex

          # put the better node on
          enqueue!(priorityQueues[priorityQueueIndex], newNode)
        end
      end
    end
  end

  # didn't find solution

  return (maze, big(Int64))

end

maze = generateMaze(10,10)

(maze, shortestPath) = findShortestPath(STARTX, STARTY, GOALX, GOALY, maze)
println("The shortest path is $shortestPath.")
printMaze(maze)
