#!/usr/bin/env python
import sys
from random import Random
random=Random()

if(len(sys.argv)>1):
	random.seed(sys.argv[1])

def chars(s):
	ret=[]
	for i in range(0, len(s)):
		ret.append(s[i])
	return ret

notes="CdDeEFgGaAbB"
minorNotes="degab"
notesL=chars(notes)
instruments=["sine", "square", "triangle", "sawtooth", "trapezium", "pluck", "exp", "pinknoise", "whitenoise", "brownnoise"]
melodicInstruments=["sine", "square", "triangle", "sawtooth", "trapezium", "pluck"]
roll={}

def convertNote(note, octave):
	octaveOffset=octave+1
	semitoneOffset=octaveOffset*12
	semitoneOffset+=notes.find(note)
	return "%"+str(69-semitoneOffset)

def position(note, octave, delta):
	offset=notes.find(note)
	offset+=delta
	octaveOffset=0
	if offset>12:
		octaveOffset=offset/12
	elif offset<0:
		octaveOffset=(offset/12)
		offset=12-abs(offset)
	return (notes[offset%12], octave+octaveOffset)

def toneRow():
	row=[]
	n=[]
	n.extend(notesL)
	while len(n)>0:
		note=random.choice(n)
		repeat=random.choice(range(1, 5))
		row.extend([note]*repeat)
		n.remove(note)
	return row
def convertRow(row, octave):
	ret=[]
	for note in row:
		ret.append(convertNote(note, octave))
	return ret
def invertRow(row):
	ret=[]
	for note in row:
		noteNum=int(note[1:])
		noteNum-=7
		ret.append("%"+str(noteNum))
	return ret
def retrogradeRow(row):
	ret=[]
	ret.extend(row)
	ret.reverse()
	return ret
def transposeRow(row, deltaOctaves):
	deltaNotes=deltaOctaves*12
	ret=[]
	for note in row:
		noteNum=int(note[1:])
		noteNum+=deltaNotes
		ret.append("%"+str(noteNum))
	return ret

def toneRowSequence(baseOctave, variance, variants):
	seq=""
	prime=convertRow(toneRow(), baseOctave)
	inverted=invertRow(prime)
	retrograde=retrogradeRow(prime)
	invertedRetrograde=retrogradeRow(inverted)
	pool=[prime, inverted, retrograde, invertedRetrograde]
	pool2=[prime, inverted, retrograde, invertedRetrograde]
	while len(pool2)>0:
		selected=random.choice(pool2)
		seq+=(" ".join(selected))
		seq+=" "
		pool2.remove(selected)
	pool2.extend(pool)
	for i in range(0, variants):
		deltaOctaves=random.choice(range(0, variance*2))-variance
		for row in pool:
			pool2.append(transposeRow(row, deltaOctaves))	
	while len(pool2)>0:
		selected=random.choice(pool2)
		seq+=(" ".join(selected))
		seq+=" "
		pool2.remove(selected)
	return seq

weightedInstrumentList=[]
weightedInstrumentList.extend(melodicInstruments)
weightedInstrumentList.extend(instruments)

seq=toneRowSequence(5, 3, 4)
mod=random.choice(weightedInstrumentList)
print("\t".join([mod, "4", "1", seq]))
print("\t".join([mod, "4", "1", seq]))

