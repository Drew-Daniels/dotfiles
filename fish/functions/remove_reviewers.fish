function remove_reviewers -d "Remove reviewers from a pull request"
    if test -z $REVIEWERS
        echo "No reviewers provided"
        return 1
    end

    set -l reviewers (string split , $REVIEWERS)

    for reviewer in $reviewers
        gh pr edit --remove-reviewer $reviewer
    end
end