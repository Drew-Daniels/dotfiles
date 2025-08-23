#!/bin/sh

github_base_url="https://github.com/Drew-Daniels"
codeberg_base_url="https://codeberg.org/drewdaniels"

if [ ! -d ~/projects/friendly-snippets ]; then
  git clone "$github_base_url/friendly-snippets.git" ~/projects/friendly-snippets
fi

if [ ! -d ~/projects/work_notes ]; then
  git clone "$github_base_url/work_notes.git" ~/projects/work_notes
fi

if [ ! -d ~/projects/jg ]; then
  git clone "$codeberg_base_url/jg.git" ~/projects/jg
fi

if [ ! -d ~/projects/dotfiles.wiki ]; then
  git clone "$github_base_url/dotfiles.wiki.git" ~/projects/dotfiles.wiki
fi
