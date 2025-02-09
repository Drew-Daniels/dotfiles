#!/usr/bin/env bash

# TODO: Make this idempotent

dotfiles_dir=~/projects/dotfiles
mise_dir=$dotfiles_dir/mise

mkdir -p $mise_dir

mkdir ~/.config/mise
local_mise_conf=~/.config/mise/config.local.toml
cp $mise_dir/config.local.template.toml $local_mise_conf

# generate '.env.local' file to be manually configured
local_env_file_template=$dotfiles_dir/.env.template
local_env_file=$dotfiles_dir/.env.local

cp $local_env_file_template $local_env_file

# configure bash
echo ". $dotfiles_dir/bash/.bashrc" >~/.bashrc

# configure zsh
echo ". $dotfiles_dir/zsh/.zshrc" >~/.zshrc

# configure git
cat $dotfiles_dir/git/.gitconfig.template >~/.gitconfig
