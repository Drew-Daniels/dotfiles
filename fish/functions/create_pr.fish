function create_pr -d "Creates a PR"
    set -l title (jg cc)
    echo "Creating PR for $title"
    # TODO: Use git to get correct base branch (main, encounters-dev, etc) Ex., `git log --first-parent`
    gh pr create --base encounters-dev --title=$title --assignee=@me --web --draft
    # TODO: Use a custom template that attaches related PRs and inserts before & after markdown table 
    # https://cli.github.com/manual/gh_pr_create
end
