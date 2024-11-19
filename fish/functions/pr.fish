function pr -d "Generates a Slack Message to Link to a Jira Ticket and Pull Request"
    set -l options q/quiet c/clipboard h/help
    argparse $options -- $argv

    if set --query _flag_help
        printf "Usage: pr <JIRA_TICKET_ID|JIRA_TICKET_KEY> [OPTIONS]\n\n"
        printf "Options:\n"
        printf "  -c/--clipboard  Copy result to clipboard\n"
        printf "  -q/--quiet      Don't print anything\n"
        printf "  -h/--help       Prints help and exits\n"
        return 0
    end

    if test -z "$argv"
        set jira_issue_id (jlink -i)
        set jira_issue_md_link (jlink -m)
    else if test (echo $argv[1] | grep -o '[0-9]\{5\}')
        set jira_issue_id $argv
        set jira_issue_url (jira open $jira_issue_id -n | tr -d '\n')
        if not string match -qi "*emr*" $jira_issue_id
            set jira_issue_id EMR-$jira_issue_id
        else
            set jira_issue_id (echo $jira_issue_id | tr a-z A-Z)
        end
        set jira_issue_md_link "[$jira_issue_id]($jira_issue_url)"
    else
        printf "A Jira Ticket ID/Key must be provided as an argument or referenced in the current branch name\n\n"
        printf "Examples: \n pr 12345 \n pr EMR-12345"
        return 1
    end

    set -l gh_number_and_link (gh search prs $jira_issue_id --assignee="@me" --json=number,title,url --match=title --limit=1 | jq -r '.[0] | [.number, .url] | join(" ")')

    if string match -q " " "$gh_number_and_link"
        echo "No PR found for Jira Issue $jira_issue_id under your name"
        return 1
    end

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
