function nix-switch -d "Builds and switches to latest NixOS Derivation"
    command sudo nixos-rebuild switch -I nixos-config=$HOME/.config/nixos/configuration.nix
end
