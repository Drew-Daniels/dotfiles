function create_pr -d "Creates a PR"
    set -l title (jg cc)
    echo "Creating PR for $title"
    # gh pr create --base encounters-dev --title=$title --assignee=@me --web --draft --template=$XDG_CONFIG_HOME/projects/dotfiles/kipu_pr_template.md
    # TODO: Use a custom template that attaches related PRs and inserts before & after markdown table 
    set -l issue_key (jg key)
    set -l related_prs (related_prs $issue_key)
    printf $related_prs
    # https://cli.github.com/manual/gh_pr_create
end
