function mux -d "Starts a new tmux session using the default 'project' tmuxinator template, and inside the directory in default project directory matching the name provided"
    set -l first_arg $argv[1]
    set -l builtin_regex '^(commands|completions|copy|debug|delete|doctor|edit|implode|list|local|new|open|start|stop|version)$'

    if test -z $first_arg
        echo "Project Name is Required"
        return 1
    end

    # pass through if builtin tmuxinator command used
    if string match -q -r "$builtin_regex" "$first_arg"
        mux $argv
        return 0
    end

    # After verifying argument is not a built-in command, we can assume it is a project name and create a new variable with a name that better indicates what it is
    set -l project_name = $first_arg

    # pass through if no project with name == project_name exists in project directory so tmuxinator can handle errors itself
    if test -e ~/projects/$project_name
        mux project -n $project_name d=$project_name
    end

    # otherwise create a new tmux session using a specific project template with a name matching the first argument provided, or use default tmuxinator project template
    # attaches to project_name tmux session if one already exists
    if test -e ~/.config/tmuxinator/$project_name.yml
        mux $project_name
    else
        mux project -n $project_name d=$project_name
    end
end
