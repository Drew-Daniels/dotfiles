function stop-wg -d "Stops Wireguard Service"
    command sudo systemctl stop wg-quick-wg0
end
