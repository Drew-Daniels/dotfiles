function utcgit --wraps git
    TZ=UTC command git $argv
end
