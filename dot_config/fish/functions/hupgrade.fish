function hupgrade -d "Updates homebrew, upgrades homebrew packages, and takes care of some things"
    brew update && brew outdated && brew upgrade && brew cleanup

    # https://github.com/Homebrew/homebrew-core/pull/218854
    command rm -f (brew --prefix)/etc/gitconfig

    if test -d /opt/homebrew/Cellar/node
        # Many dependencies require node to be installed and will install it implicitly if not found in homebrew installation directory
        brew uninstall --ignore-dependencies node
    end

    if test -d /opt/homebrew/Cellar/python@3*
        brew uninstall --ignore-dependencies python3
    end
end
