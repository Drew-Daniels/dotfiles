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
# chezmoi init https://codeberg.org/drewdaniels/dotfiles.git --apply
chezmoi init https://github.com/Drew-Daniels/dotfiles --apply
```

NOTE: I stopped using Codeberg to host my dotfiles because of this issue, where lockfiles can get stuck in a broken state, and there isn't a way to remove these in an automated way. The only way to fix them is to contact Codeberg admin to clear the lock on the remote.

https://codeberg.org/Codeberg/Community/issues/1474
https://codeberg.org/forgejo/forgejo/issues/1946

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
