#!/usr/bin/env python
import sys

rows=[]

for line in sys.stdin.readlines():
	if(line[0]!="#") and len(line)>1:
		rows.append(line.rstrip().split("\t"))
i=0
for row in rows:
	instrument=row[0]
	octave=row[1]
	channel=row[2]
	notes=row[3].split()
	outNotes=["R"]*i
	for note in notes:
		outNotes.append(note)
		outNotes.extend(["R"]*(len(rows)-1))
	outNoteS=" ".join(outNotes)
	print("\t".join([instrument, octave, channel, outNoteS]))
	i+=1

