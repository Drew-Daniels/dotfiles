# Installation Process on a New Machine

## `MacOS` Workstation Setup Notes:

### User Setup

NOTE: Will need Administrator privileges to use `root` permission

```zsh
sudo /bin/zsh -c "$(curl -fsSL https://codeberg.org/drewdaniels/dotfiles.git)"
```

#### `iterm2` Configuration

Open `iterm2`, open Settings > General > Settings and under `External settings`, load settings from configuration path (Ex., /Users/drew/.config/iterm2) and reload.

#### `strawberry` Music Player

Install MacOS Distribution: https://www.patreon.com/c/jonaskvinge/posts

## Debian Workstation Setup Notes

### User Setup

Add my non-root local user (drew) to sudoers file:

```bash
su
sudo adduser drew sudo
exit
```

Then, restart computer so it picks up these changes.

```bash
cd ~/.local/share/chezmoi
# bootstrap
sudo ./debian-install.sh
```

### Maintenance

Some packages have to be manually updated outside of package managers like, `apt`. To update them run:

```bash
sudo ./debian-update.sh
```

## `NixOS` Workstation Setup Notes

```bash
curl --silent --location --remote-name-all \
    https://channels.nixos.org/nixos-24.11/latest-nixos-plasma6-x86_64-linux.iso.sha256 \
    https://channels.nixos.org/nixos-24.11/latest-nixos-plasma6-x86_64-linux.iso
```
