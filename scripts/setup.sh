#!/usr/bin/env bash

# generate blank 'secrets' file
secrets_file=~/projects/dotfiles/zsh/secrets

test -f $secrets_file || touch $secrets_file

# genereate '.env.local' file to be manually configured
local_env_file_template=~/projects/dotfiles/.env.template
local_env_file=~/projects/dotfiles/.env.local

test -f $local_env_file || cp $local_env_file_template $local_env_file

# configure /etc/shells
echo "source ~/projects/dotfiles/etc/shells" >/etc/shells

# configure zsh
test -f ~/.zshrc || echo ". ~/projects/dotfiles/zsh/.zshrc" >~/.zshrc

# configure git
test -f ~/.gitconfig || echo ". ~/projects/dotfiles/git/.gitconfig.template" >~/.gitconfig
