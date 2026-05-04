function nix-update --description "Updates flake.lock"
    command nix flake update --flake "$HOME/.config/nixos"
end
