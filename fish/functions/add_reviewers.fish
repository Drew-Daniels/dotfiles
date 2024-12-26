function add_reviewers -d "Add reviewers to a pull request"
    set -l current_branch (git branch --show-current)

    if test -z $REVIEWERS
        echo "No reviewers provided"
        return 1
    end

    if [ $current_branch = main ] || [ $current_branch = encounters-dev ]
        echo "Check out a feature branch"
        return 1
    end

    set -l reviewers $REVIEWERS
    echo $reviewers

    gh pr edit --add-reviewer $reviewers
end
