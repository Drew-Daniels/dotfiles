function mux_shutdown -d "Gracefully shuts down all tmuxinator projects"
    # get a list of all active tmuxinator projects
    # TODO: Create an array from this string and iteratively stop all projects
    set -l projects (mux list -a | tail -n+2 | sed -r 's/ +/ /g;')
    mux stop dotfiles
    mux stop work_notes
    mux stop healthmatters
end
