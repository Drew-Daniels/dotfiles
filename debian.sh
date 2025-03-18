#!/user/bin/env bash

# pre-flight
mkdir ~/projects

# TODO: Add logging to indicate overall progress
# TODO: Determine if the 'sudo' modifiers are necessary if running the entire script with 'sudo' prefix
# TODO: Build in checks to alert user if there is a newer version of a package hosted on github
#       Ex.) chezmoi, delta, or any other package downloaded from GitHub releases
# TODO: Figure out how to make this script idempotent
#   Uninstall unzipped directories when they're no longer necessary
#   rm *.deb files when no longer needed

# TODO: check if current user is a sudoer
# if not, indicate this is required an exit
# if so, continue
# TODO: Break up this script into a pre-install and install script so one can be used to add a user to sudoers file, and the other can be used to actually install all packages

# TODO: Make sure to jump back to ~ after cd'ing to specific directories
#          ╭──────────────────────────────────────────────────────────╮
#          │                          cosign                          │
#          │            https://github.com/sigstore/cosign            │
#          ╰──────────────────────────────────────────────────────────╯
curl -LO "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64"
sudo mv cosign-linux-amd64 /usr/local/bin/cosign
sudo chmod +x /usr/local/bin/cosign

#          ╭──────────────────────────────────────────────────────────╮
#          │                         chezmoi                          │
#          │                 https://www.chezmoi.io/                  │
#          ╰──────────────────────────────────────────────────────────╯
curl -LO https://github.com/twpayne/chezmoi/releases/download/v2.60.1/chezmoi_2.60.1_linux_amd64.deb

# Download the checksum file, checksum file signature, and public signing key:
curl --location --remote-name-all \
  https://github.com/twpayne/chezmoi/releases/download/v2.59.1/chezmoi_2.59.1_checksums.txt \
  https://github.com/twpayne/chezmoi/releases/download/v2.59.1/chezmoi_2.59.1_checksums.txt.sig \
  https://github.com/twpayne/chezmoi/releases/download/v2.59.1/chezmoi_cosign.pub

# verify the signature
cosign verify-blob --key=chezmoi_cosign.pub \
  --signature=chezmoi_2.59.1_checksums.txt.sig \
  chezmoi_2.59.1_checksums.txt

# verify the checksum matches
# TODO: Automate the check here
sha256sum --check chezmoi_2.59.1_checksums.txt --ignore-missing

# install chezmoi
sudo apt install ./chezmoi_2.60.1_linux_amd64.deb

# initialize dotfiles
# github
# chezmoi init https://github.com/Drew-Daniels/dotfiles.git --apply
# codeberg
chezmoi init https://codeberg.org/drewdaniels/dotfiles.git --apply

#          ╭──────────────────────────────────────────────────────────╮
#          │                          rustup                          │
#          │                    https://rustup.rs/                    │
#          ╰──────────────────────────────────────────────────────────╯
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# restart terminal

#          ╭──────────────────────────────────────────────────────────╮
#          │                           mise                           │
#          │                  https://mise.jdx.dev/                   │
#          ╰──────────────────────────────────────────────────────────╯
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

#        ╭──────────────────────────────────────────────────────────────╮
#        │                   ## 1Password Desktop App                   │
#        │https://support.1password.com/install-linux/#debian-or-ubuntu │
#        ╰──────────────────────────────────────────────────────────────╯
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

#          ╭──────────────────────────────────────────────────────────╮
#          │                      1Password CLI                       │
#          │  https://developer.1password.com/docs/cli/get-started/   │
#          ╰──────────────────────────────────────────────────────────╯
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

#          ╭──────────────────────────────────────────────────────────╮
#          │                   git-credential-oauth                   │
#          │     https://github.com/hickford/git-credential-oauth     │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt-get install git-credential-oauth

#    ╭──────────────────────────────────────────────────────────────────────╮
#    │                               ripgrep                                │
#    │https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation │
#    ╰──────────────────────────────────────────────────────────────────────╯
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
sudo apt install ./ripgrep_14.1.0-1_amd64.deb

# delta
# https://github.com/dandavison/delta/releases
curl -LO https://github.com/dandavison/delta/releases/download/0.18.2/delta-https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_amd64.deb

sudo apt install ./git-delta_0.18.2_amd64.deb

#╭──────────────────────────────────────────────────────────────────────────────────╮
#│                                     starship                                     │
#│https://github.com/starship/starship?tab=readme-ov-file#%F0%9F%9A%80-installation │
#╰──────────────────────────────────────────────────────────────────────────────────╯
cargo install starship --locked

#          ╭──────────────────────────────────────────────────────────╮
#          │                           fish                           │
#          │                  https://fishshell.com/                  │
#          ╰──────────────────────────────────────────────────────────╯
echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg >/dev/null
sudo apt update
sudo apt install fish

#          ╭──────────────────────────────────────────────────────────╮
#          │                           fzf                            │
#          │       https://junegunn.github.io/fzf/installation/       │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install fzf

#          ╭───────────────────────────────────────────────────────────╮
#          │                            fd                             │
#          │https://github.com/sharkdp/fd?tab=readme-ov-file#on-debian │
#          ╰───────────────────────────────────────────────────────────╯
mkdir p ~/.local/bin
sudo apt install fd-find
ln -s "$(which fdfind)" ~/.local/bin/fd

#    ╭──────────────────────────────────────────────────────────────────────╮
#    │                                 bat                                  │
#    │https://github.com/sharkdp/bat?tab=readme-ov-file#on-ubuntu-using-apt │
#    ╰──────────────────────────────────────────────────────────────────────╯
sudo apt install bat
ln -s /usr/bin/batcat ~/.local/bin/bat

#          ╭──────────────────────────────────────────────────────────╮
#          │                        bat-extras                        │
#          │     https://github.com/eth-p/bat-extras/tree/master      │
#          ╰──────────────────────────────────────────────────────────╯
cd ~/projects || exit
git clone https://github.com/eth-p/bat-extras.git
cd bat-extras || exit
./build.sh --install

#       ╭────────────────────────────────────────────────────────────────╮
#       │                             ctags                              │
#       │https://github.com/universal-ctags/ctags-nightly-build/releases │
#       ╰────────────────────────────────────────────────────────────────╯
curl -LO https://github.com/universal-ctags/ctags-nightly-build/releases/download/2025.03.17%2Bcff205ee0d66994f1e26e0b7e3c9c482c7595bbc/uctags-2025.03.17-linux-x86_64.deb

sudo apt install ./uctags-2025.03.17-linux-x86_64.deb

#╭──────────────────────────────────────────────────────────────────────────────╮
#│                                    awscli                                    │
#│https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html │
#╰──────────────────────────────────────────────────────────────────────────────╯

# NOTE: There is not currently a way to programmatically get the AWS public key, so have to install without
# verifying in programmic install
# https://github.com/aws/aws-cli/issues/6230
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#          ╭──────────────────────────────────────────────────────────╮
#          │                       wl-clipboard                       │
#          │         https://github.com/bugaevc/wl-clipboard          │
#          ╰──────────────────────────────────────────────────────────╯
# allows neovim to access clipboard via wayland
sudo apt install wl-clipboard

#          ╭──────────────────────────────────────────────────────────╮
#          │                         lua 5.1                          │
#          │        https://www.lua.org/manual/5.4/readme.html        │
#          ╰──────────────────────────────────────────────────────────╯
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

#          ╭──────────────────────────────────────────────────────────╮
#          │                         luarocks                         │
#          │                  https://luarocks.org/                   │
#          ╰──────────────────────────────────────────────────────────╯
wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
tar zxpf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1 || exit
./configure && make && sudo make install
sudo luarocks install luasocket

#          ╭──────────────────────────────────────────────────────────╮
#          │                 jetbrains-mono-nerd-font                 │
#          │            https://www.jetbrains.com/lp/mono/            │
#          ╰──────────────────────────────────────────────────────────╯
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip &&
  cd ~/.local/share/fonts &&
  unzip JetBrainsMono.zip &&
  rm JetBrainsMono.zip &&
  fc-cache -fv

#        ╭───────────────────────────────────────────────────────────────╮
#        │                            neovim                             │
#        │https://github.com/neovim/neovim/blob/master/INSTALL.md#debian │
#        ╰───────────────────────────────────────────────────────────────╯
# TODO: Figure out what requires 'yarn'
# tree-sitter-cli required by Swift LSP
npm i -g yarn tree-sitter-cli

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

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
sudo apt install tmux

#     ╭─────────────────────────────────────────────────────────────────────╮
#     │                             tmuxinator                              │
#     │https://github.com/tmuxinator/tmuxinator?tab=readme-ov-file#rubygems │
#     ╰─────────────────────────────────────────────────────────────────────╯

gem install tmuxinator

#        ╭──────────────────────────────────────────────────────────────╮
#        │                          alacritty                           │
#        │https://github.com/alacritty/alacritty/blob/master/INSTALL.md │
#        ╰──────────────────────────────────────────────────────────────╯
# NOTE: There are no precompiled binaries for linux. Need to build from source.
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

#          ╭──────────────────────────────────────────────────────────╮
#          │                            jq                            │
#          │               https://jqlang.org/download/               │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install jq

#          ╭──────────────────────────────────────────────────────────╮
#          │                       imagemagick                        │
#          │        https://github.com/ImageMagick/ImageMagick        │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install imagemagick

#          ╭──────────────────────────────────────────────────────────╮
#          │                          zoxide                          │
#          │          https://github.com/ajeetdsouza/zoxide           │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install zoxide

#          ╭──────────────────────────────────────────────────────────╮
#          │                           yazi                           │
#          │   https://yazi-rs.github.io/docs/installation/#crates    │
#          ╰──────────────────────────────────────────────────────────╯
# install deps
sudo apt install ffmpeg 7zip poppler-utils
# install yazi
cargo install --locked yazi-fm yazi-cli

#          ╭──────────────────────────────────────────────────────────╮
#          │                          jless                           │
#          │                    https://jless.io/                     │
#          ╰──────────────────────────────────────────────────────────╯
cargo install jless

#          ╭──────────────────────────────────────────────────────────╮
#          │                      standard notes                      │
#          │         https://standardnotes.com/download/linux         │
#          ╰──────────────────────────────────────────────────────────╯
curl -LO https://github.com/standardnotes/app/releases/download/%40standardnotes/desktop%403.195.25/standard-notes-3.195.25-linux-x86_64.AppImage

chmod a+x standard-notes-3.195.25-linux-x86_64.AppImage
mv standard-notes-3.195.25-linux-x86_64.AppImage /opt/standard_notes/standard_notes

#          ╭──────────────────────────────────────────────────────────╮
#          │                      docker desktop                      │
#          │   https://docs.docker.com/desktop/setup/install/linux/   │
#          ╰──────────────────────────────────────────────────────────╯
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

#          ╭──────────────────────────────────────────────────────────╮
#          │                      OpenSSH Server                      │
#          │                 https://www.openssh.com/                 │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install openssh-server

#          ╭──────────────────────────────────────────────────────────╮
#          │                          restic                          │
#          │             https://github.com/restic/restic             │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install restic

sudo restic generate --bash-completion /usr/share/bash-completion/completions/restic

# NOTE: fish completions are already stored in dotfiles

#          ╭──────────────────────────────────────────────────────────╮
#          │                      resticprofile                       │
#          │    https://github.com/creativeprojects/resticprofile     │
#          ╰──────────────────────────────────────────────────────────╯
curl -LO https://github.com/creativeprojects/resticprofile/releases/latest/download/resticprofile_0.29.1_linux_amd64.tar.gz
mkdir resticprofile_0.29.1_linux_amd64
tar -xzpf resticprofile_0.29.1_linux_amd64.tar.gz -C resticprofile_0.29.1_linux_amd64
sudo cp resticprofile_0.29.1_linux_amd64/resticprofile /usr/local/bin/
rm -rf restic*

#          ╭──────────────────────────────────────────────────────────╮
#          │                           dust                           │
#          │             https://github.com/bootandy/dust             │
#          ╰──────────────────────────────────────────────────────────╯
cargo install du-dust

#          ╭──────────────────────────────────────────────────────────╮
#          │                          kiwix                           │
#          │       https://tracker.debian.org/teams/kiwix-team/       │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install kiwix

#          ╭──────────────────────────────────────────────────────────╮
#          │                           rofi                           │
#          │            https://github.com/davatorium/rofi            │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install rofi

#          ╭──────────────────────────────────────────────────────────╮
#          │                      speedtest-cli                       │
#          │          https://github.com/sivel/speedtest-cli          │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install speedtest-cli

#          ╭──────────────────────────────────────────────────────────╮
#          │                       uuid-runtime                       │
#          │       https://packages.debian.org/sid/uuid-runtime       │
#          ╰──────────────────────────────────────────────────────────╯
# NOTE: For creating unique identifiers (like when working with S3)
sudo apt install uuid-runtime

#          ╭──────────────────────────────────────────────────────────╮
#          │                            i3                            │
#          │                 https://github.com/i3/i3                 │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install i3

#          ╭──────────────────────────────────────────────────────────╮
#          │                      brightnessctl                       │
#          │       https://github.com/Hummer12007/brightnessctl       │
#          ╰──────────────────────────────────────────────────────────╯
sudo usermod -aG video "$USER"
sudo apt install brightnessctl

#          ╭──────────────────────────────────────────────────────────╮
#          │                        strawberry                        │
#          │   https://github.com/strawberrymusicplayer/strawberry    │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install strawberry

#          ╭──────────────────────────────────────────────────────────╮
#          │                           feh                            │
#          │               https://github.com/derf/feh                │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install feh

#          ╭──────────────────────────────────────────────────────────╮
#          │                         mergiraf                         │
#          │          https://mergiraf.org/installation.html          │
#          ╰──────────────────────────────────────────────────────────╯
curl -LO https://codeberg.org/mergiraf/mergiraf/releases/download/v0.6.0/mergiraf_x86_64-unknown-linux-gnu.tar.gz
tar xzf mergiraf_x86_64-unknown-linux-gnu.tar.gz
sudo mv mergiraf /usr/local/bin/

#          ╭──────────────────────────────────────────────────────────╮
#          │                           nmap                           │
#          │                https://svn.nmap.org/nmap/                │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install nmap

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
sudo apt install openvpn
# installs into /usr/sbin so need to run as root
# usage: sudo openvpn <config>

#          ╭──────────────────────────────────────────────────────────╮
#          │                        wireguard                         │
#          │            https://www.wireguard.com/install/            │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install wireguard
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
sudo apt install plocate

#╭───────────────────────────────────────────────────────────────────────────────────────────────╮
#│                                         balena-etcher                                         │
#│https://github.com/balena-io/etcher#debian-and-ubuntu-based-package-repository-gnulinux-x86x64 │
#╰───────────────────────────────────────────────────────────────────────────────────────────────╯
curl -LO "https://github.com/balena-io/etcher/releases/latest/download/balena-etcher_2.1.0_amd64.deb"
sudo apt install ./balena-etcher_2.1.0_amd64.deb

#          ╭──────────────────────────────────────────────────────────╮
#          │                         gparted                          │
#          │                   https://gparted.org/                   │
#          ╰──────────────────────────────────────────────────────────╯
# NOTE: for fat32
sudo apt install dosfstools mtools

sudo apt install gparted

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
curl -LO https://zoom.us/client/6.4.0.471/zoom_amd64.deb
sudo apt install ./zoom_amd64.deb

#          ╭──────────────────────────────────────────────────────────╮
#          │                      keep-presence                       │
#          │        https://github.com/carrot69/keep-presence         │
#          ╰──────────────────────────────────────────────────────────╯
# for keeping computer awake during long-running processes
python3 -m pip install keep_presence

#          ╭──────────────────────────────────────────────────────────╮
#          │                       tidal-dl-ng                        │
#          │          https://github.com/exislow/tidal-dl-ng          │
#          ╰──────────────────────────────────────────────────────────╯
pip install --upgrade tidal-dl-ng[gui]

#          ╭──────────────────────────────────────────────────────────╮
#          │                           cmus                           │
#          │               https://github.com/cmus/cmus               │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install cmus

#          ╭──────────────────────────────────────────────────────────╮
#          │                          cmusfm                          │
#          │              https://github.com/Arkq/cmusfm              │
#          ╰──────────────────────────────────────────────────────────╯
# install dependencies
sudo apt install libcurl4-openssl-dev libnotify-dev
# configure
autoreconf --install
mkdir build && cd build || exit
../configure --enable-libnotify
# build & install
make && make install

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
sudo extrepo enable librewolf
sudo apt update && sudo apt install librewolf -y

#          ╭──────────────────────────────────────────────────────────╮
#          │                         mullvad                          │
#          │        https://mullvad.net/en/download/vpn/linux         │
#          ╰──────────────────────────────────────────────────────────╯
# Download the Mullvad signing key
sudo curl -fsSLo /usr/share/keyrings/mullvad-keyring.asc https://repository.mullvad.net/deb/mullvad-keyring.asc

# Add the Mullvad repository server to apt
echo "deb [signed-by=/usr/share/keyrings/mullvad-keyring.asc arch=$(dpkg --print-architecture)] https://repository.mullvad.net/deb/stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/mullvad.list

# Install the package
sudo apt update
sudo apt install mullvad-vpn

#          ╭──────────────────────────────────────────────────────────╮
#          │                         foliate                          │
#          │         https://johnfactotum.github.io/foliate/          │
#          ╰──────────────────────────────────────────────────────────╯
sudo apt install foliate
