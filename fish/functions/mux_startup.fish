function mux_startup -d "Starts up tmuxinator projects"
    set -l projects_str dotfiles work_notes healthmatters
    set -l projects (string split ' ' $projects_str)

    for project in $projects
        echo "Starting $project"
        mux start $project --attach=false
    end
end
