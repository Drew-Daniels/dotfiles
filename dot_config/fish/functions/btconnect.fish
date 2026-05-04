function btconnect --description "Connects to Headphones"
    command bluetoothctl connect "$BEATS_PRO_MAC_ADDR"
end
