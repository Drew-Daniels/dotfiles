# Installation Process on a New Machine

## Setup GitHub Authentication & clone the repo

Create a [GitHub Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic)

[Use this token when cloning this repo](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#using-a-personal-access-token-on-the-command-line) instead of my GitHub password.

```bash
mkdir ~/projects
cd ~/projects
git clone https://github.com/Drew-Daniels/dotfiles.git
cd dotfiles

# Adds .gitignored files that will vary by machine
# Sets up ~/.zshrc and ~/.gitconfig files to source configs from 'dotfiles'
./scripts/setup.sh
```

## Configure local environment

```bash
email=drew.daniels@somecompany.com

sed -i -e "s/.*EMAIL*.*/EMAIL=$email/" .env.local
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

## Install [`awscli`](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

NOTE: Do not install via `homebrew` because this installs dependencies like `python` that aren't managed by `mise`.

## Install [`lua 5.1`](https://gist.github.com/ivan-loh/9f81b6f44c42f4115964)

## Install [`luarocks`](https://luarocks.org/)

## [`spotify_player`](https://github.com/aome510/spotify-player)

### Install `spotify_player`

```sh
cargo install spotify_player --features lyric-finder,image,fzf
```

### Configure [`librespot-auth`](https://github.com/dspearson/librespot-auth)

https://github.com/aome510/spotify-player/issues/520#issuecomment-2296842298

## Restart

```bash
sudo shutdown -r now
```
