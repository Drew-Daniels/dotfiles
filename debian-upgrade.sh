#!/usr/bin/env bash

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
  echo "Upgraded chezmoi"
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

#╭──────────────────────────────────────────────────────────────────────────────╮
#│                                    awscli                                    │
#│https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html │
#╰──────────────────────────────────────────────────────────────────────────────╯
# TODO: Figure out a way to fetch latest public key to verify before installing
latest=$(curl -sL https://raw.githubusercontent.com/aws/aws-cli/v2/CHANGELOG.rst | sed '5!d')
current=$(aws --version | cut -d '/' -f2 | cut -d ' ' -f1)

if [ "$current" != "$latest" ]; then
  echo "Upgrading AWS CLI"
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
  rm -rf awscliv2.zip aws
  echo "Upgraded AWS CLI"
else
  echo "AWS CLI up-to-date"
fi

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
pkg="ripgrep"
latest=$(curl -sL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | jq '.tag_name' | sed 's/"//g' | cut -d 'v' -f2)
current=$(rg --version | head -n1 | cut -d ' ' -f2)

if [ "$current" != "$latest" ]; then
  echo "Upgrading ${pkg}"
  base_url="https://github.com/BurntSushi/ripgrep/releases/download/${latest}"
  deb="ripgrep_${latest}-1_amd64.deb"
  sha="ripgrep_${latest}-1_amd64.deb.sha256"
  curl --silent --location --remote-name-all "$base_url/$deb" "$base_url/$sha"
  if sha256sum -c "$sha" --status; then
    sudo apt install -y "./$deb"
    rm "$deb" "$sha"
    echo "Upgraded ${pkg}"
  else
    echo "Could not upgrade $pkg - verify checksums"
    exit 1
  fi
else
  echo "Ripgrep up-to-date"
fi

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
#          │                 jetbrains-mono-nerd-font                 │
#          │            https://www.jetbrains.com/lp/mono/            │
#          ╰──────────────────────────────────────────────────────────╯
latest_release_info=$(curl -sL https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest)
latest_release_tag=$(echo "$latest_release_info" | jq -r '.tag_name')
latest_release_date=$(echo "$latest_release_info" | jq -r '.published_at' | cut -d 'T' -f1)
# TODO: Doesn't matter which specific one is checked, since they all are updated at the same time
last_modified=$(date +%F -r ~/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf)

latest_release_date_as_date=$(date -d "$latest_release_date" +%s)
last_modified_as_date=$(date -d "$last_modified" +%s)

if (("$last_modified_as_date" < "$latest_release_date_as_date")); then
  fonts_dir="$HOME/.local/share/fonts"
  echo "Upgrading JetBrainsMonoNerdFont"
  wget -P "$fonts_dir" "https://github.com/ryanoasis/nerd-fonts/releases/download/${latest_release_tag}/JetBrainsMono.zip"
  unzip -o "$fonts_dir/JetBrainsMono.zip" -d "$fonts_dir"
  rm "$fonts_dir/JetBrainsMono.zip"
  fc-cache -fv
  echo "Upgraded JetBrainsMonoNerdFont"
else
  echo "JetBrainsMonoNerdFont up-to-date"
fi
# TODO: Get the last modified date of currently installed jetbrains font, and if it is before the date of the latest release, replace it with the latest release
# jq '.published_at'
# "2025-04-24T18:23:06Z"

#        ╭──────────────────────────────────────────────────────────────╮
#        │                          alacritty                           │
#        │https://github.com/alacritty/alacritty/blob/master/INSTALL.md │
#        ╰──────────────────────────────────────────────────────────────╯
# TODO: Refactor sed expression so that it discards all content up to first parenthesis (so 'cut' part isn't needed before)
current=$(alacritty --version | cut -d ' ' -f3 | sed 's/(\([^/)]*\))/\1/g')
cd ~/projects/alacritty/ || exit
git pull
latest=$(git rev-parse --short @)
if [ "$current" != "$latest" ]; then
  if [ "$TERM" == "alacritty" ]; then
    echo "Re-run in another terminal emulator - will not be able to upgrade alacritty while using alacritty"
    exit 1
  fi
  echo "Upgrading alacritty"
  # build
  cargo build --release

  # post-build
  sudo cp target/release/alacritty /usr/local/bin
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database
  echo "Upgraded alactritty"
else
  echo "Alacritty up-to-date"
fi
cd ~ || exit

#          ╭──────────────────────────────────────────────────────────╮
#          │                      resticprofile                       │
#          │    https://github.com/creativeprojects/resticprofile     │
#          ╰──────────────────────────────────────────────────────────╯
latest=$(curl -sL https://api.github.com/repos/creativeprojects/resticprofile/releases/latest | jq '.tag_name' | sed 's/"//g' | cut -d 'v' -f2)
current=$(resticprofile version | cut -d ' ' -f3)

if [ "$current" != "$latest" ]; then
  echo "Upgrading resticprofile"
  curl -sLO "https://github.com/creativeprojects/resticprofile/releases/latest/download/resticprofile_${latest}_linux_amd64.tar.gz"
  mkdir "resticprofile_${latest}_linux_amd64"
  tar -xzpf "resticprofile_${latest}_linux_amd64.tar.gz" -C "resticprofile_${latest}_linux_amd64"
  sudo cp "resticprofile_${latest}_linux_amd64/resticprofile" /usr/local/bin/
  rm -rf restic*
  echo "Upgraded resticprofile"
else
  echo "resticprofile up-to-date"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                        usbimager                         │
#          │           https://gitlab.com/bztsrc/usbimager            │
#          ╰──────────────────────────────────────────────────────────╯
#
latest=$(curl -sL https://gitlab.com/bztsrc/usbimager/-/releases.atom | xmlstarlet sel -N atom="http://www.w3.org/2005/Atom" -t -v "/atom:feed/atom:entry[1]/atom:title" | cut -d ' ' -f2)
current=$(usbimager --version)

if [ "$current" != "$latest" ]; then
  echo "Updating usbimager"
  deb="usbimager_${latest}-amd64.deb"
  curl -sLO "https://gitlab.com/bztsrc/usbimager/-/raw/binaries/$deb"
  apt install -y "./$deb"
  rm "$deb"
  echo "usbimager updated"
else
  echo "usbimager up-to-date"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                            yq                            │
#          │             https://github.com/mikefarah/yq              │
#          ╰──────────────────────────────────────────────────────────╯
latest=$(curl -sL https://api.github.com/repos/mikefarah/yq/releases/latest | jq '.tag_name' | sed 's/"//g')
current=$(yq --version | cut -d ' ' -f4)
if [ "$current" != "$latest" ]; then
  echo "Upgrading yq"
  base_url="https://github.com/mikefarah/yq/releases/download/${latest}"
  curl --silent --location --remote-name-all "$base_url/yq_linux_amd64.tar.gz" "$base_url/extract-checksum.sh" "$base_url/checksums_hashes_order" "$base_url/checksums"
  chmod +x ./extract-checksum.sh

  if ./extract-checksum.sh SHA-256 yq_linux_amd64.tar.gz | awk '{ print $2 " " $1}' | sha256sum -c --status; then
    tar xzf "yq_linux_amd64.tar.gz"
    sudo mv yq_linux_amd64 /usr/local/bin/yq
    # TODO: Figure out what is generating 'yq.1' and 'install-man-page.sh' - probably the extract-checksum.sh script
    rm yq_linux_amd64.tar.gz extract-checksum.sh checksums_hashes_order checksums yq.1 install-man-page.sh
    echo "Upgraded yq"
  else
    echo "Could not upgrade yq - verify checksums"
  fi
else
  echo "yq up-to-date"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                       imagemagick                        │
#          │        https://github.com/ImageMagick/ImageMagick        │
#          ╰──────────────────────────────────────────────────────────╯
latest=$(curl -sL https://api.github.com/repos/ImageMagick/ImageMagick/releases/latest | jq '.tag_name' | sed 's/"//g')
current=$(magick -version | head -n1 | cut -d ' ' -f3)

if [ "$current" != "$latest" ]; then
  echo "Upgrading imagemagick"
  latest_download_url=$(curl -sL https://api.github.com/repos/ImageMagick/ImageMagick/releases/latest | jq '.assets[0].browser_download_url' | sed 's/"//g')
  curl -L "$latest_download_url" -o magick
  chmod +x magick
  sudo mv magick /usr/local/bin/
  echo "Upgraded imagemagick"
else
  echo "Imagemagick up-to-date"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           fzf                            │
#          │       https://junegunn.github.io/fzf/installation/       │
#          ╰──────────────────────────────────────────────────────────╯
latest=$(curl -sL https://api.github.com/repos/junegunn/fzf/releases/latest | jq '.tag_name' | sed 's/"//g;s/v//g')
current=$(fzf --version | cut -d ' ' -f1)
if [ "$current" != "$latest" ]; then
  echo "Upgrading fzf"
  base_url="https://github.com/junegunn/fzf/releases/download/v${latest}"
  bin="fzf-${latest}-linux_amd64"
  tgz="$bin.tar.gz"
  checksums="fzf_${latest}_checksums.txt"
  curl -sL --remote-name-all "$base_url/$tgz" "$base_url/$checksums"
  verified_sha=$(grep <"$checksums" linux_amd64.tar.gz)
  download_sha=$(sha256sum "$tgz")

  if [ "$download_sha" != "$verified_sha" ]; then
    echo "Could not install fzf - verify checksums"
    exit 1
  fi

  tar xzf "$tgz"
  sudo mv fzf /usr/local/bin/

  rm "$tgz" "$checksums"
  echo "Upgraded fzf"
else
  echo "Fzf up-to-date"
fi

#          ╭───────────────────────────────────────────────────────────╮
#          │                            fd                             │
#          │https://github.com/sharkdp/fd?tab=readme-ov-file#on-debian │
#          ╰───────────────────────────────────────────────────────────╯
latest=$(curl -sL https://api.github.com/repos/sharkdp/fd/releases/latest | jq '.tag_name' | sed 's/"//g;s/v//g')
current=$(fd --version | cut -d ' ' -f2)

if [ "$current" != "$latest" ]; then
  echo "Upgrading fd"
  deb="fd_${latest}_amd64.deb"
  curl -sLO "https://github.com/sharkdp/fd/releases/download/v${latest}/${deb}"
  sudo apt install -y "./${deb}"
  rm "$deb"
  echo "Upgraded fd"
else
  echo "fd up-to-date"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         mergiraf                         │
#          │          https://mergiraf.org/installation.html          │
#          ╰──────────────────────────────────────────────────────────╯
# latest=$(curl -sL https://codeberg.org/mergiraf/mergiraf/releases.rss | xmlstarlet sel -t -v "//channel/item[1]/title" | cut -d ' ' -f2)
# # TODO: This likely won't return the exact right version number needed here - need to refactor once glibc dep issue sorted out
# current=$(mergiraf --version)
# # TODO: Re-enable once upgraded to later Debian version (trixie from bookworm)
# if [ "$current" != "$latest" ]; then
#   echo "Upgrading mergiraf"
#   tgz="mergiraf_x86_64-unknown-linux-gnu.tar.gz"
#   curl -sLO "https://codeberg.org/mergiraf/mergiraf/releases/download/v${latest}/$tgz"
#   tar xzf "$tgz"
#   sudo mv mergiraf /usr/local/bin/
#   rm "$tgz"
#   echo "Upgraded mergiraf"
# else
#   echo "Mergiraf up-to-date"
# fi

# cleanup
# sudo apt update -y
# sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y
