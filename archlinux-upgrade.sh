#!/usr/bin/env bash

# https://wiki.archlinux.org/title/System_maintenance#Upgrading_the_system
# TODO: Install one of the pacman hooks below so I get warned before upgrading packages that may need manual review
# informantAUR, newscheckAUR or arch-manwarnA
sudo pacman -Syu
