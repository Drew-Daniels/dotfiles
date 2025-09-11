function screenshot -d "Takes a screenshot"
    # TODO: Enable custom dir
    # TODO: Better checks around file extensions (.jpg, .jpeg, .png, others?)

    # Defaults
    set -l dir "$HOME/Pictures/Screenshots"

    if test -z "$argv[1]"
        echo "Must specify filename (with extension)"
    else
        set -l filename "$argv[1]"
        grim -g "$(slurp)" - | satty -f - -o "$dir/$filename"
    end

end
