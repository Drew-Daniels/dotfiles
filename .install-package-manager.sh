#!/bin/sh

if [ "$(uname)" == "Linux" ]; then
  exit
fi

type brew >/dev/null 2>&1 && exit

case "$(uname -s)" in
Darwin)
  #          ╭──────────────────────────────────────────────────────────╮
  #          │                         homebrew                         │
  #          │                     https://brew.sh/                     │
  #          ╰──────────────────────────────────────────────────────────╯
  if ! command -v /opt/homebrew/bin/brew >/dev/null 2>&1; then
    echo "Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Installed homebrew"
  fi

  PATH="/usr/local/sbin:$PATH"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  ;;
*)
  echo "unsupported OS"
  exit 1
  ;;
esac
