#!/user/bin/env bash

# exit on error
# NOTE: Gotchyas: https://mywiki.wooledge.org/BashFAQ/105
set -e

arch=$(arch)

# pre-flight
if [ ! -d ~/projects ]; then
  mkdir ~/projects
fi

# TODO: Look into creating bash loading spinner library similar to:
#   https://github.com/molovo/revolver/blob/master/revolver
#   https://willcarh.art/blog/how-to-write-better-bash-spinners
# TODO: Add logging to indicate overall progress
# TODO: Determine if the 'sudo' modifiers are necessary if running the entire script with 'sudo' prefix
# TODO: Build in checks to alert user if there is a newer version of a pkg hosted on github
#       Ex.) chezmoi, delta, or any other package downloaded from GitHub releases
# TODO: Figure out how to make this script idempotent
#   Uninstall unzipped directories when they're no longer necessary
#   rm *.deb files when no longer needed
# TODO: Look into breaking up this script into smaller scripts, where each one handles running all the various installation steps, including installing dependencies and removing files after use

# TODO: check if current user is a sudoer
# if not, indicate this is required an exit
# if so, continue
# TODO: Break up this script into a pre-install and install script so one can be used to add a user to sudoers file, and the other can be used to actually install all packages

# TODO: Make sure to jump back to ~ after cd'ing to specific directories
#          ╭──────────────────────────────────────────────────────────╮
#          │                          cosign                          │
#          │            https://github.com/sigstore/cosign            │
#          ╰──────────────────────────────────────────────────────────╯
pkg=cosign

if [ ! -f "/usr/local/bin/cosign" ]; then
  echo "Installing $pkg"
  curl -LO "https://github.com/sigstore/$pkg/releases/latest/download/$pkg-linux-amd64"
  sudo mv $pkg-linux-amd64 /usr/local/bin/$pkg
  sudo chmod +x /usr/local/bin/$pkg
  echo "Installed $pkg"
else
  echo "Already installed $pkg"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         chezmoi                          │
#          │                 https://www.chezmoi.io/                  │
#          ╰──────────────────────────────────────────────────────────╯
pkg=chezmoi
version=2.60.1

if ! command -v $pkg >/dev/null 2>&1; then
  echo "Installing $pkg"
  # Download .deb pkg, the checksum file, checksum file signature, and public signing key:
  curl --location --remote-name-all \
    "https://github.com/twpayne/chezmoi/releases/download/v$version/chezmoi_${version}_linux_amd64.deb" \
    "https://github.com/twpayne/chezmoi/releases/download/v$version/chezmoi_${version}_checksums.txt" \
    "https://github.com/twpayne/chezmoi/releases/download/v$version/chezmoi_${version}_checksums.txt.sig" \
    "https://github.com/twpayne/chezmoi/releases/download/v$version/chezmoi_cosign.pub"

  # verify the signature on the checksums file is valid
  cosign_verification_status=$(cosign verify-blob --key=chezmoi_cosign.pub --signature=chezmoi_2.59.1_checksums.txt.sig chezmoi_2.59.1_checksums.txt)

  if [ "$cosign_verification_status" -eq 1 ]; then
    exit 1
  fi

  # verify the checksum matches
  if sha256sum --check chezmoi_2.59.1_checksums.txt --ignore-missing --status; then
    # install chezmoi
    sudo apt install ./chezmoi_2.60.1_linux_amd64.deb
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

if ! command -v $pkg; then
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
if ! command -v mise; then
  echo "Installing mise"
  # pre-reqs for building native C ruby extensions
  sudo apt-get install build-essential libz-dev libffi-dev libyaml-dev libssl-dev
  # pre-reqs for mise
  sudo apt update -y && sudo apt install -y gpg sudo wget curl
  # mise installation
  sudo install -dm 755 /etc/apt/keyrings
  wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1>/dev/null
  echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
  sudo apt update
  sudo apt install -y mise
  echo "Installed mise"
else
  echo "Already installed mise"
fi

#        ╭──────────────────────────────────────────────────────────────╮
#        │                   ## 1Password Desktop App                   │
#        │https://support.1password.com/install-linux/#debian-or-ubuntu │
#        ╰──────────────────────────────────────────────────────────────╯
if ! command -v 1password; then
  echo "Installing 1password"
  # Add the key for the 1Password apt repository:
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

  # Add the 1Password apt repository:
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list

  # Add the debsig-verify policy
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

  # Install 1Password Desktop
  sudo apt update && sudo apt install 1password
  echo "Installed 1password"
else
  echo "Already installed 1password"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                      1Password CLI                       │
#          │  https://developer.1password.com/docs/cli/get-started/   │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v op; then
  echo "Installing 1password-cli"
  curl -sS https://downloads.1password.com/linux/keys/1password.asc |
    sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg &&
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
    sudo tee /etc/apt/sources.list.d/1password.list &&
    sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ &&
    curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol |
    sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol &&
    sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 &&
    curl -sS https://downloads.1password.com/linux/keys/1password.asc |
    sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg &&
    sudo apt update && sudo apt install 1password-cli
  # TODO: Manual - Turn on the 1Password CLI Integration in 1Password Desktop app: https://developer.1password.com/docs/cli/get-started/#step-2-turn-on-the-1password-desktop-app-integration
  echo "Installed 1password-cli"
else
  echo "Already installed 1password-cli"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                   git-credential-oauth                   │
#          │     https://github.com/hickford/git-credential-oauth     │
#          ╰──────────────────────────────────────────────────────────╯
# TODO: Figure out good way to check for apt-installed pkgs
sudo apt-get install git-credential-oauth

#    ╭──────────────────────────────────────────────────────────────────────╮
#    │                               ripgrep                                │
#    │https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation │
#    ╰──────────────────────────────────────────────────────────────────────╯
pkg="ripgrep"

if command -v rg; then
  echo "Installing ripgrep"
  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
  sudo apt install ./ripgrep_14.1.0-1_amd64.deb
  echo "Installed ripgrep"
else
  echo "Already installed ripgrep"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          delta                           │
#          │       https://github.com/dandavison/delta/releases       │
#          ╰──────────────────────────────────────────────────────────╯
if command -v delta; then
  echo "Installing delta"
  curl -LO https://github.com/dandavison/delta/releases/download/0.18.2/delta-https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_amd64.deb
  sudo apt install ./git-delta_0.18.2_amd64.deb
  echo "Installed delta"
else
  echo "Already installed delta"
fi

#╭──────────────────────────────────────────────────────────────────────────────────╮
#│                                     starship                                     │
#│https://github.com/starship/starship?tab=readme-ov-file#%F0%9F%9A%80-installation │
#╰──────────────────────────────────────────────────────────────────────────────────╯
if command -v starship; then
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
if command -v fish; then
  echo "Installing fish"
  echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
  curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg >/dev/null
  sudo apt update
  sudo apt install fish
  echo "Installed fish"
else
  echo "Already installed fish"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           fzf                            │
#          │       https://junegunn.github.io/fzf/installation/       │
#          ╰──────────────────────────────────────────────────────────╯
if command -v fzf; then
  echo "Installing fzf"
  sudo apt install fzf
  echo "Installed fzf"
else
  echo "Already installed fzf"
fi

#          ╭───────────────────────────────────────────────────────────╮
#          │                            fd                             │
#          │https://github.com/sharkdp/fd?tab=readme-ov-file#on-debian │
#          ╰───────────────────────────────────────────────────────────╯
if command -v fd; then
  mkdir p ~/.local/bin
  sudo apt install fd-find
  ln -s "$(which fdfind)" ~/.local/bin/fd
fi

#    ╭──────────────────────────────────────────────────────────────────────╮
#    │                                 bat                                  │
#    │https://github.com/sharkdp/bat?tab=readme-ov-file#on-ubuntu-using-apt │
#    ╰──────────────────────────────────────────────────────────────────────╯
if command -v bat; then
  sudo apt install bat
  ln -s /usr/bin/batcat ~/.local/bin/bat
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                        bat-extras                        │
#          │     https://github.com/eth-p/bat-extras/tree/master      │
#          ╰──────────────────────────────────────────────────────────╯
pkg="bat-extras"

if command -v batgrep; then
  echo "Installing $pkg"
  cd ~/projects || exit
  git clone https://github.com/eth-p/$pkg.git
  cd $pkg || exit
  ./build.sh --install
  echo "Installed $pkg"
else
  echo "Installed $pkg"
fi

#       ╭────────────────────────────────────────────────────────────────╮
#       │                             ctags                              │
#       │https://github.com/universal-ctags/ctags-nightly-build/releases │
#       ╰────────────────────────────────────────────────────────────────╯
pkg="ctags"
release_date="2025.03.17"

if command -v ctags; then
  echo "Installing $pkg"
  # TODO: Generalize this URL - the checksum is included might make it difficult to update
  curl -LO "https://github.com/universal-ctags/ctags-nightly-build/releases/download/2025.03.17%2Bcff205ee0d66994f1e26e0b7e3c9c482c7595bbc/uctags-${release_date}-linux-${arch}.deb"
  sudo apt install "./uctags-${release_date}-linux-${arch}.deb"
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
if command -v aws; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                       wl-clipboard                       │
#          │         https://github.com/bugaevc/wl-clipboard          │
#          ╰──────────────────────────────────────────────────────────╯
# allows neovim to access clipboard via wayland
if command -v wl-copy; then
  sudo apt install wl-clipboard
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         lua 5.1                          │
#          │        https://www.lua.org/manual/5.4/readme.html        │
#          ╰──────────────────────────────────────────────────────────╯
# TODO: Might want to update this to specifically check if lua 5.1 installed
if command -v lua; then
  # install build dependencies
  sudo apt-get install libreadline-dev

  # download
  curl -LO https://www.lua.org/ftp/lua-5.1.5.tar.gz
  cd lua-5.1.5 || exit
  # build
  make linux
  # verify
  make test
  # install
  sudo make install
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         luarocks                         │
#          │                  https://luarocks.org/                   │
#          ╰──────────────────────────────────────────────────────────╯
if command -v luarocks; then
  wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
  tar zxpf luarocks-3.11.1.tar.gz
  cd luarocks-3.11.1 || exit
  ./configure && make && sudo make install
  sudo luarocks install luasocket
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                 jetbrains-mono-nerd-font                 │
#          │            https://www.jetbrains.com/lp/mono/            │
#          ╰──────────────────────────────────────────────────────────╯
if ! ls ~/.local/share/fonts/JetBrainsMonoNerdFont* >/dev/null 2>&1; then
  wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip &&
    cd ~/.local/share/fonts &&
    unzip JetBrainsMono.zip &&
    rm JetBrainsMono.zip &&
    fc-cache -fv
fi
#        ╭───────────────────────────────────────────────────────────────╮
#        │                            neovim                             │
#        │https://github.com/neovim/neovim/blob/master/INSTALL.md#debian │
#        ╰───────────────────────────────────────────────────────────────╯
if command -v nvim; then
  # TODO: Figure out what requires 'yarn'
  # tree-sitter-cli required by Swift LSP
  npm i -g yarn tree-sitter-cli
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
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
if command -v tmux; then
  sudo apt install tmux
fi

#     ╭─────────────────────────────────────────────────────────────────────╮
#     │                             tmuxinator                              │
#     │https://github.com/tmuxinator/tmuxinator?tab=readme-ov-file#rubygems │
#     ╰─────────────────────────────────────────────────────────────────────╯

if command -v tmuxinator; then
  gem install tmuxinator
fi

#        ╭──────────────────────────────────────────────────────────────╮
#        │                          alacritty                           │
#        │https://github.com/alacritty/alacritty/blob/master/INSTALL.md │
#        ╰──────────────────────────────────────────────────────────────╯
# NOTE: There are no precompiled binaries for linux. Need to build from source.
if command -v alacritty; then
  git clone https://github.com/alacritty/alacritty.git ~/projects/alacritty
  cd ~/projects/alacritty || exit
  rustup override set stable
  rustup update stable

  # install pre-reqs
  sudo apt install cmake g++ pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev scdoc desktop-file-utils

  # build
  cargo build --release

  # post-build
  sudo cp target/release/alacritty /usr/local/bin
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database

  # go back ~
  cd ~ || exit
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                            jq                            │
#          │               https://jqlang.org/download/               │
#          ╰──────────────────────────────────────────────────────────╯
if command -v jq; then
  sudo apt install jq
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                       imagemagick                        │
#          │        https://github.com/ImageMagick/ImageMagick        │
#          ╰──────────────────────────────────────────────────────────╯
if command -v imagemagick; then
  sudo apt install imagemagick
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          zoxide                          │
#          │          https://github.com/ajeetdsouza/zoxide           │
#          ╰──────────────────────────────────────────────────────────╯
if command -v zoxide; then
  sudo apt install zoxide
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           yazi                           │
#          │   https://yazi-rs.github.io/docs/installation/#crates    │
#          ╰──────────────────────────────────────────────────────────╯
if command -v yazi; then
  # install deps
  sudo apt install ffmpeg 7zip poppler-utils
  # install yazi
  cargo install --locked yazi-fm yazi-cli
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          jless                           │
#          │                    https://jless.io/                     │
#          ╰──────────────────────────────────────────────────────────╯
if command -v jless; then
  cargo install jless
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                      standard notes                      │
#          │         https://standardnotes.com/download/linux         │
#          ╰──────────────────────────────────────────────────────────╯
if command -v standard_notes; then
  curl -LO https://github.com/standardnotes/app/releases/download/%40standardnotes/desktop%403.195.25/standard-notes-3.195.25-linux-x86_64.AppImage
  chmod a+x standard-notes-3.195.25-linux-x86_64.AppImage
  mv standard-notes-3.195.25-linux-x86_64.AppImage /opt/standard_notes/standard_notes
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                      docker desktop                      │
#          │   https://docs.docker.com/desktop/setup/install/linux/   │
#          ╰──────────────────────────────────────────────────────────╯
if command -v docker; then
  sudo apt install gnome-terminal

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
  curl -LO https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb

  # Install
  sudo apt install ./docker-desktop-amd64.deb

  systemctl --user start docker-desktop
  # https://stackoverflow.com/a/73564032/13175926
  # NOTE: If I get an "Can't connect to Docker Daemon" error, run:
  # docker context use default
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                      OpenSSH Server                      │
#          │                 https://www.openssh.com/                 │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install openssh-server

#          ╭──────────────────────────────────────────────────────────╮
#          │                          restic                          │
#          │             https://github.com/restic/restic             │
#          ╰──────────────────────────────────────────────────────────╯
if command -v restic; then
  sudo apt install restic
  sudo restic generate --bash-completion /usr/share/bash-completion/completions/restic
fi

# NOTE: fish completions are already stored in dotfiles

#          ╭──────────────────────────────────────────────────────────╮
#          │                      resticprofile                       │
#          │    https://github.com/creativeprojects/resticprofile     │
#          ╰──────────────────────────────────────────────────────────╯
if command -v resticprofile; then
  curl -LO https://github.com/creativeprojects/resticprofile/releases/latest/download/resticprofile_0.29.1_linux_amd64.tar.gz
  mkdir resticprofile_0.29.1_linux_amd64
  tar -xzpf resticprofile_0.29.1_linux_amd64.tar.gz -C resticprofile_0.29.1_linux_amd64
  sudo cp resticprofile_0.29.1_linux_amd64/resticprofile /usr/local/bin/
  rm -rf restic*
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           dust                           │
#          │             https://github.com/bootandy/dust             │
#          ╰──────────────────────────────────────────────────────────╯
if command -v dust; then
  cargo install du-dust
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          kiwix                           │
#          │       https://tracker.debian.org/teams/kiwix-team/       │
#          ╰──────────────────────────────────────────────────────────╯
if command -v kiwix-desktop; then
  sudo apt install kiwix
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           rofi                           │
#          │            https://github.com/davatorium/rofi            │
#          ╰──────────────────────────────────────────────────────────╯
if command -v rofi; then
  sudo apt install rofi
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                      speedtest-cli                       │
#          │          https://github.com/sivel/speedtest-cli          │
#          ╰──────────────────────────────────────────────────────────╯
if command -v speedtest-cli; then
  sudo apt install speedtest-cli
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                       uuid-runtime                       │
#          │       https://packages.debian.org/sid/uuid-runtime       │
#          ╰──────────────────────────────────────────────────────────╯
# NOTE: For creating unique identifiers (like when working with S3)
if command -v uuidgen; then
  sudo apt install uuid-runtime
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                            i3                            │
#          │                 https://github.com/i3/i3                 │
#          ╰──────────────────────────────────────────────────────────╯
if command -v i3; then
  sudo apt install i3
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                      brightnessctl                       │
#          │       https://github.com/Hummer12007/brightnessctl       │
#          ╰──────────────────────────────────────────────────────────╯
if command -v brightnessctl; then
  sudo usermod -aG video "$USER"
  sudo apt install brightnessctl
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                        strawberry                        │
#          │   https://github.com/strawberrymusicplayer/strawberry    │
#          ╰──────────────────────────────────────────────────────────╯
if command -v strawberry; then
  sudo apt install strawberry
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           feh                            │
#          │               https://github.com/derf/feh                │
#          ╰──────────────────────────────────────────────────────────╯
if command -v feh; then
  sudo apt install feh
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         mergiraf                         │
#          │          https://mergiraf.org/installation.html          │
#          ╰──────────────────────────────────────────────────────────╯
if command -v mergiraf; then
  curl -LO https://codeberg.org/mergiraf/mergiraf/releases/download/v0.6.0/mergiraf_x86_64-unknown-linux-gnu.tar.gz
  tar xzf mergiraf_x86_64-unknown-linux-gnu.tar.gz
  sudo mv mergiraf /usr/local/bin/
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           nmap                           │
#          │                https://svn.nmap.org/nmap/                │
#          ╰──────────────────────────────────────────────────────────╯
if command -v nmap; then
  sudo apt install nmap
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         thorium                          │
#          │          https://github.com/Alex313031/thorium           │
#          ╰──────────────────────────────────────────────────────────╯
# install dependencies
sudo apt install fonts-liberation libu2f-udev
# download
curl -LO "https://github.com/Alex313031/thorium/releases/latest/download/thorium-browser_130.0.6723.174_SSE4.deb"
sudo apt install ./thorium-browser_130.0.6723.174_SSE4.deb

#          ╭──────────────────────────────────────────────────────────╮
#          │                         openvpn                          │
#          │            https://github.com/OpenVPN/openvpn            │
#          ╰──────────────────────────────────────────────────────────╯
# usage: sudo openvpn <config>
if [ ! -x /sbin/openvpn ]; then
  sudo apt install openvpn
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                        wireguard                         │
#          │            https://www.wireguard.com/install/            │
#          ╰──────────────────────────────────────────────────────────╯
if command -v wg; then
  sudo apt install wireguard
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
if command -v plocate; then
  sudo apt install plocate
fi

#╭───────────────────────────────────────────────────────────────────────────────────────────────╮
#│                                         balena-etcher                                         │
#│https://github.com/balena-io/etcher#debian-and-ubuntu-based-package-repository-gnulinux-x86x64 │
#╰───────────────────────────────────────────────────────────────────────────────────────────────╯
if command -v balena-etcher; then
  curl -LO "https://github.com/balena-io/etcher/releases/latest/download/balena-etcher_2.1.0_amd64.deb"
  sudo apt install ./balena-etcher_2.1.0_amd64.deb
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         gparted                          │
#          │                   https://gparted.org/                   │
#          ╰──────────────────────────────────────────────────────────╯
# NOTE: for fat32
if command -v gparted; then
  sudo apt install dosfstools mtools
  sudo apt install gparted
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
if command -v zoom; then
  curl -LO https://zoom.us/client/6.4.0.471/zoom_amd64.deb
  sudo apt install ./zoom_amd64.deb
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                      keep-presence                       │
#          │        https://github.com/carrot69/keep-presence         │
#          ╰──────────────────────────────────────────────────────────╯
# for keeping computer awake during long-running processes
if command -v keep_presence; then
  python3 -m pip install keep_presence
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                       tidal-dl-ng                        │
#          │          https://github.com/exislow/tidal-dl-ng          │
#          ╰──────────────────────────────────────────────────────────╯
if command -v tidal-dl-ng; then
  pip install --upgrade tidal-dl-ng[gui]
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           cmus                           │
#          │               https://github.com/cmus/cmus               │
#          ╰──────────────────────────────────────────────────────────╯
if command -v cmus; then
  sudo apt install cmus
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          cmusfm                          │
#          │              https://github.com/Arkq/cmusfm              │
#          ╰──────────────────────────────────────────────────────────╯
if command -v cmusfm; then
  # install dependencies
  sudo apt install libcurl4-openssl-dev libnotify-dev
  # configure
  autoreconf --install
  mkdir build && cd build || exit
  ../configure --enable-libnotify
  # build & install
  make && make install
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
if command -v librewolf; then
  sudo extrepo enable librewolf
  sudo apt update && sudo apt install librewolf -y
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         mullvad                          │
#          │        https://mullvad.net/en/download/vpn/linux         │
#          ╰──────────────────────────────────────────────────────────╯
if command -v mullvad; then
  # TODO: Check if mullvad keyring is already installed, and listed as a repository

  # Download the Mullvad signing key
  sudo curl -fsSLo /usr/share/keyrings/mullvad-keyring.asc https://repository.mullvad.net/deb/mullvad-keyring.asc
  # Add the Mullvad repository server to apt
  echo "deb [signed-by=/usr/share/keyrings/mullvad-keyring.asc arch=$(dpkg --print-architecture)] https://repository.mullvad.net/deb/stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/mullvad.list
  # Install the package
  sudo apt update
  sudo apt install mullvad-vpn
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         foliate                          │
#          │         https://johnfactotum.github.io/foliate/          │
#          ╰──────────────────────────────────────────────────────────╯
if command -v foliate; then
  sudo apt install foliate
fi

# TODO: Only reboot if something in the system environment has changed as a result of code run in this file. Might be hard to determine/track this. Might be able to use a local variable to track when a change is made, that is worth rebooting for.
# reboot
