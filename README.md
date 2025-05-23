# Installation Process on a New Machine

## `MacOS` Workstation Setup Notes:

### User Setup

NOTE: Will need Administrator privileges to use `root` permission

#### App Store

Sign into the App Store using personal Apple account - since I'll need to be authenticated for `brew bundle` to download MAS apps

#### Download and Install Dotfiles

##### Process Notes

- Installs `chezmoi` binary
- Clones dotfiles into `~/.local/share/chezmoi`
- Runs `read-source-state.pre` hook, which:
  - Creates expected directories (`~/projects` and `/usr/local/bin`)
  - Clones local repositories (`jg`, `friendly-snippets`, ...)
  - Installs `brew` (only on MacOS) and adds it to `PATH`
- Runs scripts:
  - `run_once_01-install-primary-deps.sh` - Installs the most important dependencies, that should be installed before anything else, since unnecessary deps can be installed if these are installed along with everything else (`mise`, `lua v5.1.5`, etc.)
  - `run_once_02-install-secondary-deps.sh` - Installs the rest of the dependencies managed with `brew`/`apt` respectively
  - `run_once_03-install-secrets.sh` - Uses `op` to export secrets to `~/.env`
  - NOTE: The numerical values are used so that these run in an expected order. That is, `chezmoi` runs scripts in alphabetical order.
- Reads source state, target state, and begins applying changes to target
- After `apply` completes, runs the `apply.post` hook which removes the `chezmoi` binary installed into `/usr/local/bin` (MacOS only)

##### Command

```zsh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
chezmoi init https://codeberg.org/drewdaniels/dotfiles.git --apply
```

#### `iterm2` Configuration

Open `iterm2`, open Settings > General > Settings and under `External settings`, load settings from configuration path (Ex., /Users/drew/.config/iterm2) and reload.

#### `strawberry` Music Player

Install MacOS Distribution: https://www.patreon.com/c/jonaskvinge/posts

#### `age` encryption

```bash
age-keygen -o $HOME/key.txt
# copy public key, and add it as an entry to `recipients` key in ~/.local/share/chezmoi/.chezmoi.toml.tmpl
```

#### `rcmd` Configuration

Open `rcmd` in menu bar and navigate to Settings > Import JSON > `~/.config/rcmd/settings.json`

#### `XCode` Configuration

Open `XCode` and:

- Accept Terms
- Install tooling for MacOS and iOS

#### `mongodb` Configuration:

Optionally:

```bash
brew services start mongodb/brew/mongodb-community
```

#### `apache` Configuration

```bash
brew install httpd
```

Optionally:

```bash
# to start
apachectl start

# to stop
apachectl stop
```

#### `PHP` Configuration

```bash
brew services start php
```

```bash
cat << EOF >> /opt/homebrew/etc/httpd/httpd.conf
### CUSTOM BEGIN ###
LoadModule php_module /opt/homebrew/opt/php/lib/httpd/modules/libphp.so

<FilesMatch \.php$>
  SetHandler application/x-httpd-php
</FilesMatch>
### CUSTOM END ###
EOF
```

Edit this line:

```bash
# from
<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>

# to
<IfModule dir_module>
    DirectoryIndex index.php index.html
</IfModule>
```

## Debian Workstation Setup Notes

### User Setup

During desktop setup, specify a `root` user password.

After logging in, add my non-root local user (E.g., `drew`) to `/etc/sudoers` file:

```bash
su
# <Enter 'root' user password>
adduser drew sudo
exit

# Restart computer so it picks up these changes.
systemctl reboot
```

Download and install dotfiles, and all dev environment dependencies:

```bash
/bin/bash -c "$(curl -fsSL https://codeberg.org/drewdaniels/dotfiles/raw/branch/main/debian-install.sh)"

systemctl reboot
```

### Maintenance

Some packages have to be manually updated outside of package managers like, `apt`. To update them run:

```bash
chezmoi cd
./.debian-upgrade.sh
```

## `NixOS` Workstation Setup Notes

```bash
curl --silent --location --remote-name-all \
    https://channels.nixos.org/nixos-24.11/latest-nixos-plasma6-x86_64-linux.iso.sha256 \
    https://channels.nixos.org/nixos-24.11/latest-nixos-plasma6-x86_64-linux.iso
```

# Roadmap

QOL Updates:

- [ ] Look at migrating from `brew` as package manager on MacOS to `nix`:
  - https://github.com/nix-darwin/nix-darwin
- [ ] Look into configuring bluetooth on NixOS: https://nixos.wiki/wiki/Bluetooth
- [ ] Look into managing neovim configuration using one of these plugins:
  - [nixCats](https://github.com/BirdeeHub/nixCats-nvim?tab=readme-ov-file#intro)
  - [nixvim](https://github.com/nix-community/nixvim)
  - [nvf](https://github.com/NotAShelf/nvf)
- [ ] Figure out how to get dark theme used on Strawberry when in `sway` (works on plasma)
- [ ] Update MacOS configurations to install [zulip-terminal](https://github.com/zulip/zulip-terminal) through pip (no existing homebrew package)
- [ ] Port over the rest of the newsboat urls I want to track
- [ ] Install [protonmail-bridge](https://search.nixos.org/packages?channel=24.11&show=protonmail-bridge&from=0&size=50&sort=relevance&type=packages&query=proton)
  - NOTE: Getting a weird keychain error when launching the app that causes it to crash
- [ ] Set up biometrics on NixOS:
  - https://discourse.nixos.org/t/plasma-6-on-nixos-is-missing-etc-pam-d-kde-fingerprint/42684
  - https://discourse.nixos.org/t/how-to-use-fingerprint-unlocking-how-to-set-up-fprintd-english/21901/2
- [ ] Install `raindrop.io` on NixOS
- [ ] Fix `standardnotes` installation on NixOS by doing something similar to: https://github.com/NixOS/nixpkgs/issues/278191#issuecomment-1910865477
- [ ] Look into creating mirrors for dotfiles
- [ ] Desktop weather app/widget for linux
- [ ] Figure out cause of internet connectivity issue when using `sway` wm in NixOS - guessing that I'm relying on something from KDE desktop to handle automatically connecting to the wifi
- [ ] Install `thorium` browser on NixOS - otherwise my sway config will generate errors in NixOS
- [ ] Fix background image issue when using `sway` in `NixOS` - think the default background image isn't getting installed because home manager isn't creating the default system configuration for sway
- [ ] Modify `nvim-lspconfig` such that the `config` function adjust the configuration used so that it uses the old Neovim v0.10 format instead of the v0.11 format
- [ ] Think through Mason configuration on NixOS and reconfigure so that nvim-lspconfig uses language servers installed using nix package manager instead of packages installed via mason
- [ ] Add `vim.lsp.enable(..)` for every language server I have installed, so language servers get launched in NixOS
  - May also need to adjust configurations for `mason-lspconfig` and `mason-tool-installer`
- [ ] Add handling in dotfiles configuration for linux distros other than Debian (NixOS and Arch)
- [ ] Update `swayrbar` content to display when connected to VPN
- [ ] Look into using [eww](https://github.com/elkowar/eww) for custom widgets
- [ ] Look into using [wikiman](https://github.com/filiparag/wikiman) for terminal viewing of arch docs
- [ ] Look into configuring `swaylock` to automatically be called upon lid close
- [ ] Look into creating a hook that pulls in updates to cloned repositories before applying changes (such as changes made to friendly-snippets fork)
- [ ] Create tmp dirs to download files to when upgrading, rather than in this directory, to limit blast radius of potential mistakes
- [ ] Look into configuring some kind of volume equalizer - lack of this mostly apparent when using `cmus`:
  - https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture
- [ ] [cava](https://github.com/karlstav/cava) audio-visualizer
  - [ ] Can migrate to using [bemenu](https://github.com/Cloudef/bemenu) instead of `dmenu` too, since the latter doesn't work with `wayland`
- [ ] Find a good screenshot tool for Debian: https://wiki.debian.org/ScreenShots
  - https://gist.github.com/anpang54/ae723b0d38eb89b551854e79d4c16ed0
- [ ] Create base template setup script for creating common directories used on both MacOS and linux
- [ ] Look into just having one "install" and "upgrade" script that intalls/upgrades depending on environment state, rather than having to manage 2 different scripts as dependencies change
- [ ] Switch to using "no ligatures" nerd font: https://github.com/JetBrains/JetBrainsMono/releases/tag/v1.0.4
      -- Alacritty does not support them, Konsole does, but there's not a way to deactivate them in Konsole, so need to use a font without ligatures support to disable across all emulators
- [ ] Look into making `debian-upgrade.sh` script globally available
- Create a post-install script that automatically:
  - Exports shared secrets that are used across all computers (like Home DDNS hostname) to `~/.env`
  - Look into using an `run_after*` script so that it runs after all dependencies are installed
- Figure out how to _uninstall_ brew packages after they have been _removed_ from `./.chezmoidata/packages.yaml`
- Look into using something like this to handle initial dotfiles setup instead of requiring `./macos.sh` to be run:
  - https://www.chezmoi.io/user-guide/advanced/install-your-password-manager-on-init/
  - https://www.chezmoi.io/reference/configuration-file/hooks/
- Look into using [etckeeper](https://etckeeper.branchable.com/README/) to manage `/etc` files, since `chezmoi` cannot manage files outside of `~`
