#!/bin/zsh

mkdir -p ~/projects
mkdir -p /usr/local/bin

if [ ! -d ~/projects/friendly-snippets ]; then
  git clone https://github.com/Drew-Daniels/friendly-snippets.git ~/projects/friendly-snippets
fi

if [ ! -d ~/projects/work_notes ]; then
  git clone https://github.com/Drew-Daniels/work_notes.git ~/projects/work_notes
fi

if [ ! -d ~/projects/jg ]; then
  git clone https://codeberg.org/drewdaniels/jg.git ~/projects/jg
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         homebrew                         │
#          │                     https://brew.sh/                     │
#          ╰──────────────────────────────────────────────────────────╯
# NOTE: Need to use the full path here because 'brew' won't be on PATH until dotfiles are installed
if ! command -v /opt/homebrew/bin/brew >/dev/null 2>&1; then
	echo "Installing homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo "Installed homebrew"
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                   git-credential-oauth                   │
#          │     https://github.com/hickford/git-credential-oauth     │
#          ╰──────────────────────────────────────────────────────────╯
# NOTE: May need to install git-credential-oauth before trying to install dotfiles since this is how we'll authenticate with remote repo prior to cloning
# /opt/homebrew/bin/brew git-credential-oauth
#
# cat << EOF > ~/.gitconfig
# [credential]
# 	helper = cache --timeout 21600 # 6 hours
# 	helper = oauth
# EOF

#          ╭──────────────────────────────────────────────────────────╮
#          │                         chezmoi                          │
#          │                 https://www.chezmoi.io/                  │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v chezmoi >/dev/null 2>&1; then
	sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
	# initialize dotfiles
	# chezmoi init https://github.com/Drew-Daniels/dotfiles.git --apply
	chezmoi init https://codeberg.org/drewdaniels/dotfiles.git --apply
  # Remove after cloning dotfiles, since chezmoi should ideally be managed via homebrew for easier updates
  rm /usr/local/bin/chezmoi
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          rustup                          │
#          │                    https://rustup.rs/                    │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v rustup >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                           mise                           │
#          │                  https://mise.jdx.dev/                   │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v mise >/dev/null 2>&1; then
  brew install mise
fi

mise install

#          ╭──────────────────────────────────────────────────────────╮
#          │                         lua 5.1                          │
#          │        https://www.lua.org/manual/5.4/readme.html        │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v lua >/dev/null 2>&1; then
  curl -LO http://www.lua.org/ftp/lua-5.1.5.tar.gz
  tar xvzf lua-5.1.5.tar.gz

  cd lua-5.1.5 || exit

  make macosx
  make test
  make install

  rm -rf lua-5.1.5*
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                         luarocks                         │
#          │                  https://luarocks.org/                   │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v luarocks >/dev/null 2>&1; then
  curl -LO https://luarocks.org/releases/luarocks-3.11.1.tar.gz
  tar zxpf luarocks-3.11.1.tar.gz
  cd luarocks-3.11.1 || exit
  ./configure && make && make install
  luarocks install luasocket

  # install luarocks-managed modules
  # https://github.com/3rd/image.nvim
  luarocks install --local magick
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                          nodejs                          │
#          │            https://github.com/nodejs/corepack            │
#          ╰──────────────────────────────────────────────────────────╯
if ! command -v yarn >/dev/null 2>&1; then
  corepack enable yarn
fi

if ! command -v pnpm >/dev/null 2>&1; then
  corepack enable pnpm
fi

#          ╭──────────────────────────────────────────────────────────╮
#          │                       Postgres.app                       │
#          │                 https://postgresapp.com/                 │
#          ╰──────────────────────────────────────────────────────────╯
sudo mkdir -p /etc/paths.d && 
  echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp

# reboot
shutdown -r now
