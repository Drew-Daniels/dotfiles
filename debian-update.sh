#!/usr/bin/env bash

# Updates packages that have to be manually updated outside of 'apt'
# TODO: Add check to see if there is a later version available, and only install if it is differerent version from current install
# TODO: Suppress curl output
# TODO: Perform installation steps in a /tmp folder
#╭──────────────────────────────────────────────────────────────────────────────╮
#│                                    awscli                                    │
#│https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html │
#╰──────────────────────────────────────────────────────────────────────────────╯
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

# cleanup
rm awscliv2.zip
rm -rf aws

#          ╭──────────────────────────────────────────────────────────╮
#          │                          rustup                          │
#          │                    https://rustup.rs/                    │
#          ╰──────────────────────────────────────────────────────────╯
rustup update
#    ╭──────────────────────────────────────────────────────────────────────╮
#    │                               ripgrep                                │
#    │https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation │
#    ╰──────────────────────────────────────────────────────────────────────╯
# TODO: ripgrep

#          ╭──────────────────────────────────────────────────────────╮
#          │                          delta                           │
#          │       https://github.com/dandavison/delta/releases       │
#          ╰──────────────────────────────────────────────────────────╯
# TODO: git-delta

#       ╭────────────────────────────────────────────────────────────────╮
#       │                             ctags                              │
#       │https://github.com/universal-ctags/ctags-nightly-build/releases │
#       ╰────────────────────────────────────────────────────────────────╯
# TODO: universal-ctags

#          ╭──────────────────────────────────────────────────────────╮
#          │                         thorium                          │
#          │          https://github.com/Alex313031/thorium           │
#          ╰──────────────────────────────────────────────────────────╯
# TODO: thorium-browser

#╭───────────────────────────────────────────────────────────────────────────────────────────────╮
#│                                         balena-etcher                                         │
#│https://github.com/balena-io/etcher#debian-and-ubuntu-based-package-repository-gnulinux-x86x64 │
#╰───────────────────────────────────────────────────────────────────────────────────────────────╯
# TODO: balena-etcher

#          ╭──────────────────────────────────────────────────────────╮
#          │                           zoom                           │
#          │            https://zoom.us/download?os=linux             │
#          ╰──────────────────────────────────────────────────────────╯
# TODO: zoom
