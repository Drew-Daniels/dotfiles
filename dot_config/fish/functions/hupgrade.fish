function hupgrade -d "Updates homebrew, upgrades homebrew packages, and takes care of some things"
    brew update && brew outdated && brew upgrade && brew cleanup

    # https://github.com/Homebrew/homebrew-core/pull/218854
    command rm -f (brew --prefix)/etc/gitconfig

    brew unlink block-goose-cli
    ln -s $(brew --prefix)/opt/block-goose-cli/bin/goose $(brew --prefix)/bin/goose-cli
end
