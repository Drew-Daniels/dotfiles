function prd -d "Generates a Description for a Given PR"
    # TODO: Get issue id/key from current branch name
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

    if test -z "$_flag_c"; and set -q _flag_q
        echo "Cannot use quiet mode without copying to clipboard"
        return 1
    end

    # Refactor this and bname so this functionality is stripped into a separate function
    set -l jira_ticket_id $argv[1]

    if not string match -qi "*emr*" $jira_ticket_id
        set jira_ticket_id EMR-$jira_ticket_id
    else
        set jira_ticket_id (echo $jira_ticket_id | tr a-z A-Z)
    end

    set -l raw_issue_data (jira issue view $jira_ticket_id --raw)

    set -l issue_type (echo $raw_issue_data | jq -r '.fields.issuetype.name')
    set -l issue_scope_and_summary (echo $raw_issue_data | jq -r '.fields.summary')

    set -l num_colons (echo $issue_scope_and_summary | grep -o ':' | wc -l | tr -d '[:space:]')

    # TODO: Not sure the likelihood of having more than 2 scopes, but would be good to account for this scenario too
    # if 2 colons, then there are multiple scopes
    if test $num_colons = 2
        set issue_scope (echo $issue_scope_and_summary | cut -d ':' -f1,2 | tr '[:space:]' '-' | sed 's/:-/:/' | sed 's/-$//' | tr a-z A-Z)
        set issue_summary (echo $issue_scope_and_summary | cut -d ':' -f3 | sed 's/ //')
    else
        set issue_scope (echo $issue_scope_and_summary | cut -d ':' -f1 | tr '[:space:]' '-' | sed 's/-$//' | tr a-z A-Z)
        set issue_summary (echo $issue_scope_and_summary | cut -d ':' -f2 | sed 's/ //')
    end

    # TODO: Store shared string in another variable
    if test $issue_type = Story
        if set -q _flag_c
            echo -n "feat($issue_scope): [$jira_ticket_id] $issue_summary" | pbcopy
            if test -z "$_flag_q"
                echo "Copied GitHub PR Description to Clipboard: feat($issue_scope): [$jira_ticket_id] $issue_summary"
            end
        else
            echo -n "feat($issue_scope): [$jira_ticket_id] $issue_summary"
        end
    else
        if set -q _flag_c
            echo -n "fix($issue_scope): [$jira_ticket_id] $issue_summary" | pbcopy
            if test -z "$_flag_q"
                echo "Copied GitHub PR Description to Clipboard: fix($issue_scope): [$jira_ticket_id] $issue_summary"
            end
        else
            echo -n "fix($issue_scope): [$jira_ticket_id] $issue_summary"
        end
    end
end