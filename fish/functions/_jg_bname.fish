function _jg_bname -d "Generates a Git branch name using a Jira Ticket ID"
    set -l options h/help q/quiet c/clipboard

    argparse $options -- $argv

    if set --query _flag_help
        printf "Usage: jg bname <JIRA_TICKET_ID|JIRA_TICKET_KEY> [OPTIONS]\n\n"
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
        printf "Examples: \n bname 12345 \n bname EMR-12345"
        return 1
    end

    if not string match -qi "*emr*" $jira_ticket_id
        set jira_ticket_id EMR-$jira_ticket_id
    else
        set jira_ticket_id (echo $jira_ticket_id | tr a-z A-Z)
    end

    set -l raw_issue_data (jira issue view $jira_ticket_id --raw)

    set -l issue_type (echo $raw_issue_data | jq -r '.fields.issuetype.name')
    set -l issue_scope_and_summary (echo $raw_issue_data | jq -r '.fields.summary' | sed 's/"//g; s/’//g; s/\'//g; s/\+/and/g; s/,//g; s/ *-> */ /g;' | head -c 110)
    set -l num_colons (echo $issue_scope_and_summary | grep -o ':' | wc -l | tr -d '[:space:]')

    if test $num_colons = 0
        set issue_scope ""
        set issue_summary (echo $issue_scope_and_summary | tr ' ' '-' | tr A-Z a-z | sed 's/(//g; s/)//g; s/\.//g;')
    else if test $num_colons = 1
        set issue_scope (echo $issue_scope_and_summary | sed 's/ *: */:/g; s/ *\/ */-/g' | cut -d ':' -f1 | tr '[:space:]' '-' | tr ':' '-' | sed 's/-$//; s/(//g; s/)//g;' | tr a-z A-Z)
        set issue_scope "$issue_scope-"
        set issue_summary (echo $issue_scope_and_summary | cut -d ':' -f2 | sed 's/ //' | tr ' ' '-' | tr A-Z a-z | sed 's/-$//;s/(//g; s/)//g; s/\.//g;')
    else if test $num_colons = 2
        set issue_scope (echo $issue_scope_and_summary | sed 's/ *: */:/g; s/ *\/ */-/g' | cut -d ':' -f1,2 | tr '[:space:]' '-' | tr ':' '-' | sed 's/-$//; s/(//g; s/)//g;' | tr a-z A-Z)
        set issue_scope "$issue_scope-"
        set issue_summary (echo $issue_scope_and_summary | cut -d ':' -f3 | sed 's/ //' | tr ' ' '-' | tr A-Z a-z | sed 's/-$//;s/(//g; s/)//g; s/\.//g;')
    else if test $num_colons = 3
        set issue_scope (echo $issue_scope_and_summary | sed 's/ *: */:/g; s/ *\/ */-/g' | cut -d ':' -f1,2,3 | tr '[:space:]' '-' | tr ':' '-' | sed 's/-$//; s/(//g; s/)//g;' | tr a-z A-Z)
        set issue_scope "$issue_scope-"
        set issue_summary (echo $issue_scope_and_summary | cut -d ':' -f4 | sed 's/ //' | tr ' ' '-' | tr A-Z a-z | sed 's/-$//;s/(//g; s/)//g; s/\.//g;')
    else
        echo "Cannot parse Jira Issue with more than 3 scopes"
    end

    set -l logging_prefix "Copied Git Branch Name to Clipboard: "
    if test $issue_type = Story
        set -l branch_name "feat/$jira_ticket_id/$issue_scope$issue_summary"
        if set -q _flag_c
            echo -n "$branch_name" | pbcopy
            if test -z "$_flag_q"
                printf "$logging_prefix\n $branch_name"
            end
        else
            echo -n "$branch_name"
        end
    else
        set -l branch_name "fix/$jira_ticket_id/$issue_scope$issue_summary"
        if set -q _flag_c
            echo -n "$branch_name" | pbcopy
            if test -z "$_flag_q"
                printf "$logging_prefix\n $branch_name"
            end
        else
            echo -n "$branch_name"
        end
    end

end
