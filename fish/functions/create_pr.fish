function create_pr -d "Creates a PR"
    set -l title (jg cc)

    cat $XDG_CONFIG_HOME/kipu_pr_template.md >./tmp/kipu_pr_body.md

    set -l issue_key (jg key)
    set -l related_prs (related_prs $issue_key)

    if test $status -eq 0
        set -l line_num 8
        for pr in (string split " " $related_prs)
            set -l var (string join '' $line_num i)
            gsed -i "$var - $pr" ./tmp/kipu_pr_body.md
            set -l line_num (math $line_num + 1)
        end
    end

    gh pr create --base encounters-dev --title=$title --assignee=@me --web --draft --template=./tmp/kipu_pr_body.md

    rm ./tmp/kipu_pr_body.md
end
