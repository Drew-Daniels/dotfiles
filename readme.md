# Installation Process on a New Machine

## Setup GitHub Authentication & clone the repo

Create a [GitHub Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic)

[Use this token when cloning this repo](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#using-a-personal-access-token-on-the-command-line) instead of my GitHub password.

```bash
mkdir ~/projects
cd ~/projects
git clone https://github.com/Drew-Daniels/dotfiles.git
cd dotfiles

# Adds .gitignored files that will vary by machine, or contain secrets
# And sets up ~/.zshrc and ~/.gitconfig files to source configs from 'dotfiles'
./scripts/setup.sh
```

## Configure local environment

```bash
machine=work

sed -i -e "s/.*MACHINE*.*/MACHINE=$machine/" .env.local
```

## Restart terminal (to pick up changes to `~/.zshrc`)

## Install [`homebrew`](https://brew.sh/)

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install dependencies managed with [`homebrew-file`](https://github.com/rcmdnk/homebrew-file)

```bash
brew install rcmdnk/file/brew-file

brew file install
```

## Install [iTerm2](https://iterm2.com/)

Configure: `CMD+,` > General > Settings:

- Check `Load settings from custom folder or URL`
- Set path to `<absolute-path-to-home-folder>/projects/dotfiles/iterm2`
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

## Restart

```bash
sudo shutdown -r now
```
