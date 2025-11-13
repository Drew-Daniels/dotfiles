function nux -d "Starts a new tmux session using the default 'project' tmuxinator template, and inside the directory in default project directory matching the name provided"
    set -l first_arg $argv[1]
    set -l stop_regex '^(stop)$'
    set -l builtin_regex '^(commands|completions|copy|debug|delete|doctor|edit|implode|list|local|new|open|start|version)$'

    # @fish-lsp-disable-next-line 3001
    if test -z $first_arg
        echo "Project Name is Required"
        return 1
    end

    # if stop command passed, special handling is required
    # if there is a corresponding tmuxinator config, run `mux stop <project>`
    # otherwise, run `tmux kill-session -t <project>`
    if string match -q -r "$stop_regex" "$first_arg"
        if test -e "~/.config/tmuxinator/$argv[2].yml"
            tmuxinator stop $argv
        else
            tmux kill-session -t $argv[2]
        end
        return 0
    end

    # pass through if another builtin tmuxinator command used
    if string match -q -r "$builtin_regex" "$first_arg"
        tmuxinator $argv
        return 0
    end

    # After verifying first (and potentially, only) argument is not a built-in command, we can assume it is a project name and create a new variable with a name that better indicates what it is
    set -l project_name $first_arg

    # otherwise create a new tmux session using a specific project template with a name matching the first argument provided, or use default tmuxinator project template
    # attaches to project_name tmux session if one already exists
    echo "~/.config/tmuxinator/$project_name.yml"
    if test -e ~/.config/tmuxinator/$project_name.yml
        tmuxinator $project_name
    else
        tmuxinator project -n $project_name d=$project_name
    end
end
