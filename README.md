# Installation Process on a New Machine

## Install Pre-Requisites for Running [`chezmoi`](https://www.chezmoi.io/):

### `MacOS`:

#### Install [`homebrew`](https://brew.sh/)

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```sh
brew install chezmoi
```

## Clone and Set Up Dotfiles using `chezmoi`

```bash
chezmoi init https://github.com/Drew-Daniels/dotfiles.git
```

Install `rustup`

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Install `mise`:

```bash
brew install mise
```

Install runtimes managed with `mise`:

```bash
mise install
```

Install other dependencies:

```bash
brew bundle
```

## Install [`lua 5.1`](https://www.lua.org/manual/5.4/readme.html)

```sh
curl -LO http://www.lua.org/ftp/lua-5.1.5.tar.gz
tar xvzf lua-5.1.5.tar.gz
cd lua-5.1.5
make macosx
make test
sudo make install
```

## Install [`luarocks`](https://luarocks.org/)

```sh
wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
tar zxpf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1
./configure && make && sudo make install
sudo luarocks install luasocket
```

## Install `luarocks` modules

```sh
# https://github.com/3rd/image.nvim
luarocks install --local magick
```

Reboot

# Debian Workstation Setup Notes

## Resources

Helpful article on security & verifying packages: https://wiki.debian.org/SecureApt

## User Setup

Add my non-root local user (drew) to sudoers file:

```bash
su
sudo adduser drew sudo
exit
```

Then, restart computer so it picks up these changes.

### Install `cosign`

```bash
curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64"
sudo mv cosign-linux-amd64 /usr/local/bin/cosign
sudo chmod +x /usr/local/bin/cosign
```

### Install `chezmoi`

Download the pre-built Debian package for `chezmoi`:

https://www.chezmoi.io/install/#one-line-binary-install

Download the checksum file, checksum file signature, and public signing key:

```bash
curl --location --remote-name-all \
       https://github.com/twpayne/chezmoi/releases/download/v2.59.1/chezmoi_2.59.1_checksums.txt \
       https://github.com/twpayne/chezmoi/releases/download/v2.59.1/chezmoi_2.59.1_checksums.txt.sig \
       https://github.com/twpayne/chezmoi/releases/download/v2.59.1/chezmoi_cosign.pub
```

Verify the signature

```bash
cosign verify-blob --key=chezmoi_cosign.pub \
                     --signature=chezmoi_2.59.1_checksums.txt.sig \
                     chezmoi_2.59.1_checksums.txt
```

Verify the shasum of downloaded Debian package:

```bash
sha256sum --check chezmoi_2.59.1_checksums.txt --ignore-missing
```

Install the `chezmoi` Debian package

### Initialize Dotfiles

Download a local copy of dotfiles, and apply changes from source to target:

```bash
chezmoi init https://github.com/Drew-Daniels/dotfiles.git --apply
```

### `rustup`

https://rustup.rs/

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# restart terminal
```

### `mise`

https://mise.jdx.dev/installing-mise.html#apt

```bash
# pre-reqs for building native C ruby extensions
sudo apt-get install build-essential libz-dev libffi-dev libyaml-dev libssl-dev
# pre-reqs for mise
sudo apt update -y && sudo apt install -y gpg sudo wget curl
# mise installation
sudo install -dm 755 /etc/apt/keyrings
wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null
echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
sudo apt update
sudo apt install -y mise
```

### `1Password`

https://support.1password.com/install-linux/#debian-or-ubuntu

`1Password Desktop App`:

```bash
# Add the key for the 1Password apt repository:
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

# Add the 1Password apt repository:
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list

# Add the debsig-verify policy
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
 curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
 sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
 curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

# Install 1Password
sudo apt update && sudo apt install 1password
```

### `1Password CLI`

https://developer.1password.com/docs/cli/get-started/

```bash
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
 curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
 sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
 curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
```

### `git-credential-oauth`

https://github.com/hickford/git-credential-oauth
https://tracker.debian.org/pkg/git-credential-oauth

```bash
sudo apt-get install git-credential-oauth
```

### `ripgrep`

https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation

```bash
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
sudo dpkg -i ripgrep_14.1.0-1_amd64.deb
```

### `delta`

https://dandavison.github.io/delta/installation.html
https://github.com/dandavison/delta/releases

Install via `.deb` package listed under the latest release

```bash
curl -LO https://github.com/dandavison/delta/releases/download/0.18.2/delta-https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_amd64.deb

sudo dpkg -i git-delta_0.18.2_amd64.deb
```

### `starship`

https://github.com/starship/starship?tab=readme-ov-file#%F0%9F%9A%80-installation

```bash
cargo install starship --locked
```

### `fish`

https://fishshell.com/

https://software.opensuse.org/download.html?project=shells%3Afish%3Arelease%3A3&package=fish

```bash
echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
sudo apt update
sudo apt install fish
```

### `fzf`

https://junegunn.github.io/fzf/installation/

```bash
sudo apt install fzf
```

### `fd`

https://github.com/sharkdp/fd?tab=readme-ov-file#on-debian

```bash
mkdir p ~/.local/bin
sudo apt install fd-find
ln -s $(which fdfind) ~/.local/bin/fd
```

### `bat`

https://github.com/sharkdp/bat?tab=readme-ov-file#on-ubuntu-using-apt

```bash
sudo apt install bat
ln -s /usr/bin/batcat ~/.local/bin/bat
```

### `bat-extras`

https://github.com/eth-p/bat-extras/tree/master

```bash
cd ~/projects
git clone https://github.com/eth-p/bat-extras.git
cd bat-extras
./build.sh --install
```

### `ctags`

https://github.com/universal-ctags/ctags-nightly-build/releases

Install `.deb` package under releases page

### `awscli`

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

Can run the following commands to install without verifying or, use the guided steps in the link.

#### Unverified Install

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### `wl-clipboard`

Allows `neovim` and other applications to access system clipboard.

```bash
sudo apt install wl-clipboard
```

### `lua 5.1`

https://www.lua.org/manual/5.4/readme.html
https://www.lua.org/ftp/

```bash
# required to build lua 5.1 from source
sudo apt-get install libreadline-dev

# download and unzip source folder
cd lua-5.1.5

# build
make linux

# verify
make test

# install
sudo make install
```

### `luarocks`

```bash
wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
tar zxpf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1
./configure && make && sudo make install
sudo luarocks install luasocket
```

### `jetbrains-mono-nerd-font`

```bash
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip \
&& fc-cache -fv
```

### `neovim`

https://github.com/neovim/neovim/blob/master/INSTALL.md#debian

```bash
# yarn required by (?)
# tree-sitter-cli required by Swift LSP
npm i -g yarn tree-sitter-cli

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
```

Post install:

```bash
nvim
# :MasonInstall ruff basedpyright clang-format jsonlint stlyua prettier nxls shfmt shellcheck sqlfmt reformat-gherkin yamlfmt
```

### `tmux`

https://github.com/tmux/tmux/wiki/Installing#binary-packages

```bash
sudo apt install tmux
```

### `tmuxinator`

https://github.com/tmuxinator/tmuxinator?tab=readme-ov-file#rubygems

```bash
gem install tmuxinator
```

### `alacritty`

https://github.com/alacritty/alacritty/blob/master/INSTALL.md

There are no precompiled binaries for linux. Need to build from source.

```bash
git clone https://github.com/alacritty/alacritty.git
cd alacritty
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
```

### `yazi`

https://yazi-rs.github.io/docs/installation/#crates

```bash
sudo apt install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick

cargo install --locked yazi-fm yazi-cli
```

### `jless`

https://jless.io/

```bash
cargo install jless
```

### Standard Notes

https://standardnotes.com/download/linux

Download the `.AppImage` file, and run the following commands

#### TODO:

Look at creating a `.desktop` file to be able to easily open Standard Notes using the quick access menu on KDE.

```bash
chmod a+x standard-notes-3.195.25-linux-x86_64.AppImage
mv standard-notes-3.195.25-linux-x86_64.AppImage ~/Applications/

# run
~/Applications/standard-notes-3.195.25-linux-x86_64.AppImage
```

### `Docker Desktop`

https://docs.docker.com/desktop/setup/install/linux/

Might need to also run this command, if I get the "Docker can't conecto to Docker Daemon" error message:

https://stackoverflow.com/a/73564032/13175926

```bash
docker context use default
```

### `openssh-server`

```bash
sudo apt install openssh-server
```

### `restic`

```bash
sudo apt install restic

sudo restic generate --bash-completion /usr/share/bash-completion/completions/restic

# fish completions are already stored in dotfiles
```

### `resticprofile`

```bash
curl -LO https://github.com/creativeprojects/resticprofile/releases/latest/download/resticprofile_0.29.1_linux_amd64.tar.gz

mkdir resticprofile_0.29.1_linux_amd64

tar -xzpf resticprofile_0.29.1_linux_amd64.tar.gz -C resticprofile_0.29.1_linux_amd64

sudo cp resticprofile_0.29.1_linux_amd64/resticprofile /usr/local/bin/

rm -rf restic*
```

### `dust`

```bash
cargo install du-dust
```

### `kiwix`

```bash
sudo apt install kiwix
```

### `rofi`

Ensure that whatever commands are attached to keybinds attach the `-normal-window` flag:

https://github.com/swaywm/sway/issues/267

```bash
sudo apt install rofi
```

### `speedtest-cli`

```bash
sudo apt install speedtest-cli
```

### `uuid-runtime`

For creating unique identifiers (like when working with S3)

```bash
sudo apt install uuid-runtime
```

### `i3`

```bash
sudo apt install i3
```

### `brightnessctl`

```bash
# TODO: Is this necessary?
sudo usermod -aG video $USER

sudo apt install brightnessctl
```

### `strawberry`

```bash
sudo apt install strawberry
```

### `feh`

```bash
sudo apt install feh
```

### `nmap`

```bash
sudo apt install nmap
```

### `thorium`

```bash
# NOTE: update to the latest release, if necessary
curl -O -L "https://github.com/Alex313031/thorium/releases/latest/download/thorium-browser_130.0.6723.174_SSE4.deb"

# install deps
sudo apt install fonts-liberation libu2f-udev

# install
sudo dpkg -i thorium-browser_130.0.6723.174_SSE4.deb
```

### `openvpn3`

https://community.openvpn.net/openvpn/wiki/OpenVPN3Linux

```bash
sudo apt install apt-transport-https

# switch to root
su

# enter root pwd
curl -sSfL https://packages.openvpn.net/packages-repo.gpg >/etc/apt/keyrings/openvpn.asc

echo "deb [signed-by=/etc/apt/keyrings/openvpn.asc] https://packages.openvpn.net/openvpn3/debian bookworm main" >>/etc/apt/sources.list.d/openvpn3.list

sudo apt update

sudo apt install openvpn3
```

### `wireguard`

```bash
sudo apt install wireguard

# Create and download client configuration file from Wireguard server

# move into wireguard configuration folder
sudo mv client.conf /etc/wireguard/wg0.conf

# import the client profile
sudo nmcli connection import type wireguard file "/etc/wireguard/wg0.conf"

# to stop the connection
nmcli connection stop wg0

# to start again
nmcli connection start wg0
```
