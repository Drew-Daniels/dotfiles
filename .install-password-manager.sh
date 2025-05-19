#!/bin/sh

os=$(uname)

if [ "$os" = "Linux" ]; then
  if grep -qi debian /etc/os-release; then
    #          ╭──────────────────────────────────────────────────────────╮
    #          │                           curl                           │
    #          │                  https://curl.se/docs/                   │
    #          ╰──────────────────────────────────────────────────────────╯
    # TODO: Figure out a good way to check for new curl releases on debian repository
    if ! command -v curl >/dev/null; then
      sudo apt install -y curl
    fi

    #          ╭──────────────────────────────────────────────────────────╮
    #          │                           gpg                            │
    #          │         https://packages.debian.org/bookworm/gpg         │
    #          ╰──────────────────────────────────────────────────────────╯
    if ! command -v gpg >/dev/null; then
      sudo apt install -y gpg
    fi

    #        ╭──────────────────────────────────────────────────────────────╮
    #        │                   ## 1Password Desktop App                   │
    #        │https://support.1password.com/install-linux/#debian-or-ubuntu │
    #        ╰──────────────────────────────────────────────────────────────╯
    pkg='1password'
    if ! command -v "$pkg" >/dev/null; then
      echo "Installing $pkg"
      # Add the key for the 1Password apt repository:
      curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

      # Add the 1Password apt repository:
      echo "deb [arch=x86_64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/x86_64 stable main" | sudo tee /etc/apt/sources.list.d/1password.list

      # Add the debsig-verify policy
      sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
      curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
      sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
      curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

      # Install 1Password Desktop
      sudo apt update && sudo apt install -y $pkg
      echo "Installed $pkg"
    fi

    #          ╭──────────────────────────────────────────────────────────╮
    #          │                      1Password CLI                       │
    #          │  https://developer.1password.com/docs/cli/get-started/   │
    #          ╰──────────────────────────────────────────────────────────╯
    pkg='1password-cli'

    if ! command -v "op" >/dev/null; then
      echo "Installing $pkg"
      sudo apt update && sudo apt install -y $pkg
      # NOTE: Manual - Turn on the 1Password CLI Integration in 1Password Desktop app: https://developer.1password.com/docs/cli/get-started/#step-2-turn-on-the-1password-desktop-app-integration
      echo "Installed $pkg"
    fi
  elif grep -qi nixos /etc/os-release; then
    # no-op
    :
  elif grep -qi arch /etc/os-release; then
    # no-op
    :
  else
    echo "Unrecognized Linux distro: $(cat /etc/os-release)"
  fi
elif [ "$os" = "Darwin" ]; then
  if [ ! -d "/Applications/1Password.app" ]; then
    brew install --cask 1password@nightly
  fi

  if ! command -v op >/dev/null; then
    brew install --cask 1password-cli
  fi
else
  echo "Unrecognized OS: $os"
fi
