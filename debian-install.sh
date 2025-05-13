#!/usr/bin/env bash

# exit on error
# NOTE: Gotchyas: https://mywiki.wooledge.org/BashFAQ/105
set -e

mkdir -p ~/projects

if [ ! -d ~/projects/friendly-snippets ]; then
  git clone https://github.com/Drew-Daniels/friendly-snippets.git ~/projects/friendly-snippets
fi

if [ ! -d ~/projects/jg ]; then
  git clone https://codeberg.org/drewdaniels/jg.git ~/projects/jg
fi

sudo apt update -y

# TODO: Look into creating bash loading spinner library similar to:
#   https://github.com/molovo/revolver/blob/master/revolver
#   https://willcarh.art/blog/how-to-write-better-bash-spinners
# TODO: Add logging to indicate overall progress

# Check if the current user is a sudoer
if sudo -l &>/dev/null; then
  echo "The current user has sudo privileges."
else
  echo "The current user does not have sudo privileges."
  exit 1
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          cosign                          │
#          │            https://github.com/sigstore/cosign            │
#          ╰──────────────────────────────────────────────────────────╯
pkg=cosign

if [ ! -f "/usr/local/bin/$pkg" ]; then
  echo "Installing $pkg"
  curl -sLO "https://github.com/sigstore/$pkg/releases/latest/download/$pkg-linux-x86_64"
  sudo mv $pkg-linux-x86_64 /usr/local/bin/$pkg
  sudo chmod +x /usr/local/bin/$pkg
  echo "Installed $pkg"
else
  echo "Already installed $pkg"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         chezmoi                          │
#          │                 https://www.chezmoi.io/                  │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v chezmoi >/dev/null 2>&1; then
  echo "Installing chezmoi"
  version=$(curl -sL https://api.github.com/repos/twpayne/chezmoi/releases/latest | jq '.tag_name' | sed 's/"//g' | cut -d 'v' -f2)
  # Download .deb pkg, the checksum file, checksum file signature, and public signing key:
  curl --silent --location --remote-name-all \
    "https://github.com/twpayne/chezmoi/releases/download/v$version/chezmoi_${version}_linux_x86_64.deb" \
    "https://github.com/twpayne/chezmoi/releases/download/v$version/chezmoi_${version}_checksums.txt" \
    "https://github.com/twpayne/chezmoi/releases/download/v$version/chezmoi_${version}_checksums.txt.sig" \
    "https://github.com/twpayne/chezmoi/releases/download/v$version/chezmoi_cosign.pub"

  # verify the signature on the checksums file is valid
  cosign_verification_status=$(cosign verify-blob --key=chezmoi_cosign.pub --signature="chezmoi_${version}_checksums.txt.sig" "chezmoi_${version}_checksums.txt")

  if [ "$cosign_verification_status" -eq 1 ]; then
    echo "Signatures on Chemzoi checksums file is invalid"
    exit 1
  fi

  # verify the checksum matches
  if sha256sum --check "chezmoi_${version}_checksums.txt" --ignore-missing --status; then
    sudo apt install -y "./chezmoi_${version}_linux_x86_64.deb"
    echo "Installed chezmoi"
  else
    echo "Encountered an error "
    exit 1
  fi
else
  echo "chezmoi already installed"
fi

if [ ! -d ~/.local/share/chezmoi ]; then
  echo "Initializing dotfiles"
  # initialize dotfiles
  # github
  # chezmoi init https://github.com/Drew-Daniels/dotfiles.git --apply
  # codeberg
  chezmoi init https://codeberg.org/drewdaniels/dotfiles.git --apply
  echo "Initialized dotfiles"
else
  echo "Already initialized dotfiles"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          rustup                          │
#          │                    https://rustup.rs/                    │
#          ╰──────────────────────────────────────────────────────────╯
pkg="rustup"

if ! command -v $pkg >/dev/null 2>&1; then
  echo "Installing $pkg"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  # TODO: Restart terminal
  echo "Installed $pkg"
else
  echo "Already installed $pkg"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           mise                           │
#          │                  https://mise.jdx.dev/                   │
#          ╰──────────────────────────────────────────────────────────╯
pkg='mise'

if ! command -v $pkg >/dev/null 2>&1; then
  echo "Installing $pkg"
  # pre-reqs for building native C ruby extensions
  sudo apt install -y build-essential libz-dev libffi-dev libyaml-dev libssl-dev
  # pre-reqs for mise
  sudo apt install -y gpg sudo wget curl
  # mise installation
  sudo install -dm 755 /etc/apt/keyrings
  wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1>/dev/null
  echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=x86_64] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
  sudo apt update
  sudo apt install -y $pkg
  echo "Installed $pkg"
else
  echo "Already installed $pkg"
fi

#        ╭──────────────────────────────────────────────────────────────╮
#        │                   ## 1Password Desktop App                   │
#        │https://support.1password.com/install-linux/#debian-or-ubuntu │
#        ╰──────────────────────────────────────────────────────────────╯
pkg='1password'

if ! command -v $pkg >/dev/null 2>&1; then
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

if ! command -v op >/dev/null 2>&1; then
  echo "Installing $pkg"
  sudo apt update && sudo apt install -y $pkg
  # NOTE: Manual - Turn on the 1Password CLI Integration in 1Password Desktop app: https://developer.1password.com/docs/cli/get-started/#step-2-turn-on-the-1password-desktop-app-integration
  echo "Installed $pkg"
else
  echo "Already installed $pkg"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                   git-credential-oauth                   │
#          │     https://github.com/hickford/git-credential-oauth     │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v git-credential-oauth >/dev/null 2>&1; then
  echo "Installing git-credential-oauth"
  sudo apt-get install git-credential-oauth
  echo "Installed git-credential-oauth"
fi

#    ╭──────────────────────────────────────────────────────────────────────╮
#    │                               ripgrep                                │
#    │https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation │
#    ╰──────────────────────────────────────────────────────────────────────╯
pkg="ripgrep"

if ! command -v rg >/dev/null 2>&1; then
  echo "Installing ripgrep"
  latest=$(curl -sL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | jq '.tag_name' | sed 's/"//g' | cut -d 'v' -f2)
  base_url="https://github.com/BurntSushi/ripgrep/releases/download/${latest}"
  # TODO: Figure out why a -1 is always appended to version?
  deb="$base_url/ripgrep_${latest}-1_amd64.deb"
  sha="$base_url/ripgrep_${latest}-1_amd64.deb.sha256"
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
  echo "Already installed ripgrep"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          delta                           │
#          │       https://github.com/dandavison/delta/releases       │
#          ╰──────────────────────────────────────────────────────────╯
pkg='delta'

if ! command -v $pkg >/dev/null 2>&1; then
  echo "Installing $pkg"
  version=$(curl -sL https://api.github.com/repos/dandavison/delta/releases/latest | jq '.tag_name' | sed 's/"//g' | cut -d 'v' -f2)
  curl -sLO "https://github.com/dandavison/delta/releases/download/${version}/git-delta_${version}_amd64.deb"
  sudo apt install -y ./git-delta_"${version}"_amd64.deb
  echo "Installed $pkg"
else
  echo "Already installed $pkg"
fi

#╭──────────────────────────────────────────────────────────────────────────────────╮
#│                                     starship                                     │
#│https://github.com/starship/starship?tab=readme-ov-file#%F0%9F%9A%80-installation │
#╰──────────────────────────────────────────────────────────────────────────────────╯
if ! command -v starship >/dev/null 2>&1; then
  echo "Installing starship"
  cargo install starship --locked
  echo "Installed starship"
else
  echo "Already installed starship"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           fish                           │
#          │                  https://fishshell.com/                  │
#          ╰──────────────────────────────────────────────────────────╯
latest_major=$(curl -sL https://api.github.com/repos/fish-shell/fish-shell/releases/latest | jq '.tag_name' | sed 's/"//g;s/v//g' | cut -c1)
os_release_no=$(grep VERSION_ID </etc/os-release | cut -d '=' -f2 | sed 's/"//g')
if ! command -v fish >/dev/null 2>&1; then
  echo "deb http://download.opensuse.org/repositories/shells:/fish:/release:/${latest_major}/Debian_${os_release_no}/ /" | sudo tee "/etc/apt/sources.list.d/shells:fish:release:${latest_major}.list"
  curl -fsSL "https://download.opensuse.org/repositories/shells:fish:release:${latest_major}/Debian_${os_release_no}/Release.key" | gpg --dearmor | sudo tee "/etc/apt/trusted.gpg.d/shells_fish_release_${latest_major}.gpg" >/dev/null
  sudo apt update
  sudo apt install fish
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           fzf                            │
#          │       https://junegunn.github.io/fzf/installation/       │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v fzf >/dev/null 2>&1; then
  echo "Installing fzf"
  latest=$(curl -sL https://api.github.com/repos/junegunn/fzf/releases/latest | jq '.tag_name' | sed 's/"//g;s/v//g')
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
  sudo mv "$bin" "/usr/local/bin/$bin"

  rm "$tgz" "$checksums"
  echo "Installed fzf"
else
  echo "Already installed fzf"
fi

#          ╭───────────────────────────────────────────────────────────╮
#          │                            fd                             │
#          │https://github.com/sharkdp/fd?tab=readme-ov-file#on-debian │
#          ╰───────────────────────────────────────────────────────────╯
latest=$(curl -sL https://api.github.com/repos/sharkdp/fd/releases/latest | jq '.tag_name' | sed 's/"//g;s/v//g')
if ! command -v fd >/dev/null 2>&1; then
  echo "Installing fd"
  deb="fd_${latest}_amd64.deb"
  curl -sLO "https://github.com/sharkdp/fd/releases/download/v${latest}/${deb}"
  sudo apt install -y "./${deb}"
  rm "$deb"
  echo "Installed fd"
else
  echo "Already installed fd"
fi

#    ╭──────────────────────────────────────────────────────────────────────╮
#    │                                 bat                                  │
#    │https://github.com/sharkdp/bat?tab=readme-ov-file#on-ubuntu-using-apt │
#    ╰──────────────────────────────────────────────────────────────────────╯
if ! command -v bat >/dev/null 2>&1; then
  echo "Installing bat"
  sudo apt install -y bat
  ln -s /usr/bin/batcat ~/.local/bin/bat
  echo "Installed bat"
else
  echo "Already installed bat"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                        bat-extras                        │
#          │     https://github.com/eth-p/bat-extras/tree/master      │
#          ╰──────────────────────────────────────────────────────────╯
pkg="bat-extras"

if ! command -v batgrep >/dev/null 2>&1; then
  echo "Installing $pkg"
  cd ~/projects || exit
  git clone https://github.com/eth-p/$pkg.git ~/projects/bat-extras
  cd $pkg || exit
  ./build.sh --install
  cd ~
  echo "Installed $pkg"
else
  echo "Installed $pkg"
fi

#       ╭────────────────────────────────────────────────────────────────╮
#       │                             ctags                              │
#       │https://github.com/universal-ctags/ctags-nightly-build/releases │
#       ╰────────────────────────────────────────────────────────────────╯
pkg="ctags"
latest_tag_name=$(curl -sL https://api.github.com/repos/universal-ctags/ctags-nightly-build/releases/latest | jq '.tag_name' | sed 's/"//g')
latest_release_date=$(echo "$latest_tag_name" | cut -d '+' -f1)
latest_SHA_full=$(echo "$latest_tag_name" | cut -d '+' -f2)

if ! command -v ctags >/dev/null 2>&1; then
  echo "Installing $pkg"
  curl -sLO "https://github.com/universal-ctags/ctags-nightly-build/releases/download/${latest_release_date}%2B${latest_SHA_full}/uctags-${latest_release_date}-linux-x86_64.deb"
  sudo apt install -y "./uctags-${latest_release_date}-linux-x86_64.deb"
  rm "./uctags-${latest_release_date}-linux-x86_64.deb"
  echo "Installed $pkg"
else
  echo "Already installed $pkg"
fi

#╭──────────────────────────────────────────────────────────────────────────────╮
#│                                    awscli                                    │
#│https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html │
#╰──────────────────────────────────────────────────────────────────────────────╯

# NOTE: There is not currently a way to programmatically get the AWS public key, so have to install without
# verifying in programmic install
# https://github.com/aws/aws-cli/issues/6230
if ! command -v aws >/dev/null 2>&1; then
  echo "Installing awscli"
  curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  echo "Installed awscli"
else
  echo "Already installed awscli"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                       wl-clipboard                       │
#          │         https://github.com/bugaevc/wl-clipboard          │
#          ╰──────────────────────────────────────────────────────────╯
# allows neovim to access clipboard via wayland
if ! command -v wl-copy >/dev/null 2>&1; then
  echo "Installing wl-clipboard"
  sudo apt install -y wl-clipboard
  echo "Installed wl-clipboard"
else
  echo "Already installed wl-clipboard"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         lua 5.1                          │
#          │        https://www.lua.org/manual/5.4/readme.html        │
#          ╰──────────────────────────────────────────────────────────╯
version="5.1.5"
current=$(lua -v 2>&1 | cut -d ' ' -f2)

if [ "$current" != "$version" ]; then
  echo "Installing lua v5.1.5"
  # install build dependencies
  sudo apt-get install libreadline-dev
  # download
  curl -sLO https://www.lua.org/ftp/lua-${version}.tar.gz
  cd lua-${version} || exit
  # build
  make linux
  # verify
  make test
  # install
  sudo make install
  # cleanup
  rm -rf lua-5.1.5*
  cd ~
  echo "Installed lua v5.1.5"
else
  echo "Already installed lua v5.1.5"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         luarocks                         │
#          │                  https://luarocks.org/                   │
#          ╰──────────────────────────────────────────────────────────╯
version="3.11.1"

if ! command -v luarocks >/dev/null 2>&1; then
  echo "Installing luarocks"
  wget https://luarocks.org/releases/luarocks-${version}.tar.gz
  tar zxpf luarocks-${version}.tar.gz
  cd "luarocks-${version}" || exit
  ./configure
  make
  sudo make install
  sudo luarocks install luasocket
  cd ~
  echo "Installed luarocks"
else
  echo "Already installed luarocks"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                 jetbrains-mono-nerd-font                 │
#          │            https://www.jetbrains.com/lp/mono/            │
#          ╰──────────────────────────────────────────────────────────╯
if ! ls ~/.local/share/fonts/JetBrainsMonoNerdFont* >/dev/null 2>&1; then
  echo "Installing JetBrainsMonoNerdFont"
  latest=$(curl -sL https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | jq '.tag_name' | sed 's/"//g' | cut -d 'v' -f2)
  wget -P "$HOME/.local/share/fonts" "https://github.com/ryanoasis/nerd-fonts/releases/download/v${latest}/JetBrainsMono.zip"
  cd ~/.local/share/fonts
  unzip JetBrainsMono.zip
  rm JetBrainsMono.zip
  fc-cache -fv
  cd ~
  echo "Installed JetBrainsMonoNerdFont"
else
  echo "Already installed JetBrainsMonoNerdFont"
fi
#        ╭───────────────────────────────────────────────────────────────╮
#        │                            neovim                             │
#        │https://github.com/neovim/neovim/blob/master/INSTALL.md#debian │
#        ╰───────────────────────────────────────────────────────────────╯
if ! command -v nvim >/dev/null 2>&1; then
  echo "Installing neovim"
  pkg_name="nvim-linux-x86_64.tar.gz"
  checksums_filename="shasum.txt"
  base_repo_path="https://github.com/neovim/neovim/releases/latest/download/"

  curl -sLO "$base_repo_path/$pkg_name" -O "$base_repo_path/$checksums_filename"

  download_checksum=$(sha256sum "$pkg_name")
  verified_checksum=$(grep "linux-x86_64.tar" <shasum.txt)

  if [ "$download_checksum" == "$verified_checksum" ]; then
    echo "Neovim checksum verified"
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf "$pkg_name"
    rm "$pkg_name" "$checksums_filename"
    echo "Installed neovim"
  else
    echo "Could not install neovim - verify checksums"
  fi
else
  echo "Already installed neovim"
fi

# update sudoers file so I can use neovim as root
# sudo visudo

# in sudoers file, set these lines
# Defaults    secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/nvim-linux-x86_64/bin"
#
# # use neovim as default editor with root
# Defaults:%sudo env_keep += "EDITOR"

# post install
# nvim -c "MasonInstall ruff basedpyright clang-format jsonlint stlyua prettier nxls shfmt shellcheck sqlfmt reformat-gherkin yamlfmt"

#         ╭─────────────────────────────────────────────────────────────╮
#         │                            tmux                             │
#         │https://github.com/tmux/tmux/wiki/Installing#binary-packages │
#         ╰─────────────────────────────────────────────────────────────╯
if ! command -v tmux >/dev/null 2>&1; then
  echo "Installing tmux"
  sudo apt install -y tmux
  echo "Installed tmux"
else
  echo "Already installed tmux"
fi

#     ╭─────────────────────────────────────────────────────────────────────╮
#     │                             tmuxinator                              │
#     │https://github.com/tmuxinator/tmuxinator?tab=readme-ov-file#rubygems │
#     ╰─────────────────────────────────────────────────────────────────────╯

if ! command -v tmuxinator >/dev/null 2>&1; then
  echo "Installing tmuxinator"
  gem install tmuxinator
  echo "Installed tmuxinator"
else
  echo "Already installed tmuxinator"
fi

#        ╭──────────────────────────────────────────────────────────────╮
#        │                          alacritty                           │
#        │https://github.com/alacritty/alacritty/blob/master/INSTALL.md │
#        ╰──────────────────────────────────────────────────────────────╯
# NOTE: There are no precompiled binaries for linux. Need to build from source.
if ! command -v alacritty >/dev/null 2>&1; then
  echo "Installing alacritty"
  git clone https://github.com/alacritty/alacritty.git ~/projects/alacritty
  cd ~/projects/alacritty || exit
  rustup override set stable
  rustup update stable

  # install pre-reqs
  sudo apt install -y cmake g++ pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev scdoc desktop-file-utils

  # build
  cargo build --release

  # post-build
  sudo cp target/release/alacritty /usr/local/bin
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database

  # go back ~
  cd ~ || exit
  echo "Installed alactritty"
else
  echo "Already installed alacritty"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                            jq                            │
#          │               https://jqlang.org/download/               │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v jq >/dev/null 2>&1; then
  echo "Installing jq"
  sudo apt install -y jq
  echo "Installed jq"
else
  echo "Already installed jq"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                       imagemagick                        │
#          │        https://github.com/ImageMagick/ImageMagick        │
#          ╰──────────────────────────────────────────────────────────╯
# TODO: Create a security policy following guide here: https://imagemagick.org/script/security-policy.php
if ! command -v magick >/dev/null 2>&1; then
  echo "Installing imagemagick"
  # TODO: Use this logic everywhere else that I am interpolating version numbers, commit SHAs, etc. - seems more foolproof
  latest_download_url=$(curl -sL https://api.github.com/repos/ImageMagick/ImageMagick/releases/latest | jq '.assets[] | select(.name | contains("clang-x86_64.AppImage")) | .browser_download_url' | sed 's/"//g')
  curl -L "$latest_download_url" -o magick
  chmod +x magick
  sudo mv magick /usr/local/bin/
  echo "Installed imagemagick"
else
  echo "Already installed imagemagick"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          zoxide                          │
#          │          https://github.com/ajeetdsouza/zoxide           │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v zoxide >/dev/null 2>&1; then
  echo "Installing zoxide"
  sudo apt install -y zoxide
  echo "Installed zoxide"
else
  echo "Already installed zoxide"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           yazi                           │
#          │   https://yazi-rs.github.io/docs/installation/#crates    │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v yazi >/dev/null 2>&1; then
  echo "Installing yazi"
  # install deps
  sudo apt install -y ffmpeg 7zip poppler-utils
  # install yazi
  cargo install --locked yazi-fm yazi-cli
  echo "Installed yazi"
else
  echo "Already installed yazi"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          jless                           │
#          │                    https://jless.io/                     │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v jless >/dev/null 2>&1; then
  echo "Installing jless"
  cargo install jless
  echo "Installed jless"
else
  echo "Already installed jless"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                            yq                            │
#          │             https://github.com/mikefarah/yq              │
#          ╰──────────────────────────────────────────────────────────╯

if ! command -v yq >/dev/null; then
  echo "Installing yq"
  latest=$(curl -sL https://api.github.com/repos/mikefarah/yq/releases/latest | jq '.tag_name' | sed 's/"//g')
  base_url="https://github.com/mikefarah/yq/releases/download/${latest}"
  curl --silent --location --remote-name-all "$base_url/yq_linux_amd64.tar.gz" "$base_url/extract-checksum.sh" "$base_url/checksums_hashes_order" "$base_url/checksums"

  # NOTE: Adding echo to put a newline after script contents, for readability
  cat extract-checksum.sh && printf '\n\n'

  while true; do
    read -p "Does the above script look safe?" yesno
    case $yesno in
    [Yy]*)
      break
      ;;
    [Nn]*)
      exit
      ;;
    *) echo "Answer either yes or no!" ;;
    esac
  done

  chmod +x ./extract-checksum.sh

  if ./extract-checksum.sh SHA-256 yq_linux_amd64.tar.gz | awk '{ print $2 " " $1}' | sha256sum -c --status; then
    tar xzf "yq_linux_amd64.tar.gz"
    sudo mv yq_linux_amd64 /usr/local/bin/yq
    rm yq_linux_amd64.tar.gz extract-checksum.sh checksums_hashes_order checksums yq.1 install-man-page.sh
    echo "Installed yq"
  else
    echo "Could not install yq - verify checksums"
  fi
else
  echo "Already installed yq"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                      standard notes                      │
#          │         https://standardnotes.com/download/linux         │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v standard-notes >/dev/null 2>&1; then
  echo "Installing standard notes"
  latest=$(curl -sL https://api.github.com/repos/standardnotes/app/releases/latest | jq '.tag_name' | sed 's/"//g' | cut -d '@' -f3)
  # TODO: Not sure what the 403.195.13 refers to, or if it will change between releases
  base_url="https://github.com/standardnotes/app/releases/download/%40standardnotes%2Fdesktop%403.195.13"
  deb="standard-notes-${latest}-linux-amd64.deb"
  curl -L --remote-name-all "$base_url/$deb" "$base_url/SHA256SUMS"
  verified_checksum=$(rg "linux-amd64.deb" <SHA256SUMS)
  download_checksum=$(sha256sum "$deb")
  if [ "$download_checksum" == "$verified_checksum" ]; then
    sudo apt install -y "./$deb"
    rm "$deb" "SHA256SUMS"
    echo "Installed standard notes"
  else
    echo "Could not install Standard Notes - verify checksums"
  fi
else
  echo "Already installed standard notes"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                      docker desktop                      │
#          │   https://docs.docker.com/desktop/setup/install/linux/   │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v docker >/dev/null 2>&1; then
  echo "Installing docker"
  sudo apt install -y gnome-terminal

  # Add Docker's official GPG key:
  sudo apt-get update
  sudo apt-get install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt-get update

  # Install Docker Packages
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # Download latest release
  curl -sLO https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb

  # Install
  sudo apt install -y ./docker-desktop-amd64.deb

  systemctl --user start docker-desktop
  # https://stackoverflow.com/a/73564032/13175926
  # NOTE: If I get an "Can't connect to Docker Daemon" error, run:
  # docker context use default
  echo "Installed docker"
else
  echo "Already installed docker"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                      OpenSSH Server                      │
#          │                 https://www.openssh.com/                 │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install -y openssh-server

#          ╭──────────────────────────────────────────────────────────╮
#          │                          restic                          │
#          │             https://github.com/restic/restic             │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v restic >/dev/null 2>&1; then
  echo "Installing restic"
  sudo apt install -y restic
  sudo restic generate --bash-completion /usr/share/bash-completion/completions/restic
  echo "Installed restic"
else
  echo "Already installed restic"
fi

# NOTE: fish completions are already stored in dotfiles

#          ╭──────────────────────────────────────────────────────────╮
#          │                      resticprofile                       │
#          │    https://github.com/creativeprojects/resticprofile     │
#          ╰──────────────────────────────────────────────────────────╯
latest=$(curl -sL https://api.github.com/repos/creativeprojects/resticprofile/releases/latest | jq '.tag_name' | sed 's/"//g' | cut -d 'v' -f2)
current=$(resticprofile version | cut -d ' ' -f3)
if ! command -v resticprofile >/dev/null 2>&1; then
  echo "Installing resticprofile"
  curl -sLO "https://github.com/creativeprojects/resticprofile/releases/latest/download/resticprofile_${latest}_linux_amd64.tar.gz"
  mkdir "resticprofile_${latest}_linux_amd64"
  tar -xzpf "resticprofile_${latest}_linux_amd64.tar.gz" -C "resticprofile_${latest}_linux_amd64"
  sudo cp "resticprofile_${latest}_linux_amd64/resticprofile" /usr/local/bin/
  rm -rf restic*
  echo "Installed resticprofile"
else
  echo "Already installed resticprofile"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           dust                           │
#          │             https://github.com/bootandy/dust             │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v dust >/dev/null 2>&1; then
  echo "Installing dust"
  cargo install du-dust
  echo "Installed dust"
else
  echo "Already installed dust"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          kiwix                           │
#          │       https://tracker.debian.org/teams/kiwix-team/       │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v kiwix-desktop >/dev/null 2>&1; then
  echo "Installing kiwix-desktop"
  sudo apt install -y kiwix
  echo "Installed kiwix-desktop"
else
  echo "Already installed kiwix-desktop"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           rofi                           │
#          │            https://github.com/davatorium/rofi            │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v rofi >/dev/null 2>&1; then
  echo "Installing rofi"
  sudo apt install -y rofi
  echo "Installed rofi"
else
  echo "Already installed rofi"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                      speedtest-cli                       │
#          │          https://github.com/sivel/speedtest-cli          │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v speedtest-cli >/dev/null 2>&1; then
  sudo apt install -y speedtest-cli
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                       uuid-runtime                       │
#          │       https://packages.debian.org/sid/uuid-runtime       │
#          ╰──────────────────────────────────────────────────────────╯
# NOTE: For creating unique identifiers (like when working with S3)
if ! command -v uuidgen >/dev/null 2>&1; then
  echo "Installing uuidgen"
  sudo apt install -y uuid-runtime
  echo "Installed uuidgen"
else
  echo "Already installed uuidgen"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                            i3                            │
#          │                 https://github.com/i3/i3                 │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v i3 >/dev/null 2>&1; then
  echo "Installing i3"
  sudo apt install -y i3
  echo "Installed i3"
else
  echo "Already installed i3"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                      brightnessctl                       │
#          │       https://github.com/Hummer12007/brightnessctl       │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v brightnessctl >/dev/null 2>&1; then
  echo "Installing brightnessctl"
  sudo usermod -aG video "$USER"
  sudo apt install -y brightnessctl
  echo "Installed brightnessctl"
else
  echo "Already installed brightnessctl"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                        strawberry                        │
#          │   https://github.com/strawberrymusicplayer/strawberry    │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v strawberry >/dev/null 2>&1; then
  echo "Installing strawberry"
  sudo apt install -y strawberry
  echo "Installed strawberry"
else
  echo "Already installed strawberry"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           feh                            │
#          │               https://github.com/derf/feh                │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v feh >/dev/null 2>&1; then
  echo "Installing feh"
  sudo apt install -y feh
  echo "Installed feh"
else
  echo "Already installed feh"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                        xmlstarlet                        │
#          │       https://xmlstar.sourceforge.net/download.php       │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v xmlstarlet >/dev/null 2>&1; then
  echo "Installing xmlstarlet"
  sudo apt install xmlstarlet
  echo "Installed xmlstarlet"
else
  echo "Already installed xmlstarlet"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         mergiraf                         │
#          │          https://mergiraf.org/installation.html          │
#          ╰──────────────────────────────────────────────────────────╯
latest=$(curl -sL https://codeberg.org/mergiraf/mergiraf/releases.rss | xmlstarlet sel -t -v "//channel/item[1]/title" | cut -d ' ' -f2)
if ! command -v mergiraf >/dev/null 2>&1; then
  echo "Installing mergiraf"
  curl -sLO "https://codeberg.org/mergiraf/mergiraf/releases/download/v${latest}/mergiraf_x86_64-unknown-linux-gnu.tar.gz"
  tar xzf "mergiraf_x86_64-unknown-linux-gnu.tar.gz"
  sudo mv mergiraf /usr/local/bin/
  echo "Installed mergiraf"
else
  echo "Already installed mergiraf"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           nmap                           │
#          │                https://svn.nmap.org/nmap/                │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v nmap >/dev/null 2>&1; then
  echo "Installing nmap"
  sudo apt install -y nmap
  echo "Installed nmap"
else
  echo "Already installed nmap"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         thorium                          │
#          │          https://github.com/Alex313031/thorium           │
#          ╰──────────────────────────────────────────────────────────╯
# install dependencies
pkg="thorium-browser"
if ! command -v $pkg >/dev/null 2>&1; then
  echo "Installing thorium"
  sudo wget --no-hsts -P /etc/apt/sources.list.d/ \
    http://dl.thorium.rocks/debian/dists/stable/thorium.list &&
    sudo apt update
  echo "Installed thorium"
else
  echo "Already installed thorium"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         openvpn                          │
#          │            https://github.com/OpenVPN/openvpn            │
#          ╰──────────────────────────────────────────────────────────╯
# usage: sudo openvpn <config>
if [ ! -x /sbin/openvpn ]; then
  echo "Installing openvpn"
  sudo apt install -y openvpn
  echo "Installing openvpn"
else
  echo "Already installed openvpn"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                        wireguard                         │
#          │            https://www.wireguard.com/install/            │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v wg >/dev/null 2>&1; then
  echo "Installing wireguard"
  sudo apt install -y wireguard
  echo "Installed wireguard"
else
  echo "Already installed wireguard"
fi
# Notes on creating and using client configurations
# # Create and download client configuration file from Wireguard server
# # move into wireguard configuration folder
# sudo mv client.conf /etc/wireguard/wg0.conf
# # import the client profile
# sudo nmcli connection import type wireguard file "/etc/wireguard/wg0.conf"
# # to stop the connection
# nmcli connection stop wg0
# # to start again
# nmcli connection start wg0
# # don't autoconnect on startup
# nmcli connection modify wg0 autoconnect no

#          ╭──────────────────────────────────────────────────────────╮
#          │                         plocate                          │
#          │                https://plocate.sesse.net/                │
#          ╰──────────────────────────────────────────────────────────╯
# NOTE: Provides `updatedb` and `locate` commands - alternative to `locate`
if ! command -v plocate >/dev/null 2>&1; then
  echo "Installing plocate"
  sudo apt install -y plocate
  echo "Installed plocate"
else
  echo "Already installed plocate"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         gparted                          │
#          │                   https://gparted.org/                   │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v gparted >/dev/null 2>&1; then
  echo "Installing gparted"
  # NOTE: for fat32
  sudo apt install -y dosfstools mtools
  sudo apt install -y gparted
  echo "Installed gparted"
else
  echo "Already installed gparted"
fi

# NOTE: Miscellaneous notes on unmounting and shutting down USB drives
# # unmount
# sudo eject /dev/sdb
# # shut down
# udisksctl power-off -b /dev/sdb
# physically pull out USB

#          ╭──────────────────────────────────────────────────────────╮
#          │                           zoom                           │
#          │            https://zoom.us/download?os=linux             │
#          ╰──────────────────────────────────────────────────────────╯
# version='6.4.0.471'
#
# if ! command -v zoom >/dev/null 2>&1; then
#   echo "Installing zoom"
#   curl -sLO https://zoom.us/client/${version}/zoom_amd64.deb
#   sudo apt install -y ./zoom_amd64.deb
#   echo "Installed zoom"
# else
#   echo "Already installed zoom"
# fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                      keep-presence                       │
#          │        https://github.com/carrot69/keep-presence         │
#          ╰──────────────────────────────────────────────────────────╯
# for keeping computer awake during long-running processes
if ! command -v keep_presence >/dev/null 2>&1; then
  echo "Installing keep-presence"
  python3 -m pip install keep_presence
  echo "Installed keep-presence"
else
  echo "Already installed keep-presence"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                       tidal-dl-ng                        │
#          │          https://github.com/exislow/tidal-dl-ng          │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v tidal-dl-ng >/dev/null 2>&1; then
  echo "Installing tidal-dl-ng"
  pip install --upgrade tidal-dl-ng[gui]
  echo "Installed tidal-dl-ng"
else
  echo "Already installed tidal-dl-ng"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           cmus                           │
#          │               https://github.com/cmus/cmus               │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v cmus >/dev/null 2>&1; then
  echo "Installing cmus"
  sudo apt install -y cmus
  echo "Installed cmus"
else
  echo "Already installed cmus"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          cmusfm                          │
#          │              https://github.com/Arkq/cmusfm              │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v cmusfm >/dev/null 2>&1; then
  echo "Installing cmusfm"
  # install dependencies
  sudo apt install -y libcurl4-openssl-dev libnotify-dev
  # configure
  autoreconf --install
  mkdir build && cd build || exit
  ../configure --enable-libnotify
  # build & install
  make && make install
  cd ~
  echo "Installed cmusfm"
else
  echo "Already installed cmusfm"
fi

# NOTE: Post-installation steps
# create cmusfm config (if one doesn't already exist)
# cmusfm init
# # set as status display program for cmus
# cmus
# # ... in cmus ...
# :set status_display_program=cmusfm

#          ╭──────────────────────────────────────────────────────────╮
#          │                        librewolf                         │
#          │        https://librewolf.net/installation/debian/        │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v librewolf >/dev/null 2>&1; then
  echo "Installing librewolf"
  sudo extrepo enable librewolf
  sudo apt update && sudo apt install librewolf -y
  echo "Installed librewolf"
else
  echo "Already installed librewolf"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         mullvad                          │
#          │        https://mullvad.net/en/download/vpn/linux         │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v mullvad >/dev/null 2>&1; then
  echo "Installing mullvad"
  # TODO: Check if mullvad keyring is already installed, and listed as a repository

  # Download the Mullvad signing key
  sudo curl -fsSLo /usr/share/keyrings/mullvad-keyring.asc https://repository.mullvad.net/deb/mullvad-keyring.asc
  # Add the Mullvad repository server to apt
  echo "deb [signed-by=/usr/share/keyrings/mullvad-keyring.asc arch=$(dpkg --print-architecture)] https://repository.mullvad.net/deb/stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/mullvad.list
  # Install the package
  sudo apt update
  sudo apt install -y mullvad-vpn
  echo "Installed mullvad"
else
  echo "Already installed mullvad"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         foliate                          │
#          │         https://johnfactotum.github.io/foliate/          │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v foliate >/dev/null 2>&1; then
  echo "Installing foliate"
  sudo apt install -y foliate
  echo "Installed foliate"
else
  echo "Already installed foliate"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                pulse audio volume control                │
#          │ https://freedesktop.org/software/pulseaudio/pavucontrol/ │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v pavucontrol >/dev/null 2>&1; then
  echo "Installing pavucontrol"
  sudo apt install -y pavucontrol
  echo "Installed pavucontrol"
else
  echo "Already installed pavucontrol"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                        usbimager                         │
#          │           https://gitlab.com/bztsrc/usbimager            │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v usbimager >/dev/null 2>&1; then
  echo "Installing usbimager"
  curl -sLO https://gitlab.com/bztsrc/usbimager/-/raw/binaries/usbimager_1.0.10-amd64.deb
  apt install -y ./usbimager_1.0.10-amd64.deb
  rm usbimager_1.0.10-amd64.deb
  echo "Installed usbimager"
else
  echo "Already installled usbimager"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                    gnome-disk-utility                    │
#          │    https://gitlab.gnome.org/GNOME/gnome-disk-utility     │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v gnome-disks >/dev/null 2>&1; then
  echo "Installing gnome-disk-utility"
  sudo apt install gnome-disk-utility
  echo "Installed gnome-disk-utility"
else
  echo "Already installed gnome-disk-utility"
fi

# TODO: Look into using LUKS instead

#          ╭──────────────────────────────────────────────────────────╮
#          │                          zulip                           │
#          │   https://chat.fhir.org/help/desktop-app-install-guide   │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v zulip >/dev/null 2>&1; then
  echo "Installing zulip"
  sudo curl -fL -o /etc/apt/trusted.gpg.d/zulip-desktop.asc \
    https://download.zulip.com/desktop/apt/zulip-desktop.asc
  echo "deb https://download.zulip.com/desktop/apt stable main" |
    sudo tee /etc/apt/sources.list.d/zulip-desktop.list
  sudo apt update
  sudo apt install zulip
  echo "Installed zulip"
else
  echo "Already installed zulip"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          signal                          │
#          │            https://signal.org/download/linux/            │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v signal-desktop >/dev/null 2>&1; then
  # 1. Install our official public software signing key:
  wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor >signal-desktop-keyring.gpg
  cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg >/dev/null

  # 2. Add our repository to your list of repositories:
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |
    sudo tee /etc/apt/sources.list.d/signal-xenial.list

  # 3. Update your package database and install Signal:
  sudo apt update && sudo apt install signal-desktop

  # 4. cleanup
  rm signal-desktop-keyring.gpg

fi
# cleanup
sudo apt autoremove -y
sudo apt autoclean -y

# TODO: Only reboot if something in the system environment has changed as a result of code run in this file. Might be hard to determine/track this. Might be able to use a local variable to track when a change is made, that is worth rebooting for.
# reboot
