#!/bin/python
# -*- coding: ascii -*-

# Advent of Code 2016
# Day 5
# 2016-12-05

# Python implementation
#
# In Python 2.7.10 (32-bit)
# Part 1 takes ~23.54s
# Part 2 takes ~63.59s
#
# In Python 2.7.12 (64-bit)
# Part 1 takes ~20.71s
# Part 2 takes ~57.06s
#
# In Python 3.5.2 (64-bit)
# Part 1 takes ~28.07s
# Part 2 takes ~75.11s
#
# In Julia 0.5 (64-bit)
# Part 1 takes ~12.02s
# Part 2 takes ~31.04s
#

import sys
import time
import hashlib

print("Advent of Code")
print("Day 5: How About a Nice Game of Chess?")
print("")
print("Part 1")

DOOR_ID = "ojvtpuvg"

def testHashPy27(testString):
    return hashlib.md5(testString).hexdigest()

def testHashPy35(testString):
    return hashlib.md5(testString.encode('utf-8')).hexdigest()

if sys.version_info[0] == 2:
    TestHash = testHashPy27
else:
    TestHash = testHashPy35

notFound = True
counter = 0
foundCounter = 0
password = ""

startTime = time.time()

while foundCounter < 8:
    #testHash = hashlib.md5("%s%d" % (DOOR_ID, counter)).hexdigest()
    #testHash = hashlib.md5(str("%s%d" % (DOOR_ID, counter)).encode('utf-8')).hexdigest()
    testHash = TestHash("%s%d" % (DOOR_ID, counter))

    if testHash[0:5] == "00000":
        foundCounter += 1
        password = password + testHash[5]
        print("%s" % password)

    counter += 1

endTime = time.time()
print("%f elapsed seconds." % (endTime - startTime))

print("The part 1 password for %s is %s (%d iterations)." % (DOOR_ID, password, counter))

# part 2
print("")
print("Part2")

notFound = True
counter = 0
foundCounter = 0
password = "--------"

startTime = time.time()

while foundCounter < 8:
    #testHash = hashlib.md5("%s%d" % (DOOR_ID, counter)).hexdigest()
    #testHash = hashlib.md5(str("%s%d" % (DOOR_ID, counter)).encode('utf-8')).hexdigest()
    testHash = TestHash("%s%d" % (DOOR_ID, counter))

    if testHash[0:5] == "00000":
        if testHash[5].isdigit():
            position = int(testHash[5])
            if position < 8:
                if password[position] == '-':
                    password = password[0:position] + str(testHash[6]) + password[position+1:]
                    foundCounter += 1
                    print("%s" % password)

    counter += 1

endTime = time.time()
print("%f elapsed seconds." % (endTime - startTime))

print("The part 2 password for %s is %s (%s iterations)." % (DOOR_ID, password, counter))


