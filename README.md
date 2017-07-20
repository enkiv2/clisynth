# clisynth
A set of shell functions and command line tools for command line music composition and synthesis

This repository contains several distinct programs related to command line music composition. Each uses simple, text-based formats and avoids large or unusual dependencies. The goal is to be a suite of tools for music composition & production that can be used without a GUI, soundfonts, specialized hardware, or complicated external libraries, accessible to programmers who are not accustomed to musical notation, with hackable tools & generators that present an introduction to ideas from music theory in a way that caters to a programmer mindset.

## clisynth.sh

clisynth.sh contains a set of shell functions for synthesizing music, as a frontend to sox

Requirements:
- sox
- zsh

How to use:

```
. ./clisynth.sh
nhelp
```

## clitrack.sh

clitrack.sh is a tracker front-end for clisynth.sh, using a simple tsv format

How to use:

```
./clitrack.sh command output_filename < tracker_file
# command here is one of the three synthesis commands provided by clisynth.sh: neos (eighth notes), nsos (sixteenth notes), or nqos (quarter notes)
# The tracker file is in TSV format, where the first column is an instrument name (supported by sox), the second is an octave number, 
# the third is a channel number, and the fourth is a space-separated sequence of notes
# Notes are either capital letters A-G and R (for rest) or cent numbers prefixed with '%'
# Each line is a new track; lines beginning with '#' are ignored
```

## music generation scripts

random_song.sh - produces a song by creating a pool of phrases (completely random note sequences) and organizing them in a repeating pattern

randomMelodyChords.py - creates a tracker file for clitrack, representing a song with a repeating random chord progression and a repeating (random) melodic phrase

twelvetone.py - creates a tracker file for clitrack representing a composition created following Schoenberg's rules for twelve-tone chromatic compositions

## composition aids

canonize.py - given a sequence of notes, it produces a canon of specified type in a format suitable for input into clitrack.sh

```
# Create a round out of the beginning of dies irae, starting at octave 2
# with three additional voices, increasing the octave by one with each added voice
./canonize.py round "F E F D E C D D R F F G F E D C E F E D R" 2 3 1 

# Create a prolation canon where the first voice is in the second octave and
# the second voice is in the third octave, with a tempo ratio of 4:5 between
# the first and second voices
./canonize.py prolation "F E F D E C D D R F F G F E D C E F E D R" 2 1 4 5

# Create a crab canon where the first voice is octave 2 and the second is 
# octave 3
./canonize.py crab "F E F D E C D D R F F G F E D C E F E D R" 2 1

# Create a mirror canon where the first voice is octave 2 and the second is 
# octave 3
./canonize.py mirror "F E F D E C D D R F F G F E D C E F E D R" 2 1

# Create a table canon where the first voice is octave 2 and the second is 
# octave 3
./canonize.py table "F E F D E C D D R F F G F E D C E F E D R" 2 1
```

hockit.py - given a melody and a sequence of instrument-octave pairs, create a hocket in a round robin fashion, emitting a format suitable for clitrack.sh

```
# Create a three-voice hocket where the first voice is a first octave pure tone, 
# the second voice is a second octave pluck, and the third voice is a third octave pluck
./hockit.py "F E F D E C D D R F F G F E D C E F E D R" 3 sine 1 pluck 2 sawtooth 3
```

arpeggiate.py - given a tracker file as stdin, add cascading rests so that all chords become separate notes
```
echo "sine	5	1	A B C D E F G\npluck	4	2	G F E D C B A" > sample.tsv
./arpeggiate.py < sample.tsv
# Yields the following:
# sine	5	1	A R B R C R D R E R F R G R
# pluck	4	2	R G R F R E R D R C R B R A R
```
