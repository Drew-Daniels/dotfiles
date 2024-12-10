function add_reviewers -d "Add reviewers to a pull request"
    if test -z $REVIEWERS
        echo "No reviewers provided"
        return 1
    end

    set -l reviewers (string split , $REVIEWERS)
    echo $reviewers

    for reviewer in $reviewers
        echo "Adding $reviewer as reviewer"
        gh pr edit --add-reviewer $reviewer
    end

end
