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

## Install dependencies managed with [`homebrew-bundle`](https://github.com/Homebrew/homebrew-bundle)

```bash
# Install global dependencies
brew bundle --global

# Install workstation-specific dependencies
brew bundle
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

## Install `luarocks` modules

```sh
# https://github.com/3rd/image.nvim
luarocks install --local magick
```

## Configuring `tmux`:

```bash
cd ~/projects/dotfiles

# clone tpm plugins. These are not included in the repo so they need to be cloned manually
git clone https://github.com/tmux-plugins/tpm.git tmux/plugins/tpm
git clone https://github.com/nordtheme/tmux.git tmux/plugins/tmux
# any others
```

Launch `tmux` and run `<PREFIX> + I` to reload the config

## Restart

```bash
sudo shutdown -r now
```

### TODO

- [ ] Look into using `homebrew-bundle` instead of `homebrew-file`
- [ ] Figure out how to get terminal hyperlinks working for custom nvim file protocol
- [ ] Look into using `fzf-lua` instead of `telescope`
- [ ] TUI LLMs:
  - https://github.com/pythops/tenere
  - https://github.com/jackMort/ChatGPT.nvim
