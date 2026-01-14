function create-pr -d "Creates a PR"
    set -l options b/base=
    argparse $options -- $argv

    if test -z "$_flag_base"
        set base_branch main
    else
        set base_branch $_flag_b
    end

    set -l title (jg cc)
    set -l jira_ticket_md_link (jg url -m)
    set -l tmp_file $PWD/tmp/pr_body.md
    printf "PR Title:\n\t$title\n"

    # TODO: Use mktemp instead
    cat ~/projects/dotfiles/work/pr_body_template.md >$tmp_file

    set -l issue_key (jg key)

    # Insert Jira ticket link
    gsed -i "s#insert-ticket-link-here#$jira_ticket_md_link#g;" $tmp_file

    # Insert links to related PRs
    # TODO: Modify to use 'jg related' at some point
    set -l related_prs (_related_prs $issue_key)
    if test $status -eq 0
        set -l line_num 9
        for pr in (string split " " $related_prs)
            set -l var (string join '' $line_num i)
            gsed -i "$var \ \ - $pr" ./tmp/pr_body.md
            set -l line_num (math $line_num + 1)
        end
    end

    printf "PR Body:\n"
    bat $tmp_file --paging=never

    gh pr create --base="$base_branch" --title="$title" --assignee=@me --draft --body-file=$tmp_file

    gh pr view --web

    rm $tmp_file
end
