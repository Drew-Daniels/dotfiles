#!/usr/bin/env bash

# TODO: Make sure that all 'curl' requests made to github api use authentication

# exit on error
# NOTE: Gotchyas: https://mywiki.wooledge.org/BashFAQ/105
set -e

. ./utils.sh

if ! command -v jq >/dev/null 2>&1; then
  echo "jq must be installed"
  exit 1
fi

sudo dnf upgrade

# rustup update
#
# cargo install-update --all --locked

# TODO: Add step to upgrade cosign

#          ╭──────────────────────────────────────────────────────────╮
#          │                         chezmoi                          │
#          │                 https://www.chezmoi.io/                  │
#          ╰──────────────────────────────────────────────────────────╯
latest=$(get_latest_gh_release_tag "twpayne" "chezmoi" | cut -d 'v' -f2)
current=$(chezmoi --version | cut -d ' ' -f3 | cut -d 'v' -f2 | cut -d ',' -f1)

if [ "$current" != "$latest" ]; then
  echo "Upgrading chezmoi"
  chezmoi_base_path="https://github.com/twpayne/chezmoi/releases/download/v${latest}"

  rpm="chezmoi_${latest}_linux_amd64.deb"
  checksums="chezmoi_${latest}_checksums.txt"
  checksum_sigs="chezmoi_${latest}_checksums.txt.sig"
  pkey="chezmoi_cosign.pub"

  curl --silent --location --remote-name-all --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" "${chezmoi_base_path}/${rpm}" "${chezmoi_base_path}/${checksums}" "${chezmoi_base_path}/${checksum_sigs}" "${chezmoi_base_path}/${pkey}"

  # verify the signature on the checksums file is valid
  cosign verify-blob --key=$pkey --signature="$checksum_sigs" "$checksums"

  cosign_verification_status=$?
  if [ "$cosign_verification_status" -eq 1 ]; then
    echo "Signatures on Chemzoi checksums file is invalid"
    exit 1
  fi

  # verify the checksum matches
  download_checksum=$(sha256sum "$rpm")
  verified_checksum=$(grep linux_amd64.rpm <"$checksums")

  if [ "$download_checksum" != "$verified_checksum" ]; then
    echo "Checksum verification failed: $download_checksum vs. $verified_checksum"
    exit 1
  fi

  sudo dnf install -y "./$rpm"
  rm "$rpm" "$checksums" "$checksum_sigs" "$pkey"
  echo "Upgraded chezmoi"
else
  echo "Chezmoi up-to-date"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          rustup                          │
#          │                    https://rustup.rs/                    │
#          ╰──────────────────────────────────────────────────────────╯
# TODO: Add steps to upgrade rustup when new version is available

#          ╭──────────────────────────────────────────────────────────╮
#          │                         mergiraf                         │
#          │          https://mergiraf.org/installation.html          │
#          ╰──────────────────────────────────────────────────────────╯
# TODO: Add steps to upgrade
# latest=$(curl -sL https://codeberg.org/mergiraf/mergiraf/releases.rss | xmlstarlet sel -t -v "//channel/item[1]/title" | cut -d ' ' -f2)
# current=$(mergiraf --version | cut -d ' ' -f2)
# if [ "$current" != "$latest" ]; then
#   echo "Upgrading mergiraf"
#   cargo install --locked mergiraf
#   echo "Upgraded mergiraf"
# else
#   echo "Mergiraf up-to-date"
# fi

# cleanup
sudo apt autoremove -y
sudo apt autoclean -y
