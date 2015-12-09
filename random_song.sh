#!/usr/bin/env zsh

# My compositional technique is pretty formulaic, so let's try a generative hell parody of it

source clisynth.sh
for i in 1 2 3 ; do
	neos $(./randomMelody.py | tee /dev/stderr ) | sox -p $i.wav
done
for i in 1 2 3 ; do
	for j in 1 2 3 ; do
		sox --combine merge $i.wav $j.wav ${i}-${j}.wav
		for k in 1 2 3 ; do
			sox --combine mix ${i}-${j}.wav $k.wav ${i}-${j}-${k}.wav
		done
	done
done
sox 1-1.wav 1-1.wav 1-2.wav 1-1.wav 1-2.wav 1-1.wav 1-2-3.wav 1-3.wav 1-2-3.wav 1-3.wav 2-3.wav 3-3.wav 2-3.wav 3-3.wav 1-2-3.wav 1-3.wav 1-2-3.wav 1-3.wav 2-3.wav 3-3.wav 2-3.wav 3-3.wav 2-2.wav 1-3.wav 2-2.wav 1-3.wav 2-3.wav 3-3.wav 2-3.wav 3-3.wav 1-3.wav 2-2.wav 1-3.wav 2-2.wav 1-2-3.wav 1-3.wav 1-2-3.wav 2-3.wav 1-2-3.wav 1-3.wav 1-2-3.wav 2-3.wav output.wav

