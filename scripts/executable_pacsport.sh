#!/usr/bin/env bash

pacman -Qqe | "$HOME/scripts/txt_to_json.sh" | jq '.' >"$HOME/.local/share/chezmoi/.chezmoidata/archpackages.jsonc"
