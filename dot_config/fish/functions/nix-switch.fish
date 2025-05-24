function nix-switch -d "Builds and switches to latest NixOS Derivation"
    command sudo nixos-rebuild switch --flake "$HOME/.config/nixos"
end
