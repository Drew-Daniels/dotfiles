#!/usr/bin/env bash

# exit on error
# NOTE: Gotchyas: https://mywiki.wooledge.org/BashFAQ/105
set -e

arch=$(arch)
if [ "$arch" = "x86_64" ]; then
  platform='amd64'
else
  echo "Unknown platform"
  exit 1
fi

if ! command -v jq; then
  echo "jq must be installed"
  exit 1
fi

# TODO: Uncomment once done hashing out the rest
# sudo apt update -y

# Updates packages that have to be manually updated outside of 'apt'
# TODO: Suppress curl output
# TODO: Perform installation steps in a /tmp folder
#╭──────────────────────────────────────────────────────────────────────────────╮
#│                                    awscli                                    │
#│https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html │
#╰──────────────────────────────────────────────────────────────────────────────╯
# TODO: Add check to see if there is a later version available, and only install if it is differerent version from current install
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
#
# # cleanup
# rm awscliv2.zip
# rm -rf aws

#          ╭──────────────────────────────────────────────────────────╮
#          │                          rustup                          │
#          │                    https://rustup.rs/                    │
#          ╰──────────────────────────────────────────────────────────╯
# TODO: Add ~/.cargo/bin added to secure_path, or figure out another way to have this command work when running this file as root, using sudo
# rustup update >/dev/null
#    ╭──────────────────────────────────────────────────────────────────────╮
#    │                               ripgrep                                │
#    │https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation │
#    ╰──────────────────────────────────────────────────────────────────────╯
# TODO: ripgrep

#          ╭──────────────────────────────────────────────────────────╮
#          │                          delta                           │
#          │       https://github.com/dandavison/delta/releases       │
#          ╰──────────────────────────────────────────────────────────╯
latest=$(curl -sL https://api.github.com/repos/dandavison/delta/releases/latest | jq '.tag_name' | sed 's/"//g')
current=$(delta --version | cut -d ' ' -f2)

if [ "$current" != "$latest" ]; then
  echo "Upgrading delta"
  curl -sLO "https://github.com/dandavison/delta/releases/download/${latest}/git-delta_${latest}_amd64.deb"
  sudo apt install -y "./git-delta_${latest}_amd64.deb"
  echo "Upgraded delta"
else
  echo "Delta up-to-date"
fi

#       ╭────────────────────────────────────────────────────────────────╮
#       │                             ctags                              │
#       │https://github.com/universal-ctags/ctags-nightly-build/releases │
#       ╰────────────────────────────────────────────────────────────────╯
# TODO: Build in SHA-verification step
# get the first 7 characters of the latest release commit SHA
# keep a reference to the entire SHA since we'll use this to fetch the latest ctags release

latest_tag_name=$(curl -sL https://api.github.com/repos/universal-ctags/ctags-nightly-build/releases/latest | jq '.tag_name' | sed 's/"//g')
latest_release_date=$(echo "$latest_tag_name" | cut -d '+' -f1)

latest_SHA_full=$(echo "$latest_tag_name" | cut -d '+' -f2)
latest_SHA_abbr=$(echo "$latest_SHA_full" | head -c7)

current_SHA_abbr=$(ctags --version | head -n1 | sed 's/.*(\([a-z0-9]*\)).*/\1/')

if [ "$current_SHA_abbr" != "$latest_SHA_abbr" ]; then
  echo "Upgrading universal-ctags"
  curl -sLO "https://github.com/universal-ctags/ctags-nightly-build/releases/download/${latest_release_date}%2B${latest_SHA_full}/uctags-${latest_release_date}-linux-${arch}.deb"
  pkg_path="./uctags-${latest_release_date}-linux-${arch}.deb"
  sudo apt -qq install -y "$pkg_path"
  rm "$pkg_path"
  echo "Upgraded universal-ctags"
else
  echo "universal-ctags up-to-date"
fi

#╭───────────────────────────────────────────────────────────────────────────────────────────────╮
#│                                         balena-etcher                                         │
#│https://github.com/balena-io/etcher#debian-and-ubuntu-based-package-repository-gnulinux-x86x64 │
#╰───────────────────────────────────────────────────────────────────────────────────────────────╯
# TODO: balena-etcher
# TODO: Add SHA verification step - SHAs are posted with each release
latest_version=$(curl -sL https://api.github.com/repos/balena-io/etcher/releases/latest | jq '.tag_name' | sed 's/"//g; s/v//')

#          ╭──────────────────────────────────────────────────────────╮
#          │                           zoom                           │
#          │            https://zoom.us/download?os=linux             │
#          ╰──────────────────────────────────────────────────────────╯
# TODO: zoom
