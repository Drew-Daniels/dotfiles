function nix-boot -d "Builds and bootes to latest NixOS Derivation"
    # Required to clear out previously deleted generations from boot menu
    command sudo nixos-rebuild boot --flake "$HOME/.config/nixos"
end
