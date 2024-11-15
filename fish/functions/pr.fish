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

    if test -z "$argv"
        set jira_issue_id (jlink -i)
        set jira_issue_md_link (jlink -m)
    else if test (echo $argv[1] | grep -o '[0-9]\{5\}')
        # TODO: Only add EMR prefix if user did not include this already
        set jira_issue_id $argv
        set jira_issue_url (jira open $jira_issue_id -n | tr -d '\n')
        set jira_issue_md_link "[EMR-$jira_issue_id]($jira_issue_url)"
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
