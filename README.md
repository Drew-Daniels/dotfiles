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

## `Neovim`

- [ ] Set up default `eslint` and `prettierd` configs to be used when formatting one-off `.js` files that do not belong to a project with `eslint` installed, and an `eslint.config.mjs` in an adjacent directory
- [ ] Figure out how to install [norg-fmt](https://github.com/nvim-neorg/norg-fmt)
- [ ] Look into managing neovim configuration using one of these plugins:
  - [nixPatch.nvim](https://github.com/NicoElbers/nixPatch-nvim)
  - [nixCats](https://github.com/BirdeeHub/nixCats-nvim?tab=readme-ov-file#intro)
  - [nixvim](https://github.com/nix-community/nixvim)
  - [nvf](https://github.com/NotAShelf/nvf)

## `nix` and `NixOS`

- [ ] Migrate to [hyprland](https://wiki.hyprland.org/Nix/)
- [ ] Look into setting up a light/dark mode switcher configuration
  - Ex.) https://github.com/sahib/dotfiles/blob/master/bin/executable_toggle-dark-light.sh
- [ ] Declarative secure boot for NixOS: https://github.com/nix-community/lanzaboote
- [ ] NixOS Image builder: https://github.com/nix-community/nixos-generators
- [ ] Look into updating NixOS configuration to configure WiFi autoconnect using something like this: https://tasiaiso.vulpecula.zone/posts/nixos-wifi-agenix/
  - https://github.com/yaxitech/ragenix
  - NOTE: Could also look into using something like this: https://github.com/Mic92/sops-nix
  - OR: https://github.com/ryantm/agenix?tab=readme-ov-file#tutorial
- [ ] Look into using [impermanence](https://github.com/nix-community/impermanence)
- [ ] Look at migrating from `brew` as package manager on MacOS to `nix`:
  - https://github.com/nix-darwin/nix-darwin
  - https://juliu.is/tidying-your-home-with-nix/
- [ ] Look into configuring bluetooth on NixOS: https://nixos.wiki/wiki/Bluetooth
- [ ] Set up biometrics on NixOS:
  - https://discourse.nixos.org/t/plasma-6-on-nixos-is-missing-etc-pam-d-kde-fingerprint/42684
  - https://discourse.nixos.org/t/how-to-use-fingerprint-unlocking-how-to-set-

## Other

- [ ] Finish refactoring `~/.local/share/qutebrowser/userscripts/1pass.sh` script to work with current version of `op` and `wofi` instead of `rofi`
- [ ] Look into using [swayfx](https://github.com/WillPower3309/swayfx) as sway alternative
- [ ] Look into using a clipboard manager: https://wiki.hyprland.org/Useful-Utilities/Clipboard-Managers/
- [ ] Find a `gemini` client for Android
- [ ] Look into using [mumble](https://github.com/mumble-voip/mumble)
- [ ] Look into using [amfora](https://github.com/makew0rld/amfora?tab=readme-ov-file), a Gemini protocol client
  - Also [bombadillo](http://bombadillo.colorfield.space/)
  - https://geminiquickst.art/
- [ ] Look into self-hosting GitLab instance
- [ ] Update MacOS configurations to install [zulip-terminal](https://github.com/zulip/zulip-terminal) through pip (no existing homebrew package)
- [ ] Port over the rest of the newsboat urls I want to track
- [ ] Install [protonmail-bridge](https://search.nixos.org/packages?channel=24.11&show=protonmail-bridge&from=0&size=50&sort=relevance&type=packages&query=proton)
  - NOTE: Getting a weird keychain error when launching the app that causes it to crash
    up-fprintd-english/21901/2
- [ ] Install `raindrop.io` on NixOS
- [ ] Fix `standardnotes` installation on NixOS by doing something similar to: https://github.com/NixOS/nixpkgs/issues/278191#issuecomment-1910865477
- [ ] Look into creating mirrors for dotfiles
- [ ] Install `thorium` browser on NixOS - otherwise my sway config will generate errors in NixOS
- [ ] Update `swayrbar` content to display when connected to VPN
- [ ] Look into using [eww](https://github.com/elkowar/eww) for custom widgets
  - [ ] Or alternatively [astal](https://aylur.github.io/astal/guide/getting-started/introduction) and [AGS](https://aylur.github.io/ags/) for creating custom widgets
- [ ] Look into using [wikiman](https://github.com/filiparag/wikiman) for terminal viewing of arch docs
- [ ] Create tmp dirs to download files to when upgrading, rather than in this directory, to limit blast radius of potential mistakes
- [ ] [cava](https://github.com/karlstav/cava) audio-visualizer
- [ ] Look into just having one "install" and "upgrade" script that intalls/upgrades depending on environment state, rather than having to manage 2 different scripts as dependencies change
      -- Alacritty does not support them, Konsole does, but there's not a way to deactivate them in Konsole, so need to use a font without ligatures support to disable across all emulators
- Figure out how to _uninstall_ brew packages after they have been _removed_ from `./.chezmoidata/packages.yaml`
- Look into using [etckeeper](https://etckeeper.branchable.com/README/) to manage `/etc` files, since `chezmoi` cannot manage files outside of `~`
