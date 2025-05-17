#!/bin/sh

if [ "$(uname)" = "Linux" ]; then
  exit
elif [ -f /usr/local/bin/chezmoi ]; then
  # Should only have 1 chezmoi installation after initial `chezmoi apply`, which points to the homebrew installation in /opt/homebrew/bin/chezmoi
  rm /usr/local/bin/chezmoi
fi
