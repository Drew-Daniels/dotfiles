function muxp -d "Starts a new tmux session using the default 'project' tmuxinator template, and inside the directory in default project directory matching the name provided"
    set -l project_name $argv[1]

    if test -z $project_name
        echo "Project Name is Required"
        return 1
    end

    set regex '^(commands|completions|copy|debug|delete|doctor|edit|implode|list|local|new|open|start|stop|version)$'

    # pass through if builtin command used
    if string match -q -r "$regex" "$project_name"
        mux $project_name
        return 0
    end

    # otherwise create a new tmux session using a specific project template with a name matching the first argument provided, or use default tmuxinator project template
    # attaches to project_name tmux session if one already exists
    if test -e ~/.config/tmuxinator/$project_name.yml
        mux $project_name
    else
        mux project -n $project_name d=$project_name
    end
end
