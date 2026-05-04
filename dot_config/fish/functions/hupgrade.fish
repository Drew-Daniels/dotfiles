function hupgrade -d "Updates homebrew, upgrades homebrew packages, and cleans up"
    brew update && brew outdated && brew upgrade && brew cleanup
end
