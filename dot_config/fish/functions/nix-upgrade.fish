function nix-upgrade -d "Upgrades NixOS"
    command sudo nixos-rebuild switch --upgrade -I nixos-config=$HOME/.config/nixos/configuration.nix
end
