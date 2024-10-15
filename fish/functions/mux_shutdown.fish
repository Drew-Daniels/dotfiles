function mux_shutdown -d "Gracefully shuts down all tmuxinator projects"
    mux stop dotfiles
    mux stop work_notes
    mux stop healthmatters
end
