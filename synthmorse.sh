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

cmd=$0
helpOptions=(h help)
paramOptions=(dit daw gain tempo octave)
paramTypes=(note note number number number)

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


function helpTopic() {
	topic=$1
	case $topic in
		desc)
			echo "${cmd}: read text from stdin and synthesize it as morse code"
			break
		;;
		usage)
			echo "$cmd [ $(helpTopic usage_help) | $(helpTopic usage_param) ] < textfile"
			break
		;;
		usage_help)
			echo -e "[\c"
			for i in $helpOptions ; do
				echo -e "-$i|\c"
			done
			echo -e "\b]"
			break
		;;
		usage_param)
			i=0
			while [[ $i -lt ${#paramOptions} ]] ; do
				echo -e "[ ${paramOptions[$i]} ${paramTypes[$i]} ] |\c"
				i=$((i+1))
			done
			echo -e "\b\b"
			break
		;;
		-(dit|daw))
			echo "Synthesize ${topic:1} as the provided note"
			break
		;;
		-gain)
			echo "Apply gain to the synthesized notes"
			break
		;;
		-tempo)
			echo "Set the number of notes per beat. By default, beats are $rat seconds long."
			break
		;;
		-octave)
			echo "Set the octave of the note."
			break
		;;
		options)
			for item in helpOptions paramOptions ; do
				helpTopic $item
			done
			break
		;;
		helpOptions)
			sep=""
			for item in $helpOptions ; do 
				echo -e "${sep}-${item}"
				if [[ -z "$sep" ]] ; then
					sep="\tor\t\tPrint this help\n"
				else
					sep="\tor\n"
				fi
			done
			break
		;;
		paramOptions)
			i=0
			while [[ $i -lt ${#paramOptions} ]] ; do
				echo -e "-${paramOptions[$i]} ${paramTypes[$i]}\t\t$(helpTopic ${paramOptions[$i]})\n"
				i=$((i+1))
			done
			break
		;;
		*)
			dprint "Topic not found: '$topic'.\n"
			break
		;;
	esac
	dprint "\n"
}

function printHelp() {
			dprint "$(helpTopic desc)\nUsage:\n\t$(helpTopic usage)\nOptions:\n$(helpTopic options | sed 's/^/	/g')"
#			dprint "$0: read text from stdin and synthesize it as morse code\n\n"
#			dprint "Usage:\n\t$0 [ [-h|-help] | [-dit note] [-daw note] [-gain number] [-tempo number] [-octave number] ] < textfile\n\n"
#			dprint "Options:\n"
#			dprint "\t-h\n"
#			dprint"\t\tor\t\tPrint this help\n"
#			dprint "\t-help\n\n"
#			dprint "\t-dit note\tSynthesize dit as the provided note (default:$dit)\n\n"
#			dprint "\t-daw note\tSynthesize daw as the provided note\n\n"
#			dprint "\t-gain number\tApply gain to the synthesized notes (default: $gain)\n\n"
#			dprint "\t-tempo number\tSet the number of notes per beat. By default, beats are $rat seconds long, so the default tempo of $tempo yields notes $(($rat/$tempo)) seconds long.\n\n"
#			dprint "\t-octave number\tSet the octave of the note (default: 3)\n\n"
#			dprint "NOTES:\nNotes are capital letters between A and G. (Flats are not yet reliably supported.)\n" 
			exit 1
}

while [[ "$#" -gt 0 ]] ; do
	opt=$1 ; shift
	case $opt in
		-(dit|daw|gain|octave|tempo))
			export $opt=$1
			[[ "$opt" == "-tempo" ]] && 
				{echo $tempo | grep -q '\.' || { tempo=${tempo}.0 } } # tempo must have a decimal component or else we get 0-length notes
			shift ; break
		;;
		-h|-help)
			printHelp
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

exit 1

morse | 
	sed 's/dit/'"$dit"'/g;s/daw/'"$daw"'/g' | # dit & daw become notes
	tr '\n' 'R' | sed 's/\([A-Z]\)R/\1 R/g;s/RR/R R/g' | # newlines become rests
	tr ' ' '\n' | # prepare for synthesis
		while read x ; do
			figprint $(echo $x | tr "R$dit$daw" ' _#' )
			synth $((rat/tempo)) $x$octave
			figprint ""
		done | play -p $playopts gain $gain

