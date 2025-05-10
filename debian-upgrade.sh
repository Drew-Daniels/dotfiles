#!/usr/bin/env bash

# exit on error
# NOTE: Gotchyas: https://mywiki.wooledge.org/BashFAQ/105
set -e

if ! command -v jq >/dev/null 2>&1; then
  echo "jq must be installed"
  exit 1
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         chezmoi                          │
#          │                 https://www.chezmoi.io/                  │
#          ╰──────────────────────────────────────────────────────────╯
# TODO: Rename
version=$(curl -sL https://api.github.com/repos/twpayne/chezmoi/releases/latest | jq '.tag_name' | sed 's/"//g' | cut -d 'v' -f2)
current=$(chezmoi --version | cut -d ' ' -f3 | cut -d 'v' -f2 | cut -d ',' -f1)

if [ "$current" != "$version" ]; then
  echo "Upgrading chezmoi"
  chezmoi_base_path="https://github.com/twpayne/chezmoi/releases/download/v${version}"

  deb="chezmoi_${version}_linux_amd64.deb"
  checksums="chezmoi_${version}_checksums.txt"
  checksum_sigs="chezmoi_${version}_checksums.txt.sig"
  pkey="chezmoi_cosign.pub"

  curl --silent --location --remote-name-all "${chezmoi_base_path}/${deb}" "${chezmoi_base_path}/${checksums}" "${chezmoi_base_path}/${checksum_sigs}" "${chezmoi_base_path}/${pkey}"

  # verify the signature on the checksums file is valid
  cosign verify-blob --key=$pkey --signature="$checksum_sigs" "$checksums"

  cosign_verification_status=$?
  if [ "$cosign_verification_status" -eq 1 ]; then
    echo "Signatures on Chemzoi checksums file is invalid"
    exit 1
  fi

  # verify the checksum matches
  download_checksum=$(sha256sum "$deb")
  verified_checksum=$(grep "linux_amd64.deb" <"$checksums")

  if [ "$download_checksum" != "$verified_checksum" ]; then
    echo "Checksum verification failed: $download_checksum vs. $verified_checksum"
    exit 1
  fi

  sudo apt install -y "./$deb"
  rm "$deb" "$checksums" "$checksum_sigs" "$pkey"
  echo "Installed chezmoi"
else
  echo "Chezmoi up-to-date"
fi

#        ╭───────────────────────────────────────────────────────────────╮
#        │                            neovim                             │
#        │https://github.com/neovim/neovim/blob/master/INSTALL.md#debian │
#        ╰───────────────────────────────────────────────────────────────╯
latest=$(curl -sL https://api.github.com/repos/neovim/neovim/releases/latest | jq '.tag_name' | sed 's/"//g')
current=$(nvim --version | cut -d ' ' -f2 | head -n1)

if [ "$current" != "$latest" ]; then
  echo "Upgrading neovim"

  base_repo_path="https://github.com/neovim/neovim/releases/latest/download/"
  pkg_name="nvim-linux-x86_64.tar.gz"
  checksums_filename="shasum.txt"

  curl --silent --location --remote-name-all "$base_repo_path/$pkg_name" "$base_repo_path/$checksums_filename"

  download_checksum=$(sha256sum <$pkg_name)
  verified_checksum=$(grep "linux-x86_64" <$checksums_filename)

  if [ "$download_checksum" != "$verified_checksum" ]; then
    echo "Checksum verification failed: $download_checksum vs. $verified_checksum"
    exit 1
  fi

  echo "Neovim checksum verified"
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf "$pkg_name"
  rm "$pkg_name" "$checksums_filename"
  echo "Upgraded neovim"
else
  echo "Neovim up-to-date"
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
  curl -sLO "https://github.com/universal-ctags/ctags-nightly-build/releases/download/${latest_release_date}%2B${latest_SHA_full}/uctags-${latest_release_date}-linux-x86_64.deb"
  pkg_path="./uctags-${latest_release_date}-linux-x86_64.deb"
  sudo apt -qq install -y "$pkg_path"
  rm "$pkg_path"
  echo "Upgraded universal-ctags"
else
  echo "universal-ctags up-to-date"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           zoom                           │
#          │            https://zoom.us/download?os=linux             │
#          ╰──────────────────────────────────────────────────────────╯
# TODO: zoom

#          ╭──────────────────────────────────────────────────────────╮
#          │                        veracrypt                         │
#          │        https://www.veracrypt.fr/en/Downloads.html        │
#          ╰──────────────────────────────────────────────────────────╯
# TODO: veracrypt
