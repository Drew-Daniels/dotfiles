#!/bin/sh

if [ "$(uname)" != "Darwin" ]; then
  exit
fi

command -v brew >/dev/null 2>&1 && exit

if ! command -v /opt/homebrew/bin/brew >/dev/null 2>&1; then
  echo "Installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Installed homebrew"
fi

PATH="/usr/local/sbin:$PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"
