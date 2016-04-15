#!/usr/bin/env zsh

source ./clisynth.sh


notecmd=$1
out=$2

i=0
components=""
while read -r x ; do
	components="$components $i.wav"
	mod=$(echo $x | cut -f 1)
	$notecmd `echo $x | cut -f 2-` | sox -p $i.wav
	i=$((i+1))
done

set -o SH_WORD_SPLIT
sox -m $components $out

