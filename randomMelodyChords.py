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

def major(note, octave):
	return [(note, octave), position(note, octave, 3), position(note, octave, 4)]

def minor(note, octave):
	return [(note, octave), position(note, octave, 4), position(note, octave, 3)]

def addToRoll(note, octave, ticks):
	if not octave in roll:
		roll[octave]=[{ticks:note}]
		return
	for track in roll[octave]:
		if not ticks in track:
			track[ticks]=note
			return
	roll[octave].append({ticks:note})

def addChordToRoll(chord, ticks):
	for n in chord:
		addToRoll(n[0], n[1], ticks)

def addChordsToRoll(chords, ticks, delta):
	i=ticks
	for chord in chords:
		addChordToRoll(chord, i)
		i+=delta

def printRoll(instrument, channel=""):
	mx=0
	for octave in roll:
		for track in roll[octave]:
			ticks=track.keys()
			ticks.sort()
			m=ticks[-1]
			mx=max(mx, m)
	for octave in roll:
		for track in roll[octave]:
			sys.stdout.write(instrument+"\t"+str(octave)+"\t"+str(channel)+"\t")
			for i in range(0, mx):
				if i in track.keys():
					sys.stdout.write(convertNote(track[i], octave))
				else:
					sys.stdout.write("R")
				sys.stdout.write(" ")
			sys.stdout.write("\n")
def progression(root, firstMajor, secondMajor, delta):
	if(firstMajor):
		m=major(*root)
	else:
		m=minor(*root)
	newRoot=position(root[0], root[1], delta)
	if(secondMajor):
		m2=major(*newRoot)
	else:
		m2=minor(*newRoot)
	return [m, m2]

def melancholyProgression(root):
	m=major(*position(root[0], root[1], 12))
	m2r=position(root[0], root[1], 4)
	m2=[(m[0][0], m[0][1]-1), m[1], m[2]]
	m.append(root)
	m2.append(m2r)
	return [m, m2]

def randomNote():
	return (random.choice(notesL), random.choice(range(1, 8)))
def randomProgression():
	return random.choice([
		progression(randomNote(), random.choice([True, False]), random.choice([True, False]), random.choice(range(0, 12))),
		melancholyProgression(randomNote())
		])

def randomSeq(length):
	ret=[]
	for i in range(0, length):
		ret.append([randomNote()])
	return ret

def randomSequences(length, count):
	ret=[]
	for i in range(0, count):
		ret.append(randomSeq(length))
	return ret

def generate(length, tempo, sectionCount, repeats):
	global roll
	roll={}
	noteCount=length/tempo
	
	progressionTempoModifier=random.choice([1, 2, 4])
	progressionNoteCount=noteCount/(progressionTempoModifier*2)
	addChordsToRoll(randomProgression()*progressionNoteCount, 0, progressionTempoModifier)
	printRoll(random.choice(instruments))
	
	melodyTempoModifier=random.choice([1, 2, 4])
	melodyNoteCount=noteCount/melodyTempoModifier
	melodyNoteCount=melodyNoteCount/sectionCount
	melodyNoteCount=melodyNoteCount/repeats
	motifs=randomSequences(melodyNoteCount, sectionCount)
	motifPool=[]
	for motif in motifs:
		for i in range(0, repeats):
			motifPool.append(motif)
		motifPool.append(motif)
	ticks=0
	for i in range(0, len(motifPool)):
		roll={}
		addChordsToRoll(random.choice(motifPool), ticks, melodyTempoModifier)
		ticks+=melodyNoteCount
		printRoll(random.choice(instruments))
for i in range(0, random.choice(range(1, 4))):	
	generate(random.choice(range(1, 5))*8*60+random.choice(range(0, 60)), random.choice(range(1, 8)), random.choice(range(2, 8)), random.choice(range(1, 4)))

