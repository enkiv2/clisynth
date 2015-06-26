#!/usr/bin/env zsh
source clisynth.sh
neos $(./randomMelody.py | tee /dev/stderr ) | play -p
