#!/bin/sh

mkdir -p "$HOME/projects"

if [ ! -d "/usr/local/bin" ]; then
  sudo mkdir -p /usr/local/bin
fi

mkdir -p "$HOME/.config/mpd/playlists"
mkdir -p "$HOME/.mpd"
