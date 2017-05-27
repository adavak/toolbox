#!/usr/bin/python
import random, math

def roll(dice):
	return (int(random.random() * dice) + 1)

def mymain():
	val = int(raw_input("Enter the dice value (number only) > "))
	iterations = int(raw_input("Enter number of times you want to roll > "))
	summation = 0
	for x in range (0, iterations):
		a = roll(val)
		if iterations > 1:		
			summation = summation + a
		print "d" + str(val) + " rolled: " + str(a)
	
	if summation > 0:
		print "Total of roll: " + str(summation)
	response = raw_input("Roll again? (Y/n) > ")
	if (response == "Y" or response == "y"):
		mymain()

print "Welcome to the D&D virtual dice program"

mymain()