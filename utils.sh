#!/usr/bin/env bash

installed() {
  command -v "$1" >/dev/null
}

uninstalled() {
  ! installed "$1"
}

install_dnf_package() {
  command_name=${1}     # The command to check for installation
  package_name=${2:-$1} # The package name to install, defaults to the command name if only one argument is provided

  if uninstalled "$command_name"; then
    echo "Installing $package_name"
    sudo dnf install -y "$package_name"
    echo "Installed $package_name"
  else
    echo "Already installed $package_name"
  fi
}

install_apt_package() {
  command_name=${1}     # The command to check for installation
  package_name=${2:-$1} # The package name to install, defaults to the command name if only one argument is provided

  if uninstalled "$command_name"; then
    echo "Installing $package_name"
    sudo apt install -y "$package_name"
    echo "Installed $package_name"
  else
    echo "Already installed $package_name"
  fi
}

install_arch_package() {
  command_name=${1}     # The command to check for installation
  package_name=${2:-$1} # The package name to install, defaults to the command name if only one argument is provided

  if uninstalled "$command_name"; then
    echo "Installing $package_name"
    sudo pacman -S "$package_name"
    echo "Installed $package_name"
  else
    echo "Already installed $package_name"
  fi
}

install_gem() {
  package_name=$1

  if uninstalled "$package_name"; then
    echo "Installing $package_name"
    gem install tmuxinator
    echo "Installed $package_name"
  else
    echo "Already installed $package_name"
  fi
}

install_npm_package() {
  command_name=${1}     # The command to check for installation
  package_name=${2:-$1} # The package name to install, defaults to the command name if only one argument is provided

  if uninstalled "$command_name"; then
    echo "Installing $package_name"
    npm i -g "$package_name"
    echo "Installed $package_name"
  else
    echo "Already installed $package_name"
  fi
}

install_go_package() {
  command_name=${1}     # The command to check for installation
  package_name=${2:-$1} # The package name to install, defaults to the command name if only one argument is provided

  if uninstalled "$command_name"; then
    echo "Installing $package_name"
    go install "$package_name"
    echo "Installed $package_name"
  else
    echo "Already installed $package_name"
  fi
}

install_pip_package() {
  command_name=${1}     # The command to check for installation
  package_name=${2:-$1} # The package name to install, defaults to the command name if only one argument is provided

  if uninstalled "$command_name"; then
    echo "Installing $package_name"
    pip install "$package_name"
    echo "Installed $package_name"
  else
    echo "Already installed $package_name"
  fi
}

install_crate() {
  package_name=$1

  if uninstalled "$package_name"; then
    echo "Installing $package_name"
    cargo install --locked "$package_name"
    echo "Installed $package_name"
  else
    echo "Already installed $package_name"
  fi
}

get_latest_gh_release_data() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "GitHub User and Repo are required"
    exit 1
  fi

  gh_user="$1"
  gh_repo="$2"

  if [ -n "${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" ]; then
    curl -sL "https://api.github.com/repos/${gh_user}/${gh_repo}/releases/latest" --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}"
  else
    curl -sL "https://api.github.com/repos/${gh_user}/${gh_repo}/releases/latest"
  fi

  # TODO: Add an option to just return the tag number, without the 'v' prefix: sed 's/"//g'
}

#######################################
# Returns the latest GitHub release tag
# Arguments:
#   gh_user
#   gh_repo
#######################################
get_latest_gh_release_tag() {
  if uninstalled "jq"; then
    echo "jq must be installed"
    exit 1
  fi

  # TODO: Create a temp file instead
  # TODO: Add error handling. If the curl request returns an error response this silently fails
  get_latest_gh_release_data "$1" "$2" >data.json
  jq '.tag_name' <data.json | sed 's/"//g'
  rm data.json
}

verify_fingerprint() {
  cat "$1"
  printf "\n"

  while true; do
    read -p "Does the fingerprint printed above match the one GPG prnted previously?" yesno
    case $yesno in
    [Yy]*)
      # Continue...
      break
      ;;
    [Nn]*)
      echo "Exiting: Fingerprint does not match"
      exit
      ;;
    *) echo "Answer either yes or no!" ;;
    esac
  done
}

approve_script_execution() {
  cat "$1"
  printf "\n"

  while true; do
    read -p "Does the above script look safe?" yesno
    case $yesno in
    [Yy]*)
      chmod +x "$1"
      break
      ;;
    [Nn]*)
      exit
      ;;
    *) echo "Answer either yes or no!" ;;
    esac
  done
}
