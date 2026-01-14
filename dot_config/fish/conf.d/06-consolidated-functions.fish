# Load consolidated function files
# These files contain multiple related functions grouped together

if status is-interactive
    # Load bluetooth functions (btconnect, btdisconnect)
    source $__fish_config_dir/functions/bluetooth.fish

    # Load nix functions (nix-boot, nix-switch, nix-update, nix-upgrade)
    source $__fish_config_dir/functions/nix.fish

    # Load wireguard functions (start-wg, stop-wg, status-wg)
    if test -f $__fish_config_dir/functions/wireguard.fish
        source $__fish_config_dir/functions/wireguard.fish
    end
end
