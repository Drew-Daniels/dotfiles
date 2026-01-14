function tk -d 'Kills a tmux session'
    command tmux kill-session -t $argv
end
