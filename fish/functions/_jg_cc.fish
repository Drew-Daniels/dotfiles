function _jg_cc -d "Generates a Conventional Commit Message from a Jira Issue ID/Key"
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

    set -l raw_issue_data (jira issue view $jira_ticket_id --raw)

    set -l issue_type (echo $raw_issue_data | jq -r '.fields.issuetype.name')
    set -l issue_scope_and_summary (echo $raw_issue_data | jq -r '.fields.summary' | sed -r 's/ +/ /g; s/ ,/,/g;')

    set -l num_colons (echo $issue_scope_and_summary | grep -o ':' | wc -l | tr -d '[:space:]')

    if test $num_colons = 0
        set issue_scope ""
        set issue_summary (echo $issue_scope_and_summary | sed 's/ $//;')
    else if test $num_colons = 1
        set issue_scope (echo $issue_scope_and_summary | cut -d ':' -f1 | sed 's/ $//; s/-$//;')
        set issue_scope "($issue_scope)"
        set issue_summary (echo $issue_scope_and_summary | cut -d ':' -f2 | sed 's/ //; s/ $//;')
    else if test $num_colons = 2
        set issue_scope (echo $issue_scope_and_summary | cut -d ':' -f1,2 | sed 's/:-/:/; s/-$//;')
        set issue_scope "($issue_scope)"
        set issue_summary (echo $issue_scope_and_summary | cut -d ':' -f3 | sed 's/ //; s/ $//;')
    else if test $num_colons = 3
        set issue_scope (echo $issue_scope_and_summary | sed 's/ *\/ */\//g; s/ *: */:/g;' | cut -d ':' -f1,2,3 | sed 's/:-/:/; s/-$//;')
        set issue_scope "($issue_scope)"
        set issue_summary (echo $issue_scope_and_summary | cut -d ':' -f4 | sed 's/ //; s/ $//;')
    else
        echo "Cannot parse Jira Issue with more than 2 scopes"
    end

    set -l logging_prefix "Copied GitHub PR Description to Clipboard: "
    if test $issue_type = Story
        set -l desc "feat$issue_scope: [$jira_ticket_id] $issue_summary"
        if set -q _flag_c
            echo -n "$desc" | pbcopy
            if test -z "$_flag_q"
                printf "$logging_prefix\n $desc"
            end
        else
            echo -n "$desc"
        end
    else
        set -l desc "fix$issue_scope: [$jira_ticket_id] $issue_summary"
        if set -q _flag_c
            echo -n "$desc" | pbcopy
            if test -z "$_flag_q"
                printf "$logging_prefix\n $desc"
            end
        else
            echo -n "$desc"
        end
    end
end
