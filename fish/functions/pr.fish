function pr -d "Generates a Slack Message to Link to a Jira Ticket and Pull Request"
    set -l options q/quiet c/clipboard h/help
    argparse $options -- $argv

    if set --query _flag_help
        printf "Usage: pr [OPTIONS]\n\n"
        printf "Options:\n"
        printf "  -c/--clipboard  Copy result to clipboard\n"
        printf "  -q/--quiet      Don't print anything\n"
        printf "  -h/--help       Prints help and exits\n"
    end

    set -l jira_issue_md_link (jlink -m)
    set -l jira_issue_id (jlink -i)

    set -l gh_number_and_link (gh search prs $jira_issue_id --assignee="@me" --json=number,title,url --match=title --limit=1 | jq -r '.[0] | [.number, .url] | join(" ")')
    set -l gh_number (echo $gh_number_and_link | cut -d ' ' -f1)
    set -l gh_link (echo $gh_number_and_link | cut -d ' ' -f2)
    set -l gh_md_link "[#$gh_number]($gh_link)"

    set -l message "PR for $jira_issue_md_link: $gh_md_link"

    if set -q _flag_c
        echo -n $message | pbcopy
        if test -z "$_flag_q"
            echo "Copied Slack Message to Clipboard: $message"
        end
    else
        echo $message
    end
end
