#!/usr/bin/env bash

installed() {
  command -v "$1" >/dev/null
}

uninstalled() {
  ! installed "$1"
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

  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "GitHub User and Repo are required"
    exit 1
  fi

  gh_user="$1"
  gh_repo="$2"

  # TODO: Add an option to just return the tag number, without the 'v' prefix: sed 's/"//g'

  curl -sL https://api.github.com/repos/"$gh_user"/"$gh_repo"/releases/latest | jq '.tag_name' | sed 's/"//g'
}
