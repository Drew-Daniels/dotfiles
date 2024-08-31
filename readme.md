# Installation Process on a New Machine

## Setup GitHub Authentication & clone the repo:

Create a [GitHub Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic)

[Use this token when cloning this repo](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#using-a-personal-access-token-on-the-command-line) instead of my GitHub password.

```bash
mkdir ~/projects
cd ~/projects
git clone https://github.com/Drew-Daniels/dotfiles.git
cd dotfiles

# This won't exist, and when our zsh config is loaded the shell will throw an error without it
touch zsh/secrets
```

## Source `.zshrc` from `dotfiles`:

```bash
echo ". ~/projects/dotfiles/zsh/.zshrc" > ~/.zshrc
```

## Set `~/.gitconfig`:

```bash
cat ~/projects/dotfiles/git/.gitconfig.template > ~/.gitconfig
vim ~/.gitconfig
# Update email
```

## Configure [`mise`](https://mise.jdx.dev/getting-started.html#homebrew)

```bash
# Default npm packages
cat ~/projects/dotfiles/mise/.default-npm-packages > ~/.default-npm-packages

# Default ruby gems
cat ~/projects/dotfiles/mise/.default-gems > ~/.default-gems
```

## Install [`homebrew`](https://brew.sh/):

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install Dependencies:

Since `HOMEBREW_BUNDLE_FILE` is set in `dotfiles/zsh/.zshrc` and `dotfiles/fish/config.fish`, `homebrew-bundle` should use the `Brewfile` stored in `dotfiles/homebrew`.

```bash
brew bundle
```

## Install [iTerm2](https://iterm2.com/):

Configure: `CMD+,` > General > Settings:

- Check `Load settings from custom folder or URL`
- Set path to `<absolute-path-to-home-folder>/projects/dotfiles/iterm2`
- Set "Save Changes" option to "When Quitting"
