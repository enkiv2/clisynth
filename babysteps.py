#!/usr/bin/env python
import sys
from random import Random
random=Random()

scale=sys.argv[1].split()
minStep=int(sys.argv[2])
maxStep=int(sys.argv[3])
length=int(sys.argv[4])

curr=random.randint(0, len(scale))
out=[]

for i in range(0, length):
    out.append(scale[curr])
    curr+=(random.randint(minStep, maxStep)*random.choice([-1, 1]))
    while(curr<0):
        curr+=len(scale)
    if(curr>=len(scale)):
        curr%=len(scale)
    while(curr<0):
        curr+=len(scale)

print(" ".join(out))

