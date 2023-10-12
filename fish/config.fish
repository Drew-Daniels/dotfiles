if status is-interactive
    fish_add_path /opt/homebrew/bin
    fish_add_path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"


    # fish-specific
    # turn off greeting
    set -g fish_greeting

    # general
    set -gx EDITOR nvim
    alias cls "printf '\33c\e[3J'"

    # colorls
    alias lc "colorls -lA --sd"

    # pnpm
    set -gx PNPM_HOME "/Users/drew.daniels/Library/pnpm"

    fish_add_path PNPM_HOME

    # pnpm end

    # docker
    source ~/.docker/init-zsh.sh || true
    # docker end    

    # Android
    set -gx ANDROID_HOME $HOME/Library/Android/sdk
    fish_add_path $ANDROID_HOME/emulator
    fish_add_path $ANDROID_HOME/tools
    fish_add_path $ANDROID_HOME/tools/bin
    fish_add_path $ANDROID_HOME/platform-tools

    # asdf
    set -gx ASDF_CONFIG_FILE ~/projects/dotfiles/asdf/.asdfrc
    source ~/.asdf/asdf.fish

    # nvim
    set -gx XDG_CONFIG_HOME ~/projects/dotfiles
    set -gx VIMCONFIG ~/.config/nvim
    set -gx VIMDATA ~/.local/share/nvim

    # fisher
    set -gx FISHER_PATH ~/projects/dotfiles/fish

    # starship
    set -gx STARSHIP_CONFIG ~/projects/dotfiles/starship/starship.toml
    starship init fish | source

    # fzf.fish
    fzf_configure_bindings --processes=\cp --git_status=\cs --git_log=\cl --directory=\cf

    # homebrew
    fish_add_path /usr/local/sbin

    # tmuxinator
    alias mux=tmuxinator

    # go
    . ~/.asdf/plugins/golang/set-env.fish

    # pip fish completion start
    function __fish_complete_pip
        set -lx COMP_WORDS (commandline -o) ""
        set -lx COMP_CWORD ( \
            math (contains -i -- (commandline -t) $COMP_WORDS)-1 \
        )
        set -lx PIP_AUTO_COMPLETE 1
        string split \  -- (eval $COMP_WORDS[1])
    end
    complete -fa "(__fish_complete_pip)" -c pip
    # pip fish completion end

end
