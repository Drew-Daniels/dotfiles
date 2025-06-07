# GnuPG Notes for New Machine Setup

## Purpose

To document the process of copying my private GPG key to a new machine, using `ssh`.

## Terms

- `source` - machine that already has my private GPG key
- `target` - machine I want to transfer my GPG key to

## Verify private pgp key is on `source` machine

Should see a key listed with my name and personal email address.

```bash
gpg --list-secret-keys
```

## Ensure that `gpg-agent` service has loaded the latest configuration

NOTE: Helps avoid some weird scenarios where the `gpg-agent` can't find the `pinentry-program`, which is what's used to securely reveal GPG keys that are encrypted with passphrases.

```bash
gpgconf --reload gpg-agent
```

## Verify `gpg-agent` service is running on `source` machine

Also verify that I see logging that indicates the latest configuration has been loaded

```bash
systemctl --user status gpg-agent.service
```

## Determine `target` IP address

```bash
# get ipv4/ipv6 IP address of this machine on local network
# NOTE: I'll want to find the ipv4 address for next steps to work. ipv6 hasn't worked for me
hostname -i
# If ipv6 addr is displayed, find the corresponding ipv4 address
ifconfig
```

## Copy private gpg key ID on `source` machine

From the output, copy the ID (or fingerprint) of the gpg key to clipboard

```bash
gpg --list-secret-keys
```

## `scp` private gpg key from `source` to `target` machine

```bash
gpg --export-secret-key <KEY-ID> | ssh drew@<target-ipv4-address> gpg --import
```

## Verify `target` machine has actually imported the key

Should see my GPG key listed now

```bash
gpg --list-secret-keys
```

## Trust the imported private key

```bash
gpg --edit-key <KEY-ID>
```

Type `trust`, then enter `5` to give key ultimate trust
