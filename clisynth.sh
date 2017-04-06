#!/usr/bin/env zsh
o=3
mod=sine
rat=2
nhelp () {
	case $1 in 
		synth) 
			echo "Usage: synth <seconds> <note>"
			echo "<seconds> is the duration of the note in seconds."
			echo "<note> is the note in scientific pitch notation (NO, where N is the note letter and O is the octave)"
			echo "For instance:"
			echo -e "\tsynth 0.25 C3 | play -p"
			echo "will play a middle C for a quarter of a second, using the instrument specified by <mod>" 
		;;
		nso|neo|nqo) 
			echo "Usage: neo <note>"
			echo "<note> is the note letter"
			echo "The nso, neo, and nqo commands will play a sixteenth note, eighth note, or quarter note given at the octave specified by <o>, using the time signature specified by <rat>."
		;;
		nsos|neos|nqos) 
			echo "Usage: neos [<note> [<note> ...] ]"
			echo "<note> is the note letter"
			echo "The nso, neo, and nqo commands will play a sequence of sixteenth notes, eighth notes, or quarter notes given at the octave specified by <o>, using the time signature specified by <rat>."
		;;
		o) 
			echo "o is the octave. It is a number between 1 and 9, and is used in conjunction with the note in scientific pitch notation. For instance, C3 is the middle C." 
			echo "Default: 3"
		;;
		mod) 
			echo "mod is the instrument to synthesize. Supported values are: sine square triangle sawtooth pluck"
			echo "Default: sine"
		;;
		rat)
			echo "rat is the duration in seconds of a whole note. For half-second quarter notes (our default), set rat=2."
		;;
		general) 
			echo "Because these shell functions stream raw audio to standard output by default, they are typically used in conjunction with other sox utilities."
			echo "For instance, a typical routine for experimenting with audio might involve stringing together several calls to nsos or neos, piped into play -p. Once you've come up with something you'd like to save, pipe it into sox with a filename."
			echo "Example: "
			echo -e "\t(neos F E F D E C ; nqos D D) | play -p"
			echo "will play the first line of Dies Irae."
			echo -e "\tfor mod in square triangle pluck ; do for o in 1 2 3 4 5 6 7 8 9; do nsos A B C D E F G ; done ; done | play -p"
			echo "will play the complete scale in square waves, triangular waves, and plucked strings."
		;;
		*)
			echo "Welcome to clisynth"
			echo "Commands are: synth nso nqo nsos nqos"
			echo "Options are: o mod rat"
			echo "Run nhelp <command or option> for information about a particular command or option"
			echo "Run nhelp general for general usage information."
		;;
	esac
}
synth () { 
	if echo $2 | grep -q '^R' ; then
		sox -n -p synth $1 whitenoise gain -n -100
	else
		sox -n -p synth $1 $mod $2
	fi
}

ns () {
	synth $((rat/16.0)) $1
}
ne () {
	synth $((rat/8.0)) $1
}
nq () {
	synth $((rat/4.0)) $1
}

nso () { 
	echo "$1" | grep -q '^%' && ns "$1" || 
	ns $1$o
}
neo () { 
	echo "$1" | grep -q '^%' && ne "$1" || 
	ne $1$o
}
nqo () { 
	echo "$1" | grep -q '^%' && nq "$1" || 
	nq $1$o
}

nsos () { 
	for i in $@; do
		nso $i;
	done
}
neos () { 
	for i in $@; do
		neo $i;
	done
}
nqos () { 
	for i in $@; do
		nqo $i;
	done
}

sfilter() {
	sox -p -p $@
}
