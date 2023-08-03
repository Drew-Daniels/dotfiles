if status is-interactive
	set -x PATH "$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

	# pnpm
	set -x PNPM_HOME "/Users/drew.daniels/Library/pnpm"
	set -x PATH "$PNPM_HOME:$PATH"
	# pnpm end

	# docker start
	source ~/.docker/init-zsh.sh || true
	# docker end

	# Android
	set -x ANDROID_HOME $HOME/Library/Android/sdk
	set -x PATH $PATH:$ANDROID_HOME/emulator
	set -x PATH $PATH:$ANDROID_HOME/tools
	set -x PATH $PATH:$ANDROID_HOME/tools/bin
	set -x PATH $PATH:$ANDROID_HOME/platform-tools

	# asdf
	set -x ASDF_CONFIG_FILE "$HOME/projects/dotfiles/asdf/.asdfrc"
	source ~/.asdf/asdf.fish

	# nvim
	set -x XDG_CONFIG_HOME ~/projects/dotfiles
	set -x VIMCONFIG ~/.config/nvim
	set -x VIMDATA ~/.local/share/nvim

	# fzf
	set -x FZF_DEFAULT_COMMAND 'rg --files'
end
