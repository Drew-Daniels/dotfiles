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

## Configure local environment

## Install dependencies managed with [`homebrew-bundle`](https://github.com/Homebrew/homebrew-bundle)

```bash
brew bundle
```

## Install [iTerm2](https://iterm2.com/)

Configure: `CMD+,` > General > Settings:

- Check `Load settings from custom folder or URL`
- Set path to `~/.config/iterm2`
- Set "Save Changes" option to "When Quitting"

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
