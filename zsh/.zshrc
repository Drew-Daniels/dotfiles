. ~/projects/dotfiles/zsh/secrets

export XDG_CONFIG_HOME=~/projects/dotfiles

parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}
COLOR_DEF='%f'
COLOR_USR='%F{243}'
COLOR_DIR='%F{197}'
COLOR_GIT='%F{39}'
NEWLINE=$'\n'

export EDITOR="nvim"
export VISUAL="ewrap"

setopt PROMPT_SUBST
export PROMPT='${COLOR_USR}%n@%M ${COLOR_DIR}%d ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}${NEWLINE}%% '

export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# pnpm
export PNPM_HOME="/Users/drew.daniels/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# docker
source ~/.docker/init-zsh.sh || true
# docker end

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# asdf
export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/.asdfrc"
. "$HOME/.asdf/asdf.sh"
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)

# ripgrep
RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/.ripgreprc"
# search for pattern in filenames
alias rgf="rg --files | rg"

# nvim
export VIMCONFIG=~/.config/nvim
export VIMDATA=~/.local/share/nvim

# general
export PROJECTS_DIR=~/projects
alias cls="printf '\33c\e[3J'"
alias arm="/usr/bin/env arch -arm64 zsh"
alias intel="/usr/bin/env arch -x86_64 zsh"
alias pclean="$XDG_CONFIG_HOME/scripts/clean-parsers.sh"

# tmuxp
export TMUXP_LAYOUT=main-vertical

# tmuxinator
alias mux=tmuxinator
export MUX_LAYOUT=main-horizontal
export MUX_SHELL_RUN_CMD="arch -x86_64 zsh"
export EXPORT_E2E_CREDS_SCRIPT="$XDG_CONFIG_HOME/scripts/export_e2e_creds.sh"

# starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
eval "$(starship init zsh)"

# homebrew
PATH="/usr/local/sbin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"

# homebrew shell completion
if type brew &>/dev/null
then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# brew curl shell completion
fpath=("$(brew --prefix)/opt/curl/share/zsh/site-functions" $fpath)

# pip zsh completion start
#compdef -P pip[0-9.]#
#compadd $( COMP_WORDS="$words[*]" \
#           COMP_CWORD=$((CURRENT-1)) \
#           PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null )
# pip zsh completion end

# initialise completions with ZSH's compinit
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# aws cli
complete -C '/usr/local/bin/aws_completer' aws

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/drew/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/drew/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/drew/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/drew/google-cloud-sdk/completion.zsh.inc'; fi

# jless
alias yless="jless --yaml"

# taskwarrior
export TASKRC="$XDG_CONFIG_HOME/taskwarrior/.taskrc"

# nnn
n ()
{
    # Block nesting of nnn in subshells
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #      NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The command builtin allows one to alias nnn to n, if desired, without
    # making an infinitely recursive alias
    command nnn -Pp "$@"

    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    }
}
# sync subshell
nnn_cd()                                                                                                   
{
    if ! [ -z "$NNN_PIPE" ]; then
        printf "%s\0" "0c${PWD}" > "${NNN_PIPE}" !&
    fi  
}

trap nnn_cd EXIT

export NNN_PLUG="p:preview-tui"
export NNN_FIFO="/tmp/nnn.fifo"

# zoxide
eval "$(zoxide init --cmd j zsh)"

