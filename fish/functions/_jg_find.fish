function _jg_find -d "Finds the latest GH PR for a given Jira Ticket ID or Key"
    set -l options h/help q/quiet c/clipboard

    argparse $options -- $argv

    if set --query _flag_help
        printf "Usage: jg cc <JIRA_TICKET_ID|JIRA_TICKET_KEY> [OPTIONS]\n\n"
        printf "Options:\n"
        printf "  -h/--help       Prints help and exits\n"
        printf "  -q/--quiet      Don't print anything\n"
        printf "  -c/--clipboard  Copy result to clipboard\n"
        return 0
    end

    if test -z "$_flag_c"; and set -q _flag_q
        echo "Cannot use quiet mode without copying to clipboard"
        return 1
    end

    if test -z "$argv"
        set jira_ticket_id (jg link -i)
    else if test (echo $argv[1] | grep -o '[0-9]\{5\}')
        set jira_ticket_id $argv
    else
        printf "A Jira Ticket ID/Key must be provided as an argument or referenced in the current branch name\n\n"
        printf "Examples: \n cc 12345 \n cc EMR-12345"
        return 1
    end

    if not string match -qi "*emr*" $jira_ticket_id
        set jira_ticket_id EMR-$jira_ticket_id
    else
        set jira_ticket_id (echo $jira_ticket_id | tr a-z A-Z)
    end

    set -l gh_link (gh search prs $jira_ticket_id --assignee="@me" --json=number,title,url --match=title --limit=1 | jq -r '.[0] | .url // empty')

    if string match -q "" "$gh_link"
        echo "No PR found for Jira Issue $jira_ticket_id under your name"
        return 1
    end

    set -l logging_prefix "Copied GitHub PR Link to Clipboard: "
    if set -q _flag_c
        echo -n "$gh_link" | pbcopy
        if test -z "$_flag_q"
            printf "$logging_prefix\n $gh_link"
        end
    else
        echo -n "$gh_link"
    end
end
