#!/usr/bin/env zsh


helpstring="
 FORMAT:
 one track per line, three tab-separated columns
 First column: mod
 Second column: octave
 Third column: channel number
 Forth column: space-separated notes

 Usage:
 ./clitrack.sh [neos|nsos|nqos] output.wav [|1|2] < input.txt

The first arg is the command to pass to clisynth (indicating note length) ; the second is the output filename; the third is an optional verbosity level (1 will print progress as a series of dots, while 2 is high verbosity; the default is no messages)
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
verbose=$3

pid=$$

pfx="clitrack pid=$pid output=\"$out\":		"

debugprint() {
	if [[ "$verbose" == "2" ]] ; then
		echo "${pfx}$@"
	elif [[ "$verbose" == "1" ]] ; then
		echo -e ".\c"
	fi
}

i=0
components=""
sed 's/#.*$//' | grep . | while read -r x ; do
	debugprint "Starting synthesis of track $i..."
	components="$components $i.$pid.wav"
	mod=$(echo $x | cut -f 1 | tr -d ' ')
	o=$(echo $x | cut -f 2 | tr -d ' ')
	channel=$(echo $x | cut -f 3 | sed 's/  */ /g;s/ $//;s/^ //')
	$notecmd `echo $x | cut -f 4-`  | sox -p  $i.$pid.wav channels 2 remix 1 $channel &
	i=$((i+1))
done

debugprint "Waiting for synthesis to finish..."
wait
debugprint "Mastering..."
set -o SH_WORD_SPLIT
sox -m $components -b 16 "$out"
debugprint "Cleaning up..."
rm -f $components
debugprint "Done."
if [[ "$verbose" == "1" ]] ; then echo "$out" ; fi

