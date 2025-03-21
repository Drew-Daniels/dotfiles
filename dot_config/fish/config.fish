if status is-interactive
    switch (uname)
        case Linux
	    if command -q mise
              mise activate fish | source
            end
            # TODO: make specific to macos
            set computerName (hostname)
        case '*'
            # helpers
            set computerName (scutil --get ComputerName)
            # homebrew
            fish_add_path /opt/homebrew/bin
            fish_add_path /usr/local/sbin

            # mise
            /opt/homebrew/bin/mise activate fish | source

            # TODO: Figure out how to do this on linux
            # theme
            defaults read "Apple Global Domain" AppleInterfaceStyle &>/dev/null
            set -l os_theme_query_status $status
            if test $os_theme_query_status -eq 1
                # this setting is only set when using dark mode
                set -gx OS_THEME_DARK 0
                fish_config theme choose "Mono Lace"
            else
                set -gx OS_THEME_DARK 1
                fish_config theme choose "Base16 Default Dark"
            end

    end

    # fish
    # turn off greeting
    set -g fish_greeting

    # general
    alias cls "printf '\33c\e[3J'"

    # neovim
    fish_add_path /opt/nvim-linux-x86_64/bin

    # pnpm
    fish_add_path PNPM_HOME

    # starship
    starship init fish | source

    # fzf.fish
    fzf_configure_bindings --directory=\cf --processes=\cp --git_status=\cs --git_log=\cl --variables=\cv --history=\ch

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
    alias man="batman"
    alias pb="prettybat"

    # lsd
    alias ls="lsd"

    # tabtab source for packages
    # uninstall by removing these lines

    alias pn="pnpm"

    # yazi
    function ya
        set tmp (mktemp -t "yazi-cwd.XXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    # java
    fish_add_path "/opt/apache-maven-3.8.5/bin"

    # playwright
    alias psr "npx playwright show-report"

    # htmlbeautifier
    alias hb htmlbeautifier

    # spotify_player
    alias sp spotify_player

    # Run rubocop only on ruby files that have changed
    alias rcdiff "git diff --name-only -- '***.rb' | xargs bundle exec rubocop --force-exclusion -a"
    # Run rspec only on ruby files that have changed
    alias rsdiff "git diff --name-only -- '***_spec.rb' | xargs bundle exec rspec"

    # bundler
    alias be "bundle exec"
    # alias ber "bundle exec rspec"
    alias ber "bundle exec rake"

    # 1password
    op completion fish | source

    # jira
    if test $computerName = KIPU-DDANIELS
        jira completion fish | source
    end

    # docker
    # TODO: Deactivate for now, until I'm able to install Docker Desktop on Debian
    # docker completion fish | source

    # keepassxc
    alias kxc keepassxc-cli

    # ollama
    alias ol ollama
end
