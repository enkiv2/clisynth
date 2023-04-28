#!/usr/bin/env zsh
dit="B"
daw="C"
gain=-23
tempo=8.0
octave=3

showNotes=1
playopts="-q"
cols=$COLUMNS
figfont="standard"
figopts=""

. ./clisynth.sh

function dprint() {
	printf "$@" > /dev/stderr
}
function figprint() {
	if [[ "$showNotes" == "1" ]] ; then
		clear
		[[ -z "$@" ]] ||
			(printf "$@" | figlet -w $cols -f $figfont $figopts)
	fi > /dev/stderr
}

while [[ "$#" -gt 0 ]] ; do
	opt=$1 ; shift
	case $opt in
		-(dit|daw|gain|octave))
			export $opt=$1
			shift ; break
		;;
		-tempo)
			tempo=$1 ; shift
			echo $tempo | grep -q '\.' || { tempo=${tempo}.0 } # tempo must have a decimal component or else we get 0-length notes
			break
		;;
		-h|-help)
			dprint "$0: read text from stdin and synthesize it as morse code\n\nUsage:\n\t$0 [ [-h|-help] | [-dit note] [-daw note] [-gain number] [-tempo number] [-octave number] ] < textfile\n\nOptions:\n\t-h\n\t\tor\t\tPrint this help\n\t-help\n\n\t-dit note\tSynthesize dit as the provided note (default:$dit)\n\n\t-daw note\tSynthesize daw as the provided note\n\n\t-gain number\tApply gain to the synthesized notes (default: $gain)\n\n\t-tempo number\tSet the number of notes per beat. By default, beats are $rat seconds long, so the default tempo of $tempo yields notes $(($rat/$tempo)) seconds long.\n\n\t-octave number\tSet the octave of the note (default: 3)\n\nNOTES:\nNotes are capital letters between A and G. (Flats are not yet reliably supported.)\n" 
			exit 1
			break
		;;
		-*)
			echo -e "Unrecognized option '$opt'. Try running '$0 -h' for help." > /dev/stderr
			exit 1
			break
		;;
		*)
			echo -e "Unrecognized parameter '$opt'. Try running '$0 -h' for help." > /dev/stderr
			exit 1
			break
		;;
	esac
done


morse | 
	sed 's/dit/'"$dit"'/g;s/daw/'"$daw"'/g' | # dit & daw become notes
	tr '\n' 'R' | sed 's/\([A-Z]\)R/\1 R/g;s/RR/R R/g' | # newlines become rests
	tr ' ' '\n' | # prepare for synthesis
		while read x ; do
			figprint $(echo $x | tr "R$dit$daw" ' _#' )
			synth $((rat/tempo)) $x$octave
			figprint ""
		done | play -p $playopts gain $gain

