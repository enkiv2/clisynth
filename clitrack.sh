#!/usr/bin/env zsh

helpstring="
 FORMAT:
 one track per line, two tab-separated columns
 First column: mod
 Second column: space-separated notes

 Usage:
 ./clitrack.sh [neos|nsos|nqos] output.wav < input.txt
"

case $1 in
	neos)  ;;
	nsos)  ;;
	nqos)  ;;
	*) echo "$helpstring" ; return 1 ;;
esac


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

