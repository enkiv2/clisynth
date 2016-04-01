#!/usr/bin/env zsh

# My compositional technique is pretty formulaic, so let's try a generative hell parody of it

source clisynth.sh
for i in 1 2 3 4 5 ; do
	export mod=$(echo -e "sine\nsquare\ntriangle\nsawtooth\npluck" | shuf -n 1)
	export o=$((RANDOM%9))
	echo "$mod $o"
	$(echo -e "neos\nnsos\nnqos" | shuf -n 1) $(./randomMelody.py | tee /dev/stderr ) | sox -p $i.wav
done
for i in 1 2 3 4 5; do
	for j in 1 2 3 4 5 ; do
		sox --combine merge $i.wav $j.wav ${i}-${j}.wav
		for k in 1 2 3 4 5 ; do
			sox --combine mix-power ${i}-${j}.wav $k.wav ${i}-${j}-${k}.wav
		done
	done
done
sox $(ls {1..5}-{1..5}.wav | shuf) $(ls {1..5}-{1..5}.wav {1..5}-{1..5}-{1..5}.wav | shuf) output.wav
#sox 1-1.wav 1-1.wav 1-2.wav 1-1.wav 1-2.wav 1-1.wav 1-2-3.wav 1-3.wav 1-2-3.wav 1-3.wav 2-3.wav 3-3.wav 2-3.wav 3-3.wav 1-2-3.wav 1-3.wav 1-2-3.wav 1-3.wav 2-3.wav 3-3.wav 2-3.wav 3-3.wav 2-2.wav 1-3.wav 2-2.wav 1-3.wav 2-3.wav 3-3.wav 2-3.wav 3-3.wav 1-3.wav 2-2.wav 1-3.wav 2-2.wav 1-2-3.wav 1-3.wav 1-2-3.wav 2-3.wav 1-2-3.wav 1-3.wav 1-2-3.wav 2-3.wav 4-4.wav 4-4.wav 4-5.wav 4-4.wav 4-5.wav 4-4.wav 4-5-3.wav 4-3.wav 4-5-3.wav 4-3.wav 5-3.wav 3-3.wav 5-3.wav 3-3.wav 4-5-3.wav 4-3.wav 4-5-3.wav 4-3.wav 5-3.wav 3-3.wav 5-3.wav 3-3.wav 5-5.wav 4-3.wav 5-5.wav 4-3.wav 5-3.wav 3-3.wav 5-3.wav 3-3.wav 4-3.wav 5-5.wav 4-3.wav 5-5.wav 4-5-3.wav 4-3.wav 4-5-3.wav 5-3.wav 4-5-3.wav 4-3.wav 4-5-3.wav 5-3.wav output.wav
