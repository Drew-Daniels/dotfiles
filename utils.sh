#!/usr/bin/env bash

installed() {
  command -v "$1" >/dev/null
}

uninstalled() {
  ! installed "$1"
}

get_latest_gh_release_data() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "GitHub User and Repo are required"
    exit 1
  fi

  if [ -z "$GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN" ]; then
    echo "WARNING: GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN is not available - set this env var to increase rate limit"
  fi

  gh_user="$1"
  gh_repo="$2"

  # TODO: Add an option to just return the tag number, without the 'v' prefix: sed 's/"//g'

  curl -sL "https://api.github.com/repos/${gh_user}/${gh_repo}/releases/latest" --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}"
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

