#!/usr/bin/env zsh
dit="B"
daw="C"
gain=-23
tempo=0.05
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
paramDefaults=($dit $daw $gain $tempo $octave)
paramDesc=(
	"Synthesize dit as the provided note"
	"Synthesize daw as the provided note"
	"Set the gain"
	"Set the length of a unit in seconds"
	"Set the octave"
)

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

function getParamType() {
	paramName=$1
	idx=${paramOptions[(ie)$paramName]}
	echo ${paramTypes[$idx]}
}
function getParamDefault() {
	paramName=$1
	idx=${paramOptions[(ie)$paramName]}
	echo ${paramDefaults[$idx]}
}
function getParamDesc() {
	paramName=$1
	idx=${paramOptions[(ie)$paramName]}
	echo ${paramDesc[$idx]}
}


function printHelp() {
			dprint "$cmd: read text from stdin and synthesize it as morse code\n\n"
			dprint "Usage\n\t"
			dprint "$cmd [ [$(echo helpOptions | tr '\n' '|')] | "
			sep=""
			for opt in $paramOptions ; do 
				dprint "${sep}[ -$opt $(getParamType $opt) ]"
				sep=" | "
			done
			dprint " ]\n"
			dprint "Options:\n"
			dprint "\t-h\n"
			dprint "\t\tor\t\tPrint this help\n"
			dprint "\t-help\n"
			dprint "\n"
			for opt in $paramOptions ; do
				dprint "\t-$opt\t\t\t$(getParamDesc $opt) (default: $(getParamDefault $opt))\n"
			done
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


morse | 
	sed 's/dit/'"$dit"'/g;s/daw/'"$daw"'/g' | # dit & daw become notes
	sed 's/^$/ R R R R /' | # a blank line represents a word break, which should have a total of seven units of rest; these are the four that are not covered later
	sed 's/$/ R R /' | # there should be a total of three units of rest between letters (these two plus the one at the end of the loop)
	tr ' ' '\n' | grep . | # prepare for synthesis
		while read x ; do
			figprint $(echo $x | tr "R$dit$daw" ' .-' )
			units=1.0
			[[ $x -eq $daw ]] && units=3.0
			synth $((units*tempo)) $x$octave
			figprint ""
			synth $((1.0*tempo)) R0
		done | play -p $playopts gain $gain

