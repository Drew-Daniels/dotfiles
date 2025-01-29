function mstop -d "Gracefully shuts down all tmuxinator projects"
    set -l projects_str (mux list -a | tail -n+2 | sed -r 's/ +/ /g;')
    set -l projects (string split ' ' $projects_str)

    for project in $projects
        echo "Stopping $project"
        mux stop $project
    end
end
