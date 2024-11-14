function prd -d "Generates a Description for a Given PR"
    # TODO: Figure out why 18858 ticket not working with this? its because of multiple scopes
    set -l options h/help q/quiet c/clipboard

    argparse $options -- $argv

    if set --query _flag_help
        printf "Usage: bname [OPTIONS]\n\n"
        printf "Options:\n"
        printf "  -h/--help       Prints help and exits\n"
        printf "  -q/--quiet      Don't print anything\n"
        printf "  -c/--clipboard  Copy result to clipboard\n"
        return 0
    end

    # validate
    if test -z "$_flag_c"; and set -q _flag_q
        echo "Cannot use quiet mode without copying to clipboard"
        return 1
    end

    # Refactor this and bname so this functionality is stripped into a separate function
    # TODO: Add options quiet, clipboard, help
    set -l jira_ticket_id $argv[1]

    set -l raw_issue_data (jira issue view $jira_ticket_id --raw)

    set -l issue_type (echo $raw_issue_data | jq -r '.fields.issuetype.name')
    set -l issue_scope_and_summary (echo $raw_issue_data | jq -r '.fields.summary')

    set -l issue_scope (echo $issue_scope_and_summary | cut -d ':' -f1 | tr -d '[:space:]')
    set -l issue_summary (echo $issue_scope_and_summary | cut -d ':' -f2 | sed 's/ //')

    # TODO: Store shared string in another variable
    if test $issue_type = Story
        if set -q _flag_c
            echo -n "feat($issue_scope): [EMR-$jira_ticket_id] $issue_summary" | pbcopy
            if test -z "$_flag_q"
                echo "Copied GitHub PR Description to Clipboard: feat($issue_scope): [EMR-$jira_ticket_id] $issue_summary"
            end
        else
            echo -n "feat($issue_scope): [EMR-$jira_ticket_id] $issue_summary"
        end
    else
        if set -q _flag_c
            echo -n "fix($issue_scope): [EMR-$jira_ticket_id] $issue_summary" | pbcopy
            if test -z "$_flag_q"
                echo "Copied GitHub PR Description to Clipboard: fix($issue_scope): [EMR-$jira_ticket_id] $issue_summary"
            end
        else
            echo -n "fix($issue_scope): [EMR-$jira_ticket_id] $issue_summary"
        end
    end
end
