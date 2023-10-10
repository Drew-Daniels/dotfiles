#!/bin/bash

# This script is used to delete all `nvim-treesitter` parsers
# The 'ensure_installed' option enforces that parsers are installed when neovim starts up
# However, since I have to use Rosetta for some runtimes, these parsers get installed for the wrong architecture
# x84_64 vs arm64
# So when I actually try to use these parsers in neovim I get an error saying that I've installed these parsers using the wrong architecture.

parsers_glob=~/.local/share/nvim/lazy/nvim-treesitter/parser/*.so

echo "Deleting all 'nvim-treesitter' parsers"

rm -r -v $parsers_glob

echo "Deleted all 'nvim-treesitter' parsers"

