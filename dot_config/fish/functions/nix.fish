# NixOS helper functions

function nix-boot --description "Builds and bootes to latest NixOS Derivation"
    # Required to clear out previously deleted generations from boot menu
    command sudo nixos-rebuild boot --flake "$HOME/.config/nixos"
end

function nix-switch --description "Builds and switches to latest NixOS Derivation"
    # NOTE: Prefer --show-trace because this frequently fails after updating nixpkgs inputs
    # command sudo nixos-rebuild switch --flake "$HOME/.config/nixos"
    # NOTE: Use --show-trace to show more info around what packages cannot be built - if relevant
    command sudo nixos-rebuild switch --flake "$HOME/.config/nixos" --show-trace
end

function nix-update --description "Updates flake.lock"
    command nix flake update --flake "$HOME/.config/nixos"
end

function nix-upgrade --description "Builds and switches to latest NixOS Derivation using flakes"
    command sudo nixos-rebuild switch --flake "$HOME/.config/nixos" --upgrade
end
