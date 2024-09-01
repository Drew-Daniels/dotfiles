if status is-interactive
    fish_add_path /opt/homebrew/bin

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
    set -gx HOMEBREW_BUNDLE_FILE $XDG_CONFIG_HOME/homebrew/Brewfile
    set -gx HOMEBREW_BUNDLE_NO_LOCK 1

    # tmux
    alias tn="tmux new -s"
    alias ta="tmux attach -t"
    alias tl="tmux ls"
    alias tk="tmux kill-session -t"

    # tmuxinator
    alias mux="tmuxinator"
    alias ts="mux start project"

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

    # neovim
    alias upgrade_nvim "brew upgrade nvim --fetch-HEAD"

    # yazi
    function ya
        set tmp (mktemp -t "yazi-cwd.XXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    set gx YAZI_CONFIG_HOME "$XDG_CONFIG_HOME/yazi"

    # gitlab
    alias gll "$XDG_CONFIG_HOME/scripts/gll.sh"

    # neovim can't use aliases in command mode, so making scripts globally available
    fish_add_path "$XDG_CONFIG_HOME/scripts"

    # cspell
    alias cspell "cspell --config $XDG_CONFIG_HOME/cspell/cspell.yml"

    # java
    fish_add_path "/opt/apache-maven-3.8.5/bin"

    # mise
    /opt/homebrew/bin/mise activate fish | source

    # playwright
    alias psr="npx playwright show-report"

    # solargraph - https://github.com/castwide/solargraph
    set gx SOLARGRAPH_GLOBAL_CONFIG "$XDG_CONFIG_HOME/solargraph/config.yml"
end
