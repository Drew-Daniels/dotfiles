function start-wg -d "Starts Wireguard Service"
    command sudo systemctl start wg-quick-wg0.service
end
