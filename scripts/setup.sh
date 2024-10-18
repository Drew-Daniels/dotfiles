#!/usr/bin/env bash

local_mise_conf=~/.config/mise/config.local.toml

test -f $local_mise_conf || touch $local_mise_conf

# generate '.env.local' file to be manually configured
local_env_file_template=~/projects/dotfiles/.env.template
local_env_file=~/projects/dotfiles/.env.local

test -f $local_env_file || cp $local_env_file_template $local_env_file

# configure zsh
test -f ~/.zshrc || echo ". ~/projects/dotfiles/zsh/.zshrc" >~/.zshrc

# configure git
test -f ~/.gitconfig || cat ~/projects/dotfiles/git/.gitconfig.template >~/.gitconfig
