function nix-upgrade -d "Builds and switches to latest NixOS Derivation using flakes"
    command sudo nixos-rebuild switch --flake "$HOME/.config/nixos" --upgrade
end
