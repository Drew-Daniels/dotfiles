function nix-boot --description "Builds and boots to latest NixOS Derivation"
    command sudo nixos-rebuild boot --flake "$HOME/.config/nixos"
end
