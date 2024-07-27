. ~/projects/dotfiles/secrets

parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}
COLOR_DEF='%f'
COLOR_USR='%F{243}'
COLOR_DIR='%F{197}'
COLOR_GIT='%F{39}'
NEWLINE=$'\n'

export EDITOR="nvim"

setopt PROMPT_SUBST
export PROMPT='${COLOR_USR}%n@%M ${COLOR_DIR}%d ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}${NEWLINE}%% '

export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)

# nvim
export XDG_CONFIG_HOME=~/projects/dotfiles
export VIMCONFIG=~/.config/nvim
export VIMDATA=~/.local/share/nvim

# general
export PROJECTS_DIR=~/projects
alias cls="printf '\33c\e[3J'"

# tmux
export TMUX_LAYOUT=main-vertical

# tmuxinator
export PROJECTS_DIR=~/projects
alias mux=tmuxinator
export MUX_LAYOUT=main-horizontal
export MUX_SHELL_RUN_CMD="arch -x86_64 zsh"
export EXPORT_E2E_CREDS_SCRIPT=~/projects/dotfiles/scripts/export_e2e_creds.sh

# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --iglob !git'

# starship
export STARSHIP_CONFIG=~/projects/dotfiles/starship/starship.toml
eval "$(starship init bash)"

# zoxide
eval "$(zoxide init --cmd j bash)"
