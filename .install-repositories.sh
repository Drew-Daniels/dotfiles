#!/bin/bash

if [ ! -d ~/projects/friendly-snippets ]; then
  git clone https://github.com/Drew-Daniels/friendly-snippets.git ~/projects/friendly-snippets
fi

if [ ! -d ~/projects/work_notes ]; then
  git clone https://github.com/Drew-Daniels/work_notes.git ~/projects/work_notes
fi

if [ ! -d ~/projects/jg ]; then
  git clone https://codeberg.org/drewdaniels/jg.git ~/projects/jg
fi
