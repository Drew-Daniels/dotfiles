#!/usr/bin/env bash

mkdir -p ~/projects

git clone https://github.com/Drew-Daniels/friendly-snippets.git ~/projects/friendly-snippets

sudo mkdir -p /usr/local/bin

#          ╭──────────────────────────────────────────────────────────╮
#          │                         homebrew                         │
#          │                     https://brew.sh/                     │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v brew >/dev/null 2>&1; then
	echo "Installing homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo "Installed homebrew"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         chezmoi                          │
#          │                 https://www.chezmoi.io/                  │
#          ╰──────────────────────────────────────────────────────────╯
# TODO: Build from source for bettery security, or verify
if ! command -v chezmoi >/dev/null 2>&1; then
	sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
	# initialize dotfiles
	# chezmoi init https://github.com/Drew-Daniels/dotfiles.git --apply
	chezmoi init https://codeberg.org/drewdaniels/dotfiles.git --apply
  # Remove after cloning dotfiles, since chezmoi should ideally be managed via homebrew for easier updates
  sudo rm /usr/local/bin/chezmoi
fi

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
brew install mise

# install mise-managed runtimes
mise install

# install other homebrew-managed deps
brew bundle

#          ╭──────────────────────────────────────────────────────────╮
#          │                         lua 5.1                          │
#          │        https://www.lua.org/manual/5.4/readme.html        │
#          ╰──────────────────────────────────────────────────────────╯
# download
curl -LO http://www.lua.org/ftp/lua-5.1.5.tar.gz
# unpack
tar xvzf lua-5.1.5.tar.gz
cd lua-5.1.5 || exit
# build
make macosx
# verify
make test
# install
sudo make install

# cleanup
rm -rf lua-5.1.5*

#          ╭──────────────────────────────────────────────────────────╮
#          │                         luarocks                         │
#          │                  https://luarocks.org/                   │
#          ╰──────────────────────────────────────────────────────────╯
curl -LO https://luarocks.org/releases/luarocks-3.11.1.tar.gz
tar zxpf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1 || exit
./configure && make && sudo make install
sudo luarocks install luasocket

# install luarocks-managed modules
# https://github.com/3rd/image.nvim
luarocks install --local magick

# reboot
# TODO: Figure out why this fails
shutdown -r
