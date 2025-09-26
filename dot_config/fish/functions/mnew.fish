function mnew -d "Starts a new tmuxinator session, using the name of the current working directory as the session name"
    tmux new-session -s (basename $PWD)
end
