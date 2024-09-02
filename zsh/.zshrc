. ~/projects/dotfiles/zsh/secrets

# export env vars that vary by machine - such as git config email
set -o allexport && source ~/projects/dotfiles/.env.local && set +o allexport

export XDG_CONFIG_HOME=~/projects/dotfiles

parse_git_branch() {
  git branch 2>/dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
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

# pnpm
export PNPM_HOME="/Users/drew.daniels/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
alias pn="pnpm"

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
alias tn="tmux new -s"
alias ta="tmux attach -t"
alias tl="tmux ls"
alias tk="tmux kill-session -t"

# tmuxinator
alias mux=tmuxinator
alias ts="mux start project"
export MUX_LAYOUT=main-horizontal
export MUX_SHELL_RUN_CMD="arch -x86_64 zsh"

# homebrew
PATH="/usr/local/sbin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"

# homebrew shell completion
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# brew curl shell completion
fpath=("$(brew --prefix)/opt/curl/share/zsh/site-functions" $fpath)

export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/homebrew/Brewfile"
export HOMEBREW_BUNDLE_NO_LOCK=1

# starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
eval "$(starship init zsh)"

# pip zsh completion start
#compdef -P pip[0-9.]#
#compadd $( COMP_WORDS="$words[*]" \
#           COMP_CWORD=$((CURRENT-1)) \
#           PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null )
# pip zsh completion end

# jless
alias yless="jless --yaml"

# zoxide
eval "$(zoxide init --cmd j zsh)"

# mise
eval "$(/opt/homebrew/opt/mise/bin/mise activate zsh)"

export MISE_RUBY_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/mise/.default-gems"
export MISE_NODE_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/mise/.default-npm-packages"
export MISE_PYTHON_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/mise/.default-python-packages"

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

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/projects/dotfiles/tabtab/zsh/__tabtab.zsh ]] && . ~/projects/dotfiles/tabtab/zsh/__tabtab.zsh || true

# go
# TODO: Figure out why $GOPATH is unset when sourcing this file - likely because mise starts up after, but still, would be nice to not have to hard-code
export GOBIN="~/.local/share/mise/installs/go/1.21.1/packages/bin"

# neovim
alias upgrade_nvim="brew upgrade nvim --fetch-HEAD"

# yazi
function ya() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

export YAZI_CONFIG_HOME="$XDG_CONFIG_HOME/yazi"

# gitlab
alias gll="$XDG_CONFIG_HOME/scripts/gll.sh"

# neovim can't use aliases in command mode, so making scripts globally available
export PATH="$PATH:$XDG_CONFIG_HOME/scripts"

# cspell
alias cspell="cspell --config $XDG_CONFIG_HOME/cspell/cspell.yml"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

# java
export PATH="$PATH:/opt/apache-maven-3.8.5/bin"

# iterm2
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# initialise completions with ZSH's compinit
autoload -Uz compinit bashcompinit
compinit
bashcompinit

# terraform
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# aws cli
complete -C '/usr/local/bin/aws_completer' aws

# playwright
alias psr="npx playwright show-report"

# beets
export BEETSDIR="$XDG_CONFIG_HOME/beets"

# ssh
ssh-add -A 2>/dev/null

# vcpkg - https://github.com/Microsoft/vcpkg
export VCPKG_ROOT=~/projects/vcpkg
export PATH="$VCPKG_ROOT:$PATH"

# solargraph - https://github.com/castwide/solargraph
export SOLARGRAPH_GLOBAL_CONFIG=~/projects/dotfiles/solargraph/config.yml
