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

rustup update

cargo install-update --all --locked

#          ╭──────────────────────────────────────────────────────────╮
#          │                            jq                            │
#          │               https://jqlang.org/download/               │
#          ╰──────────────────────────────────────────────────────────╯
#
latest=$(get_latest_gh_release_tag "jqlang" "jq")
current=$(jq --version)
if [ "$current" != "$latest" ]; then
  echo "Upgrading jq"
  bin="jq-linux-amd64"
  checksums="sha256sum.txt"
  base_url="https://github.com/jqlang/jq/releases/download/${latest}/"
  curl -sL --remote-name-all --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" "$base_url/${bin}" "${base_url}/${checksums}"
  verified_sha=$(grep jq-linux-amd64 <sha256sum.txt)
  download_sha=$(sha256sum "$bin")
  if [ "$download_sha" != "$verified_sha" ]; then
    echo "Could not install jq - verify checksums"
    exit 1
  fi
  chmod +x "$bin"
  sudo mv jq-linux-amd64 /usr/local/bin/jq
  rm "$checksums"
  echo "Upgraded jq"
else
  echo "jq up-to-date"
fi
#          ╭──────────────────────────────────────────────────────────╮
#          │                         chezmoi                          │
#          │                 https://www.chezmoi.io/                  │
#          ╰──────────────────────────────────────────────────────────╯
latest=$(get_latest_gh_release_tag "twpayne" "chezmoi" | cut -d 'v' -f2)
current=$(chezmoi --version | cut -d ' ' -f3 | cut -d 'v' -f2 | cut -d ',' -f1)

if [ "$current" != "$latest" ]; then
  echo "Upgrading chezmoi"
  chezmoi_base_path="https://github.com/twpayne/chezmoi/releases/download/v${latest}"

  deb="chezmoi_${latest}_linux_amd64.deb"
  checksums="chezmoi_${latest}_checksums.txt"
  checksum_sigs="chezmoi_${latest}_checksums.txt.sig"
  pkey="chezmoi_cosign.pub"

  curl --silent --location --remote-name-all --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" "${chezmoi_base_path}/${deb}" "${chezmoi_base_path}/${checksums}" "${chezmoi_base_path}/${checksum_sigs}" "${chezmoi_base_path}/${pkey}"

  # verify the signature on the checksums file is valid
  cosign verify-blob --key=$pkey --signature="$checksum_sigs" "$checksums"

  cosign_verification_status=$?
  if [ "$cosign_verification_status" -eq 1 ]; then
    echo "Signatures on Chemzoi checksums file is invalid"
    exit 1
  fi

  # verify the checksum matches
  download_checksum=$(sha256sum "$deb")
  verified_checksum=$(grep linux_amd64.deb <"$checksums")

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
latest=$(get_latest_gh_release_tag "neovim" "neovim")
current=$(nvim --version | cut -d ' ' -f2 | head -n1)

if [ "$current" != "$latest" ]; then
  echo "Upgrading neovim"

  base_repo_path="https://github.com/neovim/neovim/releases/latest/download/"
  pkg_name="nvim-linux-x86_64.tar.gz"
  checksums_filename="shasum.txt"

  curl --silent --location --remote-name-all --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" "$base_repo_path/$pkg_name" "$base_repo_path/$checksums_filename"

  download_checksum=$(sha256sum $pkg_name)
  verified_checksum=$(grep "$pkg_name" <$checksums_filename)

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
latest=$(curl -sL --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" "https://raw.githubusercontent.com/aws/aws-cli/v2/CHANGELOG.rst" | sed '5!d')
current=$(aws --version | cut -d '/' -f2 | cut -d ' ' -f1)

if [ "$current" != "$latest" ]; then
  echo "Upgrading AWS CLI"
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip -q awscliv2.zip
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
latest=$(get_latest_gh_release_tag "BurntSushi" "ripgrep" | cut -d 'v' -f2)
current=$(rg --version | head -n1 | cut -d ' ' -f2)

if [ "$current" != "$latest" ]; then
  echo "Upgrading ${pkg}"
  base_url="https://github.com/BurntSushi/ripgrep/releases/download/${latest}"
  deb="ripgrep_${latest}-1_amd64.deb"
  sha="ripgrep_${latest}-1_amd64.deb.sha256"
  curl --silent --location --remote-name-all --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" "$base_url/$deb" "$base_url/$sha"
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
latest=$(get_latest_gh_release_tag "dandavison" "delta")
current=$(delta --version | cut -d ' ' -f2)

if [ "$current" != "$latest" ]; then
  echo "Upgrading delta"
  # TODO: Create a utility function for making `curl` calls with auth token added
  curl -sLO --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" "https://github.com/dandavison/delta/releases/download/${latest}/git-delta_${latest}_amd64.deb"
  sudo apt install -y "./git-delta_${latest}_amd64.deb"
  echo "Upgraded delta"
else
  echo "Delta up-to-date"
fi

#       ╭────────────────────────────────────────────────────────────────╮
#       │                             ctags                              │
#       │https://github.com/universal-ctags/ctags-nightly-build/releases │
#       ╰────────────────────────────────────────────────────────────────╯
latest_tag_name=$(get_latest_gh_release_tag "universal-ctags" "ctags-nightly-build")
latest_release_date=$(echo "$latest_tag_name" | cut -d '+' -f1)

latest_SHA_full=$(echo "$latest_tag_name" | cut -d '+' -f2)
latest_SHA_abbr=$(echo "$latest_SHA_full" | head -c7)

current_SHA_abbr=$(ctags --version | head -n1 | sed 's/.*(\([a-z0-9]*\)).*/\1/')

if [ "$current_SHA_abbr" != "$latest_SHA_abbr" ]; then
  echo "Upgrading universal-ctags"
  curl -sLO --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" "https://github.com/universal-ctags/ctags-nightly-build/releases/download/${latest_release_date}%2B${latest_SHA_full}/uctags-${latest_release_date}-linux-x86_64.deb"
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
latest_release_info=$(get_latest_gh_release_data "ryanoasis" "nerd-fonts")
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
  unzip -q -o "$fonts_dir/JetBrainsMono.zip" -d "$fonts_dir"
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
  if [ "$TERM" = "alacritty" ]; then
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
#          │                          restic                          │
#          │             https://github.com/restic/restic             │
#          ╰──────────────────────────────────────────────────────────╯
latest=$(get_latest_gh_release_tag "restic" "restic" | cut -d 'v' -f2)
current=$(restic version | cut -d ' ' -f2)
if [ "$current" != "$latest" ]; then
  echo "Upgrading restic"
  sudo restic self-update
  echo "Upgraded restic"
else
  echo "restic up-to-date"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                      resticprofile                       │
#          │    https://github.com/creativeprojects/resticprofile     │
#          ╰──────────────────────────────────────────────────────────╯
latest=$(get_latest_gh_release_tag "creativeprojects" "resticprofile" | cut -d 'v' -f2)
current=$(resticprofile version | cut -d ' ' -f3)
if [ "$current" != "$latest" ]; then
  echo "Upgrading resticprofile"
  sudo resticprofile self-update --quiet
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
latest=$(get_latest_gh_release_tag "mikefarah" "yq")
current=$(yq --version | cut -d ' ' -f4)
if [ "$current" != "$latest" ]; then
  echo "Upgrading yq"
  base_url="https://github.com/mikefarah/yq/releases/download/${latest}"
  curl --silent --location --remote-name-all --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" "$base_url/yq_linux_amd64.tar.gz" "$base_url/extract-checksum.sh" "$base_url/checksums_hashes_order" "$base_url/checksums"
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
latest=$(get_latest_gh_release_tag "ImageMagick" "ImageMagick")
current=$(magick -version | head -n1 | cut -d ' ' -f3)

if [ "$current" != "$latest" ]; then
  echo "Upgrading imagemagick"
  latest_download_url=$(curl -sL --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" "https://api.github.com/repos/ImageMagick/ImageMagick/releases/latest" | jq '.assets[0].browser_download_url' | sed 's/"//g')
  curl -L --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" "$latest_download_url" -o magick
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
latest=$(get_latest_gh_release_tag "junegunn" "fzf" | sed 's/v//g')
current=$(fzf --version | cut -d ' ' -f1)
if [ "$current" != "$latest" ]; then
  echo "Upgrading fzf"
  base_url="https://github.com/junegunn/fzf/releases/download/v${latest}"
  bin="fzf-${latest}-linux_amd64"
  tgz="$bin.tar.gz"
  checksums="fzf_${latest}_checksums.txt"
  curl -sL --remote-name-all --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" "$base_url/$tgz" "$base_url/$checksums"
  verified_sha=$(grep linux_amd64.tar.gz <"$checksums")
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
latest=$(get_latest_gh_release_tag "sharkdp" "fd" | sed 's/v//g')
current=$(fd --version | cut -d ' ' -f2)
if [ "$current" != "$latest" ]; then
  echo "Upgrading fd"
  deb="fd_${latest}_amd64.deb"
  curl -sLO --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" "https://github.com/sharkdp/fd/releases/download/v${latest}/${deb}"
  sudo apt install -y "./${deb}"
  rm "$deb"
  echo "Upgraded fd"
else
  echo "fd up-to-date"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           fish                           │
#          │                  https://fishshell.com/                  │
#          ╰──────────────────────────────────────────────────────────╯
latest_major=$(get_latest_gh_release_tag "fish-shell" "fish-shell" | sed 's/v//g' | cut -c1)
current_major=$(fish --version | cut -d ' ' -f3 | cut -c1)
os_release_no=$(grep VERSION_ID </etc/os-release | cut -d '=' -f2 | sed 's/"//g')
if [ "$current_major" != "$latest_major" ]; then
  echo "deb http://download.opensuse.org/repositories/shells:/fish:/release:/${latest_major}/Debian_${os_release_no}/ /" | sudo tee "/etc/apt/sources.list.d/shells:fish:release:${latest_major}.list"
  curl -fsSL "https://download.opensuse.org/repositories/shells:fish:release:${latest_major}/Debian_${os_release_no}/Release.key" | gpg --dearmor | sudo tee "/etc/apt/trusted.gpg.d/shells_fish_release_${latest_major}.gpg" >/dev/null
  sudo apt update
  sudo apt install fish
  sudo rm "/etc/apt/sources.list.d/shells:fish:release:${current_major}.list"
fi

#╭───────────────────────────────────────────────────────────────────────────────────────────╮
#│                                            bat                                            │
#│https://github.com/sharkdp/bat?tab=readme-ov-file#on-ubuntu-using-most-recent-deb-packages │
#╰───────────────────────────────────────────────────────────────────────────────────────────╯
latest=$(get_latest_gh_release_tag "sharkdp" "bat" | sed 's/v//g')
current=$(bat --version | cut -d ' ' -f2)
if [ "$current" != "$latest" ]; then
  echo "Upgrading bat"
  deb="bat_${latest}_amd64.deb"
  curl -sLO --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" "https://github.com/sharkdp/bat/releases/download/v${latest}/${deb}"
  sudo apt install -y "./${deb}"
  rm "$deb"
  echo "Upgraded bat"
else
  echo "Bat up-to-date"
fi

#         ╭─────────────────────────────────────────────────────────────╮
#         │                            tmux                             │
#         │https://github.com/tmux/tmux/wiki/Installing#binary-packages │
#         ╰─────────────────────────────────────────────────────────────╯
#
latest=$(get_latest_gh_release_tag "tmux" "tmux")
current=$(tmux -V | cut -d ' ' -f2)
if [ "$current" != "$latest" ]; then
  echo "Upgrading tmux"
  tgz="tmux-${latest}.tar.gz"
  curl -sLO --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" "https://github.com/tmux/tmux/releases/download/${latest}/${tgz}"
  tar -zxf tmux-*.tar.gz
  cd tmux-*/ || exit
  ./configure
  make && sudo make install
  echo "Upgraded tmux"
else
  echo "Tmux up-to-date"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                   git-credential-oauth                   │
#          │     https://github.com/hickford/git-credential-oauth     │
#          ╰──────────────────────────────────────────────────────────╯
#
latest=$(get_latest_gh_release_tag "hickford" "git-credential-oauth" | cut -d 'v' -f2)
current=$(git-credential-oauth version | cut -d ' ' -f2)
if [ "$current" != "$latest" ]; then
  echo "Upgrading git-credential-oauth"
  tgz="git-credential-oauth_${latest}_linux_amd64.tar.gz"
  curl -sLO --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" "https://github.com/hickford/git-credential-oauth/releases/download/v${latest}/${tgz}"
  # NOTE: Adding 'skip-old-files' option because the archive contains a README.md file that clobbers my own
  tar --skip-old-files -xzf "$tgz"
  chmod +x git-credential-oauth
  sudo mv git-credential-oauth /usr/local/bin/
  rm "$tgz" LICENSE.txt
  echo "Upgraded git-credential-oauth"
else
  echo "git-credential-oauth up-to-date"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                        bat-extras                        │
#          │     https://github.com/eth-p/bat-extras/tree/master      │
#          ╰──────────────────────────────────────────────────────────╯
pkg="bat-extras"
cd ~/projects/bat-extras || exit
current=$(git rev-parse --short @)
git pull
latest=$(git rev-parse --short @)
if [ "$current" != "$latest" ]; then
  echo "Upgrading $pkg"
  ./build.sh --install
  echo "Upgraded $pkg"
else
  echo "$pkg up-to-date"
fi
cd ~ || exit

#          ╭──────────────────────────────────────────────────────────╮
#          │                       tidal-dl-ng                        │
#          │          https://github.com/exislow/tidal-dl-ng          │
#          ╰──────────────────────────────────────────────────────────╯
latest=$(get_latest_gh_release_tag "exislow" "tidal-dl-ng" | cut -d 'v' -f2)
current=$(tidal-dl-ng --version)
if [ "$current" != "$latest" ]; then
  echo "Upgrading tidal-dl-ng"
  pip install --upgrade tidal-dl-ng[gui]
  echo "Upgraded tidal-dl-ng"
else
  echo "tidal-dl-ng up-to-date"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                        strawberry                        │
#          │   https://github.com/strawberrymusicplayer/strawberry    │
#          ╰──────────────────────────────────────────────────────────╯
latest=$(get_latest_gh_release_tag "strawberrymusicplayer" "strawberry" | cut -d 'v' -f2)
current=$(strawberry --version | cut -d ' ' -f2)
os_release_codename=$(grep VERSION_CODENAME </etc/os-release | cut -d '=' -f2)
if [ "$current" != "$latest" ]; then
  echo "Installing strawberry"
  deb="strawberry_${latest}-${os_release_codename}_amd64.deb"
  curl -sLO --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" "https://github.com/strawberrymusicplayer/strawberry/releases/download/${latest}/${deb}"
  sudo apt install -y "./$deb"
  rm "$deb"
  echo "Installed strawberry"
else
  echo "Strawberry up-to-date"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           dust                           │
#          │             https://github.com/bootandy/dust             │
#          ╰──────────────────────────────────────────────────────────╯
# latest=$(get_latest_gh_release_tag "bootandy" "dust" | cut -d 'v' -f2)
# current=$(dust --version | cut -d ' ' -f2)
# if [ "$current" != "$latest" ]; then
#   echo "Installing dust"
#   cargo install --locked du-dust
#   echo "Installed dust"
# else
#   echo "dust up-to-date"
# fi

#╭──────────────────────────────────────────────────────────────────────────────────╮
#│                                     starship                                     │
#│https://github.com/starship/starship?tab=readme-ov-file#%F0%9F%9A%80-installation │
#╰──────────────────────────────────────────────────────────────────────────────────╯
# latest=$(get_latest_gh_release_tag "starship" "starship" | cut -d 'v' -f2)
# current=$(starship --version | head -n1 | cut -d ' ' -f2)
# if [ "$current" != "$latest" ]; then
#   echo "Upgrading starship"
#   cargo install starship --locked
#   echo "Upgraded starship"
# else
#   echo "Starship up-to-date"
# fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           yazi                           │
#          │   https://yazi-rs.github.io/docs/installation/#crates    │
#          ╰──────────────────────────────────────────────────────────╯
# latest=$(get_latest_gh_release_tag "sxyazi" "yazi" | cut -d 'v' -f2)
# current=$(yazi --version | cut -d ' ' -f2)
# if [ "$current" != "$latest" ]; then
#   echo "Upgrading yazi"
#   cargo install --locked yazi-fm yazi-cli
#   echo "Upgraded yazi"
# else
#   echo "Yazi up-to-date"
# fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          jless                           │
#          │                    https://jless.io/                     │
#          ╰──────────────────────────────────────────────────────────╯
# latest=$(get_latest_gh_release_tag "PaulJuliusMartinez" "jless" | cut -d 'v' -f2)
# current=$(jless --version | cut -d ' ' -f2)
# if [ "$current" != "$latest" ]; then
#   echo "Upgrading jless"
#   cargo install jless
#   echo "Upgraded jless"
# else
#   echo "Jless up-to-date"
# fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          zoxide                          │
#          │          https://github.com/ajeetdsouza/zoxide           │
#          ╰──────────────────────────────────────────────────────────╯
latest=$(get_latest_gh_release_tag "ajeetdsouza" "zoxide" | cut -d 'v' -f2)
current=$(zoxide --version | cut -d ' ' -f2)
if [ "$current" != "$latest" ]; then
  echo "Upgrading zoxide"
  curl -sSfLO --header "Authorization: Bearer ${GITHUB_DOTFILES_INSTALL_UPDATE_TOKEN}" https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh

  approve_script_execution "install.sh"

  ./install.sh

  rm install.sh

  echo "Upgraded zoxide"
else
  echo "Zoxide up-to-date"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          beets                           │
#          │             https://github.com/beetbox/beets             │
#          ╰──────────────────────────────────────────────────────────╯
latest=$(get_latest_gh_release_tag "beetbox" "beets" | cut -d 'v' -f2)
current=$(beet --version | head -n1 | cut -d ' ' -f3)
if [ "$current" != "$latest" ]; then
  pip install --upgrade beets
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          resvg                           │
#          │           https://github.com/linebender/resvg            │
#          ╰──────────────────────────────────────────────────────────╯
# NOTE: Library used to display SVG images in yazi
# resvg: /lib/x86_64-linux-gnu/libm.so.6: version `GLIBC_2.38' not found (required by resvg
# latest=$(get_latest_gh_release_tag "linebender" "resvg" | sed 's/v//g')
# current=$(resvg --version | cut -d ' ' -f2)
# if [ "$current" != "$latest" ]; then
#   cargo install --locked resvg
# fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         mergiraf                         │
#          │          https://mergiraf.org/installation.html          │
#          ╰──────────────────────────────────────────────────────────╯
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
