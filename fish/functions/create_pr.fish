function create_pr -d "Creates a PR"
    set -l title (jg cc)
    printf "PR Title:\n\t$title\n"

    bat $XDG_CONFIG_HOME/pr_body_template.md >./tmp/pr_body.md

    set -l issue_key (jg key)
    set -l related_prs (related_prs $issue_key)

    if test $status -eq 0
        set -l line_num 8
        for pr in (string split " " $related_prs)
            set -l var (string join '' $line_num i)
            gsed -i "$var - $pr" ./tmp/pr_body.md
            set -l line_num (math $line_num + 1)
        end
    end

    printf "PR Body:\n"
    bat ./tmp/pr_body.md
    # gh pr create --base encounters-dev --title=$title --assignee=@me --web --draft --template=./tmp/pr_body.md

    rm ./tmp/pr_body.md
end
