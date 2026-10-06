#!/bin/sh

if [ "$(uname)" = "Darwin" ]; then
  exit
fi

if grep -qi debian /etc/os-release; then
  if ! command -v curl >/dev/null; then
    sudo apt install -y curl
  fi

  if ! command -v gpg >/dev/null; then
    sudo apt install -y gpg
  fi

  if ! command -v 1password >/dev/null; then
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
    echo "deb [arch=x86_64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/x86_64 stable main" | sudo tee /etc/apt/sources.list.d/1password.list

    sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
    curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
    sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

    sudo apt update
    sudo apt install -y 1password
  fi

  if ! command -v op >/dev/null; then
    sudo apt install -y 1password-cli
  fi
fi
