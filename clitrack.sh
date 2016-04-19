#!/usr/bin/env zsh

helpstring="
 FORMAT:
 one track per line, three tab-separated columns
 First column: mod
 Second column: octave
 Third column: channel number
 Forth column: space-separated notes

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
sed 's/#.*$//' | grep . | while read -r x ; do
	components="$components $i.wav"
	mod=$(echo $x | cut -f 1 | tr -d ' ')
	o=$(echo $x | cut -f 2 | tr -d ' ')
	channel=$(echo $x | cut -f 3 | sed 's/  */ /g;s/ $//;s/^ //')
	$notecmd `echo $x | cut -f 4-` | sox -p  $i.wav channels 2 remix 1 $channel
	i=$((i+1))
done

set -o SH_WORD_SPLIT
sox -m $components $out

