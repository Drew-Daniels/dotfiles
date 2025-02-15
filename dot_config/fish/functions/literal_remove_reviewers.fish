function remove_reviewers -d "Remove reviewers from a pull request"
    # TODO: Figure out why the CLI cannot remove reviewers: https://github.com/orgs/community/discussions/23054#discussioncomment-11802614
    if test -z $REVIEWERS
        echo "No reviewers provided"
        return 1
    end

    set -l reviewers $REVIEWERS

    gh pr edit --remove-reviewer $reviewers
end
