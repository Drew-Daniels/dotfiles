if status is-interactive
    fish_add_path /opt/homebrew/bin
    fish_add_path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"


    # fish-specific
    # turn off greeting
    set -g fish_greeting

    # general
    set -gx XDG_CONFIG_HOME ~/projects/dotfiles
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    alias cls "printf '\33c\e[3J'"

    # ripgrep
    # search for pattern in filenames
    alias rgf "rg --files | rg"

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

    # nvim
    set -gx VIMCONFIG ~/.config/nvim
    set -gx VIMDATA ~/.local/share/nvim

    # fisher
    set -gx FISHER_PATH $XDG_CONFIG_HOME/fish

    # starship
    set -gx STARSHIP_CONFIG $XDG_CONFIG_HOME/starship/starship.toml
    starship init fish | source

    # fzf.fish
    fzf_configure_bindings --processes=\cp --git_status=\cs --git_log=\cl --directory=\cf

    # homebrew
    fish_add_path /usr/local/sbin

    # tmuxinator
    alias mux="tmuxinator"

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

    # jless
    alias yless="jless --yaml"

    # taskwarrior
    set -gx TASKRC $XDG_CONFIG_HOME/taskwarrior/.taskrc

    # zoxide
    zoxide init --cmd j fish | source

    # bat
    alias cat="bat"
    alias man="batman"
    alias pb="prettybat"

    # lsd
    alias ls="lsd"

    # tabtab source for packages
    # uninstall by removing these lines
    [ -f $XDG_CONFIG_HOME/tabtab/fish/__tabtab.fish ]; and . $XDG_CONFIG_HOME/tabtab/fish/__tabtab.fish; or true

    alias pn="pnpm"
end
