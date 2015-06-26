#!/usr/bin/env python

import sys
from random import Random
random=Random()

for x in range(1, random.choice(range(5,25))):
	sys.stdout.write(random.choice(["A", "B", "C", "D", "E", "F", "G", "R"])+" ")
	sys.stdout.flush

