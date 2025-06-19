function btdisconnect -d "Disconnects from Headphones"
    command bluetoothctl disconnect "$BEATS_PRO_MAC_ADDR"
end
