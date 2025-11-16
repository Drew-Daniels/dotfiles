#  /$$$$$$$  /$$   /$$ /$$   /$$
# | $$__  $$| $$  | $$|  $$ /$$/
# | $$  \ $$| $$  | $$ \  $$$$/
# | $$  | $$| $$  | $$  >$$  $$
# | $$  | $$|  $$$$$$/ /$$/\  $$
# |__/  |__/ \______/ |__/  \__/

# Features:
  # Enhanced `start` functionality
    # Wrapper of `tmuxinator start` subcommand that allows you to start multiple tmux sessions at once by specifying the directory names for all the projects you want to start tmux sessions for
    # For every directory name listed, if there is a tmuxinator config with the same name, tmuxinator will start a tmux session using that config
    # Otherwise, tmuxinator will start a tmux session using the default tmuxinator project template, and start the session in that directory
  # Enhanced `stop` functionality
    # Wrapper of `tmuxinator stop` subcommand that allows you to stop multiple tmux sessions at once by name
    # For every session name, if there is a corresponding tmuxinator config with the same name, the tmux session will be stopped with `tmux stop` to ensure that on_project_stop hooks are called
    # Otherwise, tmux will just kill the session of that name as normal
  # Unified `start`/`stop` interface for all tmux sessions, regardless of whether or not they have a corresponding tmuxinator project configuration created for them
  # Enhancement to allow users to start (or attach to) a tmux session with a name matching the current directory, if no arguments are provided
    # Uses the same start_sessions logic to determine whether or not a project-specific tmuxinator template should be used or the default project template when creating the tmux session
# NOTE: To use the "wrapped" start functionality, you'll need to have your tmuxinator project configurations use the `attach: false` option, so `nux` can start multiple
# tmux sessions consecutively without getting attached to one. If you don't do this, you'll get attached to one session, and the next one won't be started until you detach.

# TODO: Enable users to specify alternative `projects` directory
# TODO: Figure out how to have this command still use fish shell completions for tmuxinator (if possible)
# TODO: Figure out if there is a way to prevent nested tmux sessions

function nux -d "Wrapper function for tmuxinator (mux) that adds some nice to have functionality"
    set -l first_arg $argv[1]
    set -l stop_regex '^(stop)$'
    set -l builtin_regex '^(commands|completions|copy|cp|debug|delete|doctor|edit|implode|list|ls|local|new|open|start|version)$'

    function start_sessions
        for project in $argv
            if test -e ~/.config/tmuxinator/$project.yml
                tmuxinator $project
            else
                tmuxinator project -n $project d=$project
            end
        end
        tmux attach -t $argv[-1]
    end

    function stop_sessions
        set -l sessions $argv
        for session in $sessions
            if test -e ~/.config/tmuxinator/$session.yml
                tmuxinator stop $session
            else
                tmux kill-session -t $session
            end
        end
        return 0
    end

    # `nux`
    # @fish-lsp-disable-next-line 3001
    if test -z $first_arg
        set -l dir (path basename (pwd))
        start_sessions $dir
        return 0
    end

    # `nux stop-all`
    if string match -q -r '^(stop-all)$' "$first_arg"
        set -l sessions (tmux ls | awk '{print $1}' | sed 's/:$//')
        stop_sessions $sessions
        return 0
    end

    # `nux stop <project1> <project2> ...`
    if string match -q -r "$stop_regex" "$first_arg"
        set -l sessions $argv[2..-1]
        stop_sessions $sessions
        return 0
    end

    # `nux ls`
    # pass through if another builtin tmuxinator command used
    if string match -q -r "$builtin_regex" "$first_arg"
        tmuxinator $argv
        return 0
    end

    # After verifying first (and potentially, only) argument is not a built-in command, it's assumed the arguments provided are a list of one or more projects
    # `nux <project1> <project2> ...`
    set -l projects $argv
    start_sessions $projects
end
