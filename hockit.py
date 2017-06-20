#!/usr/bin/env python
import sys

def printHelp():
	print("Usage: hockit.py note_sequence number_of_tracks instrument octave [instrument octave...]\nhockit creates a hocket out of a note sequence by distributing notes between tracks in a round-robin fashion")
	sys.exit(1)

if(len(sys.argv)<4):
	printHelp()
notes=sys.argv[1].split()
instrumentCount=int(sys.argv[2])
if(len(sys.argv)<2*(instrumentCount+1)):
	printHelp()
instruments=[]
for i in range(0, instrumentCount):
	instruments.append((sys.argv[(2*i)+3], sys.argv[(2*i)+4]))
tracks={}
for i in range(0, len(notes)):
	for j in range(0, instrumentCount):
		if not (j in tracks):
			tracks[j]=[]
		if((i%instrumentCount)==j):
			tracks[j].append(notes[i])
		else:
			tracks[j].append("R")
for i in range(0, instrumentCount):
	print("\t".join([instruments[i][0], instruments[i][1], str((i%2)+1), " ".join(tracks[i])]))

