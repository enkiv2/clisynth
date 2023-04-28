#!/usr/bin/env zsh
dit="B"
daw="C"
gain=-23

. ./clisynth.sh

while read x ; do 
	neos $(
		echo "$x" | 
			morse | 
			sed 's/dit/'"$dit"'/g;s/daw/'"$daw"'/g' | 
			tr '\n' 'R' | 
			sed 's/\([A-Z]\)R/\1 R/g;s/RR/R R/g'
	)
done | play -p gain $gain

