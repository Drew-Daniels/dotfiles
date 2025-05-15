#!/bin/sh
# exit immediately if password-manager-binary is already in $PATH
type op >/dev/null 2>&1 && exit

case "$(uname -s)" in
Darwin)
  brew install --cask 1password@nightly
  brew install --cask password-cli
  ;;
Linux)
  #        ╭──────────────────────────────────────────────────────────────╮
  #        │                   ## 1Password Desktop App                   │
  #        │https://support.1password.com/install-linux/#debian-or-ubuntu │
  #        ╰──────────────────────────────────────────────────────────────╯
  pkg='1password'
  if uninstalled $pkg; then
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
  else
    echo "Already installed $pkg"
  fi

  #          ╭──────────────────────────────────────────────────────────╮
  #          │                      1Password CLI                       │
  #          │  https://developer.1password.com/docs/cli/get-started/   │
  #          ╰──────────────────────────────────────────────────────────╯
  pkg='1password-cli'

  if command -v op >/dev/null; then
    echo "Installing $pkg"
    sudo apt update && sudo apt install -y $pkg
    # NOTE: Manual - Turn on the 1Password CLI Integration in 1Password Desktop app: https://developer.1password.com/docs/cli/get-started/#step-2-turn-on-the-1password-desktop-app-integration
    echo "Installed $pkg"
  else
    echo "Already installed $pkg"
  fi
  ;;
*)
  echo "unsupported OS"
  exit 1
  ;;
esac
