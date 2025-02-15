function mstart -d "Starts up tmuxinator projects"
    set -l projects (string split ' ' $DEFAULT_TMUXINATOR_PROJECTS)

    for project in $projects
        echo "Starting $project"
        mux start $project --attach=false
    end
end
