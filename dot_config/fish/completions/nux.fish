complete -c nux -f
complete -c nux -n __fish_use_subcommand -a stop -d 'Stop sessions'
complete -c nux -n __fish_use_subcommand -a stop-all -d 'Stop all sessions'
complete -c nux -n __fish_use_subcommand -a status -d 'Show session status'
complete -c nux -n '__fish_seen_subcommand_from stop' -a '(tmux ls -F "#{session_name}" 2>/dev/null)'
complete -c nux -n 'not __fish_seen_subcommand_from stop stop-all status' -a '(ls ~/projects 2>/dev/null)'

