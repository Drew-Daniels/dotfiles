function nix-update -d "Updates flake.lock"
    command nix flake update --flake "$HOME/.config/nixos"
end
