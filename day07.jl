#
# Advent of Code
# Day 7: Internet Protocol Version 7
#
println("Advent of Code")
println("Day 7: Internet Protocol Version 7")
println("")

# Data file
# Input data has been saved to this file
inputDataFileName = "day07-input.txt"

# Read the input data, parse it down to a list of "commands"
inputDataFile = open(inputDataFileName, "r")
inputData = readstring(inputDataFile)
close(inputDataFile)

# part 1 test data
#inputData = """abba[mnop]qrst
#abcd[bddb]xyyx
#aaaa[qwer]tyui
#ioxxoj[asdfgh]zxcvbn"""

# part 2 test data
#inputData = """aba[bab]xyz
#xyx[xyx]xyx
#aaa[kek]eke
#zazbz[bzb]cdb"""

inputDataLines = split(strip(inputData), '\n')

function isABBA(window::SubString{String})
  # If string matches ABBA, return true
  # NB: AAAA is not allowed

  if window[1] == window[4]
    if window[2] == window[3]
      if window[1] != window[2]
        return true
      end
    end
  end

  return false
end

function isABA(window::SubString{String})
  # If string matches ABA, return true
  # NB: AAA is not allowed

  if window[1] == window[3]
    if window[1] != window[2]
      return true
    end
  end
  return false
end

function isBAB(ABA::SubString{String}, window::SubString{String})
  # If string is inverse of ABA: BAB, return true
  #
  if ABA[1] == window[2]
    if ABA[2] == window[1]
      if ABA[2] == window[3]
        if ABA[3] == window[2]
          return true
        end
      end
    end
  end
  return false
end

nFoundPart1 = 0
nFoundPart2 = 0

for line in inputDataLines
  inHypernet = false
  supportsTLS = false
  supportsSSL = false
  ABA = ""
  hasABA = false
  rejected = false

  for counter in 1:length(line)-2
    # step through all the characters,
    # setting state if we're in the Hypernet card
    # or not
    if line[counter] == '['
      inHypernet = true
    elseif line[counter] == ']'
      inHypernet = false
    end

    # check part 1 ABBA pattern first
    if counter <= length(line) - 3
      if isABBA(line[counter:counter+3])
        # ABBA patterns are only "counted" outside the Hypernet cards
        if !inHypernet
          # don't break out, there may be a pattern in a
          # subsequent Hypernet card that rejects this IP
          supportsTLS = true
        else
          # rejected. Can't break out, due to part 2 processing
          supportsTLS = false
          rejected=true
        end
      end
    end

    # only evaluate "SSL" ABA:BAB patterns if we haven't found
    # one yet. This avoids double-counting.

    if !supportsSSL
      # Find each ABA pattern, one at a time
      if isABA(line[counter:counter+2])
        if !inHypernet
          # now we need to search for matching BAB patterns
          # in the Hypernet cards
          hasABA = true
          ABA = line[counter:counter+2]
          inSubHypernet = false # need to keep track of this separately

          # It seems awful to loop within the loop but we need
          # to capture cases where the ABA occurs after the BAB-containing
          # hypernet cards
          for subCounter in 1:length(line)-2
            if line[subCounter] == '['
              inSubHypernet = true
            elseif line[subCounter] == ']'
              inSubHypernet = false
            end

            # BABs only occur in the Hypernet cards
            if inSubHypernet
              if isBAB(ABA, line[subCounter:subCounter+2])
                # it's okay to break out here, there's nothing that
                # will invalidate this if we find a BAB match
                supportsSSL = true
                nFoundPart2 += 1
                break
              end
            end
          end
        end
      end
    end
  end

  # part 1 summing
  if supportsTLS && !rejected
    nFoundPart1 += 1
  end
end

println("Found $nFoundPart1 TLS-supporting IPs.")
println("Found $nFoundPart2 SSL-supporting IPs.")
