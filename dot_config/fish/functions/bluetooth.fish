# Bluetooth helper functions

function btconnect --description "Connects to Headphones"
    command bluetoothctl connect "$BEATS_PRO_MAC_ADDR"
end

function btdisconnect --description "Disconnects from Headphones"
    command bluetoothctl disconnect "$BEATS_PRO_MAC_ADDR"
end
