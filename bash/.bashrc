# export env vars that vary by machine and that need to be *immediately* loaded into the shell process
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

export PROMPT='${COLOR_USR}%n@%M ${COLOR_DIR}%d ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}${NEWLINE}%% '

# pnpm
export PNPM_HOME="/Users/drew.daniels/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
alias pn="pnpm"

# ripgrep
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/.ripgreprc"

# fzf
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_DEFAULT_OPTS_FILE="$XDG_CONFIG_HOME/fzf/.fzfrc"

# nvim
export VIMCONFIG=~/.config/nvim
export VIMDATA=~/.local/share/nvim

# general
export PROJECTS_DIR=~/projects
alias cls="printf '\33c\e[3J'"
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

# jless
alias yless="jless --yaml"

# mise
export MISE_CONFIG_DIR="$XDG_CONFIG_HOME/mise"
# development, testing, production
export MISE_ENV="development"

export MISE_RUBY_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/mise/.default-gems"
export MISE_NODE_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/mise/.default-npm-packages"
export MISE_PYTHON_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/mise/.default-python-packages"
eval "$(mise activate bash)"

# zoxide
eval "$(zoxide init --cmd j bash)"

# starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
eval "$(starship init bash)"

# ruby
export IRBRC="$XDG_CONFIG_HOME/irb/irbrc"

# bat
alias man="batman"
alias pb="prettybat"
# these lines are breaking postgres dropdb command for some reason
# alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
# alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
batdiff() {
  git diff --name-only --relative --diff-filter=d | xargs bat
}
# lsd
alias ls="lsd"

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

# java
export PATH="$PATH:/opt/apache-maven-3.8.5/bin"

# aws cli
complete -C '/usr/local/bin/aws_completer' aws

# work
if [ "$MACHINE" = "work" ]; then

  # last_sso_logfile_path="$XDG_CONFIG_HOME/zsh/last_aws_sso_login"
  #
  # last_sso_date_str=$(cat $last_sso_logfile_path)
  # last_sso_timestamp=$(date -j -f '%Y-%m-%d %H:%M:%S' "$last_sso_date_str" '+%s')
  #
  # today_date_str="$(date '+%Y-%m-%d') 00:00:00"
  # today_timestamp=$(date -j -f '%Y-%m-%d %H:%M:%S' "$today_date_str" '+%s')
  #
  # # TODO: Figure out why this fails
  # if [ $today_timestamp -gt $last_sso_timestamp ]; then
  #   echo "Last SSO on: $last_sso_date_str"
  #   echo "Re-authenticating..."
  #   aws sso login --profile kipu-dev
  #   echo $today_date_str >$last_sso_logfile_path
  #   echo "Authenticated"
  # fi

  eval "$(aws configure export-credentials --format env --profile kipu-dev)"
  eval "export AWS_REGION=$(aws configure get region --profile kipu-dev)"

  export DEFAULT_TMUXINATOR_PROJECTS="dotfiles work_notes healthmatters"
fi

# playwright
alias psr="npx playwright show-report"

# beets
export BEETSDIR="$XDG_CONFIG_HOME/beets"

# vcpkg - https://github.com/Microsoft/vcpkg
export VCPKG_ROOT=~/projects/vcpkg
export PATH="$VCPKG_ROOT:$PATH"

# solargraph - https://github.com/castwide/solargraph
export SOLARGRAPH_GLOBAL_CONFIG=~/projects/dotfiles/solargraph/config.yml

# htmlbeautifier
alias hb="htmlbeautifier"

# spotify_player
alias sp="spotify_player"

# Run rubocop only on ruby files that have changed
alias rcdiff="git diff --name-only -- '***.rb' | xargs bundle exec rubocop --force-exclusion -a"
# Run rspec only on ruby files that have changed
alias rsdiff="git diff --name-only -- '***_spec.rb' | xargs bundle exec rspec"

# bundler
alias be="bundle exec"
# alias ber="bundle exec rspec"
alias ber="bundle exec rake"

# 1password
# eval "$(op completion bash)"

# keepassxc
alias kxc="keepassxc-cli"

# alacritty-themes
# https://www.npmjs.com/package/alacritty-themes/v/5.1.1
alias at="alacritty-themes"
