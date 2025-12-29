complete -e -c nux

# Subcommands - only at position 1
complete -f -c nux -n '__fish_is_nth_token 1' -a stop -d 'Stop sessions'
complete -f -c nux -n '__fish_is_nth_token 1' -a stop-all -d 'Stop all sessions'
complete -f -c nux -n '__fish_is_nth_token 1' -a status -d 'Show session status'

# Projects - only at position 1 (starting sessions)
complete -f -c nux -n '__fish_is_nth_token 1' -a '(ls ~/projects 2>/dev/null)'

# Session names - only after 'stop' at position 2+
complete -f -c nux -n '__fish_seen_subcommand_from stop; and not __fish_is_nth_token 1' \
    -a '(tmux ls -F "#{session_name}" 2>/dev/null)'
