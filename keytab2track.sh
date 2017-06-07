#!/usr/bin/env zsh
sed 's/|/\t/g;s/\([A-Z]\)/\1#/g' | tr 'a-z' 'A-Z' | sed 's/[A-Z]#/\L/g;s/-/ /g;s/  /R /g;s/\([A-Za-z]\)R/\1 R/g' | sed 's/\t/\t1\t/;s/^/pluck\t/g'
