# Installation Process on a New Machine

## Install Pre-Requisites for Running [`chezmoi`](https://www.chezmoi.io/):

### `MacOS` Workstation Setup Notes:

```bash
# bootstrap
sudo ./macos.sh
```

# Debian Workstation Setup Notes

## Resources

Helpful article on security & verifying packages: https://wiki.debian.org/SecureApt

## User Setup

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
