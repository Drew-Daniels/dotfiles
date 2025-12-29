#  /$$$$$$$  /$$   /$$ /$$   /$$
# | $$__  $$| $$  | $$|  $$ /$$/
# | $$  \ $$| $$  | $$ \  $$$$/
# | $$  | $$| $$  | $$  >$$  $$
# | $$  | $$|  $$$$$$/ /$$/\  $$
# |__/  |__/ \______/ |__/  \__/

# nux - Enhanced tmuxinator wrapper
# Unified interface for managing tmux sessions with or without tmuxinator configs

set -g NUX_PROJECTS_DIR ~/projects
set -g NUX_TMUXINATOR_DIR ~/.config/tmuxinator

function nux -d "Wrapper function for tmuxinator with enhanced functionality"
    set -l subcommand $argv[1]
    set -l args $argv[2..-1]

    # Helper: Sanitize session name (replace . with _)
    function __nux_sanitize_name
        string replace --all '.' _ $argv[1]
    end

    # Helper: Check if tmuxinator config exists
    function __nux_has_config
        test -e "$NUX_TMUXINATOR_DIR/$argv[1].yml"
    end

    # Helper: Expand glob patterns against a list
    function __nux_expand_globs -a source_cmd
        set -l result
        for pattern in $argv[2..-1]
            if string match -q -r '\+' "$pattern"
                set -l regex (string replace --all '+' '.*' $pattern)
                set -l matches (eval $source_cmd | grep -E "^$regex\$")
                if test -z "$matches"
                    echo "Warning: No matches for pattern '$pattern'" >&2
                else
                    set result $result $matches
                end
            else
                set result $result $pattern
            end
        end
        # Remove duplicates while preserving order
        printf '%s\n' $result | awk '!seen[$0]++'
    end

    # Helper: Get running tmux sessions
    function __nux_running_sessions
        if tmux has-session 2>/dev/null
            tmux ls -F '#{session_name}'
        end
    end

    # Helper: Get available projects
    # @fish-lsp-disable-next-line 4004
    function __nux_available_projects
        if test -d "$NUX_PROJECTS_DIR"
            ls "$NUX_PROJECTS_DIR"
        else
            echo "Error: Projects directory not found: $NUX_PROJECTS_DIR" >&2
            return 1
        end
    end

    # Start one or more sessions
    function __nux_start
        set -l projects $argv
        if test -z "$projects"
            echo "No projects specified" >&2
            return 1
        end

        for project in $projects
            set -l session_name (__nux_sanitize_name $project)

            # Check if session already exists
            if tmux has-session -t "$session_name" 2>/dev/null
                echo "Session '$session_name' already exists, skipping..."
                continue
            end

            # Check if project directory exists (unless it has a tmuxinator config)
            if not __nux_has_config $project
                if not test -d "$NUX_PROJECTS_DIR/$project"
                    echo "Error: Project directory not found: $NUX_PROJECTS_DIR/$project" >&2
                    continue
                end
            end

            if __nux_has_config $project
                echo "Starting '$project' with tmuxinator config..."
                tmuxinator start $project --no-attach
            else
                echo "Starting '$project' with default template..."
                tmuxinator start project -n $session_name d=$project --no-attach
            end
        end

        # Attach to the last session
        set -l last_session (__nux_sanitize_name $projects[-1])
        if tmux has-session -t "$last_session" 2>/dev/null
            tmux attach -t "$last_session"
        end
    end

    # Stop one or more sessions
    function __nux_stop
        set -l sessions $argv
        if test -z "$sessions"
            echo "No sessions specified" >&2
            return 1
        end

        for session in $sessions
            set -l session_name (__nux_sanitize_name $session)

            if not tmux has-session -t "$session_name" 2>/dev/null
                echo "Session '$session_name' not found, skipping..."
                continue
            end

            if __nux_has_config $session
                echo "Stopping '$session_name' with tmuxinator (runs hooks)..."
                tmuxinator stop $session
            else
                echo "Killing session '$session_name'..."
                tmux kill-session -t "$session_name"
            end
        end
    end

    # Main command routing
    switch "$subcommand"
        case '' # No args: start session for current directory
            set -l current_dir (path basename (pwd))
            __nux_start $current_dir

        case stop
            if test -z "$args"
                echo "Usage: nux stop <session1> [session2] ..." >&2
                return 1
            end
            set -l expanded (__nux_expand_globs '__nux_running_sessions' $args)
            __nux_stop $expanded

        case stop-all
            set -l sessions (__nux_running_sessions)
            if test -z "$sessions"
                echo "No tmux sessions running"
                return 0
            end
            echo "Stopping all sessions: $sessions"
            __nux_stop $sessions

        case status # New: show session status
            if not tmux has-session 2>/dev/null
                echo "No tmux sessions running"
                return 0
            end
            echo "Running sessions:"
            tmux ls
            echo ""
            echo "Available tmuxinator configs:"
            ls "$NUX_TMUXINATOR_DIR"/*.yml 2>/dev/null | xargs -I{} basename {} .yml

        case commands completions copy cp debug delete doctor \
            edit implode list ls local new open start version
            # Pass through to tmuxinator
            tmuxinator $subcommand $args

        case '*' # Assume arguments are project names
            set -l expanded (__nux_expand_globs '__nux_available_projects' $argv)
            __nux_start $expanded
    end
end
