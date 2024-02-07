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
export VISUAL="nvim"

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

# ripgrep
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/.ripgreprc"
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

# tmux
# export TERM=screen-256color

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

# zoxide
eval "$(zoxide init --cmd j zsh)"

# mise
eval "$(/opt/homebrew/opt/mise/bin/mise activate zsh)"

# bat
alias cat="bat"
alias man="batman"
alias pb="prettybat"
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
batdiff() {
    git diff --name-only --relative --diff-filter=d | xargs bat
}
# lsd
alias ls="lsd"

# pnpm

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/projects/dotfiles/tabtab/zsh/__tabtab.zsh ]] && . ~/projects/dotfiles/tabtab/zsh/__tabtab.zsh || true

alias pn="pnpm"

# go
# TODO: Figure out why $GOPATH is unset when sourcing this file - likely because mise starts up after, but still, would be nice to not have to hard-code
export GOBIN="~/.local/share/mise/installs/go/1.21.1/packages/bin"

