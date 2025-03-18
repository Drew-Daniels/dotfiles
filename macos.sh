#!/user/bin/env bash

mkdir ~/projects
#          ╭──────────────────────────────────────────────────────────╮
#          │                         homebrew                         │
#          │                     https://brew.sh/                     │
#          ╰──────────────────────────────────────────────────────────╯
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#          ╭──────────────────────────────────────────────────────────╮
#          │                         chezmoi                          │
#          │                 https://www.chezmoi.io/                  │
#          ╰──────────────────────────────────────────────────────────╯
brew install chezmoi

# initialize dotfiles
# chezmoi init https://github.com/Drew-Daniels/dotfiles.git --apply
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
#          ╭──────────────────────────────────────────────────────────╮
#          │                         luarocks                         │
#          │                  https://luarocks.org/                   │
#          ╰──────────────────────────────────────────────────────────╯
wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
tar zxpf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1 || exit
./configure && make && sudo make install
sudo luarocks install luasocket

# install luarocks-managed modules
# https://github.com/3rd/image.nvim
luarocks install --local magick

# reboot
