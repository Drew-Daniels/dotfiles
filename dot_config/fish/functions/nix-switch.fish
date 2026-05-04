function nix-switch --description "Builds and switches to latest NixOS Derivation"
    command sudo nixos-rebuild switch --flake "$HOME/.config/nixos" --show-trace
end
