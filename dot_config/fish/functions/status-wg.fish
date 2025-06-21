function status-wg -d "Wireguard Status"
    command sudo systemctl status wg-quick-wg0.service
end
