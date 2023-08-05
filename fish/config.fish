if status is-interactive
	fish_add_path "/opt/homebrew/bin"
	fish_add_path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

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

	# fzf
	set -gx FZF_DEFAULT_COMMAND 'rg --files'

	# fisher
	set -gx FISHER_PATH ~/projects/dotfiles/fish

    # starship
    set -gx STARSHIP_CONFIG ~/projects/dotfiles/starship/starship.toml
    starship init fish | source

    # fzf.fish
    fzf_configure_bindings --processes=\cp --git_status=\cs --git_log=\cl --directory=\ce

end
