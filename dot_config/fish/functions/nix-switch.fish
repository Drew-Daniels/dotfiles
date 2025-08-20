function nix-switch -d "Builds and switches to latest NixOS Derivation"
    command sudo nixos-rebuild switch --flake "$HOME/.config/nixos"
    # NOTE: Use --show-trace to show more info around what packages cannot be built - if relevant
    # command sudo nixos-rebuild switch --flake "$HOME/.config/nixos" --show-trace
end
