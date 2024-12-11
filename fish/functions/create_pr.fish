function create_pr -d "Creates a PR"
    set -l title (jg cc)
    set -l tmp_file $PWD/tmp/pr_body.md
    printf "PR Title:\n\t$title\n"

    cat $XDG_CONFIG_HOME/work/pr_body_template.md >$tmp_file

    set -l issue_key (jg key)
    # TODO: Modify to use 'jg related' at some point
    set -l related_prs (_related_prs $issue_key)

    # TODO: Modify to include link to the Jira ticket in the body

    if test $status -eq 0
        set -l line_num 8
        for pr in (string split " " $related_prs)
            set -l var (string join '' $line_num i)
            gsed -i "$var - $pr" ./tmp/pr_body.md
            set -l line_num (math $line_num + 1)
        end
    end

    printf "PR Body:\n"
    cat $tmp_file

    gh pr create --base main --title=$title --assignee=@me --draft --body-file=$tmp_file

    rm $tmp_file
end
