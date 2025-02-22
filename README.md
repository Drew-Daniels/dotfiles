# Installation Process on a New Machine

## Setup GitHub Authentication

Create a [GitHub Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic)

[Use this token when cloning this repo](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#using-a-personal-access-token-on-the-command-line) instead of my GitHub password.

## Install Pre-Requisites for Running [`chezmoi`](https://www.chezmoi.io/):

### `MacOS`:

#### Install [`homebrew`](https://brew.sh/)

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```sh
brew install chezmoi
```

### `Arch`

```sh
pacman -S chezmoi
```

## Clone and Set Up Dotfiles using `chezmoi`

```bash
chezmoi init https://github.com/Drew-Daniels/dotfiles.git
```

## Install dependencies managed with [`homebrew-bundle`](https://github.com/Homebrew/homebrew-bundle)

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
make local
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

## Reboot
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

### `git-credential-oauth`
https://github.com/hickford/git-credential-oauth
https://tracker.debian.org/pkg/git-credential-oauth

```bash
sudo apt-get install git-credential-oauth
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
sudo apt-get install build-essentials libz-dev libff-dev libyaml-dev libssl-dev
# pre-reqs for mise
sudo apt update -y && sudo apt install -y gpg sudo wget curl
# mise installation
sudo install -dm 755 /etc/apt/keyrings
wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null
echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
sudo apt update
sudo apt install -y mise
```

### `ripgrep`
https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation


```bash
sudo apt-get install ripgrep
```

### `delta`
https://dandavison.github.io/delta/installation.html
https://github.com/dandavison/delta/releases

Install via `.deb` package listed under the latest release

### `starship`
https://starship.rs/guide/

```bash
curl -sS https://starship.rs/install.sh | sh
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
apt-get install fd-find
ln -s $(which fdfind) ~/.local/bin/fd
```

### `bat`
https://github.com/sharkdp/bat?tab=readme-ov-file#on-ubuntu-using-apt

```bash
sudo apt install bat
ln -s /usr/bin/batcat ~/.local/bin/bat
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

### `stylua`
https://github.com/JohnnyMorganz/StyLua

```bash
# by default, builds for lua 5.1
cargo install stylua
```

### `neovim`
https://github.com/neovim/neovim/blob/master/INSTALL.md#debian

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# yarn required by (?)
# tree-sitter-cli required by Swift LSP
npm i -g yarn tree-sitter-cli
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

### `jless`
https://jless.io/


```bash
cargo install jless
```

### `yazi`
https://yazi-rs.github.io/docs/installation/#debian

```bash
sudo apt install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick

cd ~/projects
git clone https://github.com/sxyazi/yazi.git
cd yazi
cargo build --release --locked
sudo mv target/release/yazi target/release/ya /usr/local/bin/
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

# post-build
sudo cp target/release/alacritty /usr/local/bin
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
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
https://docs.docker.com/desktop/setup/install/linux/debian/

```bash
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
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```
