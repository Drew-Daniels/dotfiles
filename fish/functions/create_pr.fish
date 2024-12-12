function create_pr -d "Creates a PR"
    set -l title (jg cc)
    set -l jira_ticket_md_link (jg url -m)
    set -l tmp_file $PWD/tmp/pr_body.md
    printf "PR Title:\n\t$title\n"

    cat $XDG_CONFIG_HOME/work/pr_body_template.md >$tmp_file

    set -l issue_key (jg key)
    # TODO: Modify to use 'jg related' at some point
    set -l related_prs (_related_prs $issue_key)

    # TODO: Modify to include link to the Jira ticket in the body

    if test $status -eq 0
        # Append jira ticket link
        gsed -i "/Link/a $jira_ticket_md_link" $tmp_file

        # TODO: Format these as markdown links
        # Insert links to related PRs
        set -l line_num 8
        for pr in (string split " " $related_prs)
            set -l var (string join '' $line_num i)
            gsed -i "$var - $pr" ./tmp/pr_body.md
            set -l line_num (math $line_num + 1)
        end
    end

    printf "PR Body:\n"
    bat $tmp_file --paging=never
    # cat $tmp_file

    # gh pr create --base main --title=$title --assignee=@me --draft --body-file=$tmp_file

    # rm $tmp_file
end
