#!/bin/sh

mkdir -p ~/projects

if [ ! -d "/usr/local/bin" ]; then
  sudo mkdir -p /usr/local/bin
fi

mkdir -p ~/.config/mpd/playlists
mkdir -p ~/.mpd
