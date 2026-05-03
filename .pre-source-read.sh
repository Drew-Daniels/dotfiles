#!/bin/sh
#
# Chezmoi pre-source-read hook (ansible migration)
#
# This is the minimal bootstrap that must remain as shell script.
# It ensures the package manager, mise, python, and ansible are
# available before chezmoi's run_once scripts invoke ansible-playbook.
#

# ---- Directories ----
mkdir -p ~/projects
[ ! -d "/usr/local/bin" ] && sudo mkdir -p /usr/local/bin
mkdir -p ~/.config/mpd/playlists
mkdir -p ~/.mpd

# ---- Package manager ----
os=$(uname)

if [ "$os" = "Darwin" ]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ---- mise ----
if ! command -v mise >/dev/null 2>&1; then
  echo "Installing mise"
  case "$os" in
    Darwin)
      brew install mise
      ;;
    Linux)
      if command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --needed --noconfirm mise
      elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y dnf-plugins-core
        sudo dnf copr enable -y jdxcode/mise
        sudo dnf install -y mise
      else
        # Debian and others: use the install script
        curl https://mise.jdx.dev/install.sh | sh
      fi
      ;;
  esac
fi

# Activate mise shims so python is available
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash --shims)"
fi

# ---- Python (via mise) ----
if ! mise ls python 2>/dev/null | grep -q python; then
  echo "Installing Python via mise"
  mise use --global python@latest
fi

# Re-activate shims after installing python
eval "$(mise activate bash --shims)"

# ---- Ansible ----
if ! command -v ansible-playbook >/dev/null 2>&1; then
  echo "Installing Ansible"
  pip install --user ansible
fi
