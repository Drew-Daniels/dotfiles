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

```bash
cd ~/.local/share/chezmoi
# bootstrap
./debian.sh
```
