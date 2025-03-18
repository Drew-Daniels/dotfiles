# Installation Process on a New Machine

## `MacOS` Workstation Setup Notes:

### User Setup

NOTE: Will need Administrator privileges to use `root` permission

```bash
cd ~/.local/share/chezmoi
# bootstrap
sudo ./macos.sh
```

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
sudo ./debian.sh
```
