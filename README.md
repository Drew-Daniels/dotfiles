# Installation Process on a New Machine

## `MacOS` Workstation Setup Notes:

### User Setup

NOTE: Will need Administrator privileges to use `root` permission

#### App Store

Sign into the App Store using personal Apple account - since I'll need to be authenticated for `brew bundle` to download MAS apps

#### Download and Install Dotfiles

```zsh
/bin/zsh -c "$(curl -fsSL https://codeberg.org/drewdaniels/dotfiles/raw/branch/main/macos.sh)"
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

- [ ] Look into configuring some kind of volume equalizer - lack of this mostly apparent when using `cmus`:
  - https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture
- [ ] [cava](https://github.com/karlstav/cava) audio-visualizer
- [ ] Migrate to using [sway](https://github.com/swaywm/sway) from `i3`
  - [ ] Can migrate to using [bemenu](https://github.com/Cloudef/bemenu) instead of `dmenu` too, since the latter doesn't work with `wayland`
- [ ] Find a good screenshot tool for Debian: https://wiki.debian.org/ScreenShots
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
