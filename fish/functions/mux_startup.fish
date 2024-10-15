function mux_startup -d "Starts up tmuxinator projects"
    mux dotfiles -a=false
    mux work_notes -a=false
    mux healthmatters -a=false
end
