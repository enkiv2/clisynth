#!/usr/bin/env python
instrument="sine"
import sys

def lcm(x, y):
	stopping=min(x, y)
	i=2
	while i<stopping:
		if(x%i == 0 and y%i == 0):
			return i
		i+=1
	return 0
def reduce(x, y):
	d=lcm(x,y)
	if(d==0):
		return [x, y]
	else:
		return [x/d, y/d]
def convertNote(note, octave):
	octaveOffset=octave+1
	semitoneOffset=octaveOffset*12
	semitoneOffset+="CdDeEFgGaAbB".find(note)
	return "%"+str(69-semitoneOffset)
def shiftNotesCents(n, step, octave):
	ret=[]
	for note in n:
		if(note=="R"):
			ret.append(note)
		else:
			if(note[0]!="%"):
				note=convertNote(note, octave)
			ret.append("%"+str(int(note[1:])+step))
	return ret
def shiftNotes(n, step, octave):
	return shiftNotesCents(n, 12*step, octave)
notes=[]
mode=sys.argv[1]
notes=sys.argv[2].split()
if mode=="round":
	start_octave=int(sys.argv[3])
	voices=int(sys.argv[4])
	step=int(sys.argv[5])
	rows=[]
	rows.append(str(start_octave)+"\t1\t"+(" ".join(notes*voices)))
	for i in range(1, voices+1):
		row=str(start_octave+(i*step))+"\t"+str((i%2)+1)+"\t"
		for j in range(0, i):
			row+=(" ".join(["R"]*len(notes)))
			row+=" "
		for j in range(i, voices+1):
			row+=(" ".join(shiftNotes(notes, i*step, start_octave)))+" "
		rows.append(row)
	for r in rows:
		print(instrument+"\t"+r)
elif mode=="prolation":
	start_octave=int(sys.argv[3])
	step=int(sys.argv[4])
	numerator=int(sys.argv[5])
	denominator=int(sys.argv[6])
	x=reduce(numerator, denominator)
	other=[x[1], x[0]]
	octaves=[start_octave, start_octave+step]
	for i in range(0, 2):
		row="\t".join([instrument, str(octaves[i]), str(i+1)])
		seq=[]
		for j in range(0, other[i]):
			for note in notes:
				seq.extend([note]*x[i])
		if(i>0):
			seq=shiftNotes(seq, step, start_octave)
		print(row+"\t"+(" ".join(seq)))
elif mode=="crab":
	start_octave=int(sys.argv[3])
	step=int(sys.argv[4])
	print("\t".join([instrument, str(start_octave), "1", " ".join(notes)]))
	notes.reverse()
	print("\t".join([instrument, str(start_octave+step), "2", " ".join(notes)]))
elif mode=="mirror":
	start_octave=int(sys.argv[3])
	step=int(sys.argv[4])
	print("\t".join([instrument, str(start_octave), "1", " ".join(notes)]))
	print("\t".join([instrument, str(start_octave+step), "2", " ".join(shiftNotesCents(notes, -7, start_octave+step))]))
elif mode=="table":
	start_octave=int(sys.argv[3])
	step=int(sys.argv[4])
	print("\t".join([instrument, str(start_octave), "1", " ".join(notes)]))
	notes.reverse()
	print("\t".join([instrument, str(start_octave+step), "2", " ".join(shiftNotesCents(notes, -7, start_octave+step))]))

