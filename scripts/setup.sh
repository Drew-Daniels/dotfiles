#!/usr/bin/env bash

local_mise_conf=~/.config/mise/config.local.toml

test -f $local_mise_conf || touch $local_mise_conf

# generate '.env.local' file to be manually configured
local_env_file_template=~/projects/dotfiles/.env.template
local_env_file=~/projects/dotfiles/.env.local

cp $local_env_file_template $local_env_file

# configure zsh
echo ". ~/projects/dotfiles/zsh/.zshrc" >~/.zshrc

# configure git
cat ~/projects/dotfiles/git/.gitconfig.template >~/.gitconfig
