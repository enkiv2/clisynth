#!/usr/bin/env zsh
dit="B"
daw="C"
gain=-23
tempo=8.0
octave=3

. ./clisynth.sh

morse | 
	sed 's/dit/'"$dit"'/g;s/daw/'"$daw"'/g' | # dit & daw become notes
	tr '\n' 'R' | sed 's/\([A-Z]\)R/\1 R/g;s/RR/R R/g' | # newlines become rests
	tr ' ' '\n' | # prepare for synthesis
		while read x ; do
			synth $((rat/tempo)) $x$octave
		done | play -p gain $gain

