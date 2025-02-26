function switchbb -d "Sets the base branch of a PR to encounters-dev"
    if test -z $argv[1]
        printf "Must specify a branch\n"
        return 1
    end

    # update base branch
    gh pr edit --base $argv
end
