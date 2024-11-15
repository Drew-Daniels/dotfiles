function bname -d "Generates a Git branch name using a Jira Ticket ID"
    set -l options h/help q/quiet c/clipboard

    argparse $options -- $argv

    # TODO: Update help message to include optional argument for jira ticket id/key
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

    # refactor shared functionality with prd into separate function
    # TODO: Cut off the summary after the first n characters - would be nice to ensure that only whole words are output
    if test -z "$argv"
        set jira_ticket_id (jlink -i)
    else if test (echo $argv[1] | grep -o '[0-9]\{5\}')
        set jira_ticket_id $argv
    else
        echo "A Jira Ticket Number/Key must be provided as an argument or referenced in the current branch name"
        echo "Example: bname 12345"
        return 1
    end

    if test -z "$jira_ticket_id"
        echo "A Jira Ticket Number/Key must be provided as an argument or referenced in the current branch name"
        return 1
    end

    if not string match -qi "*emr*" $jira_ticket_id
        set jira_ticket_id EMR-$jira_ticket_id
    else
        set jira_ticket_id (echo $jira_ticket_id | tr a-z A-Z)
    end

    set -l raw_issue_data (jira issue view $jira_ticket_id --raw)

    set -l issue_type (echo $raw_issue_data | jq -r '.fields.issuetype.name')
    set -l issue_scope_and_summary (echo $raw_issue_data | jq -r '.fields.summary' | sed "s/’//g")
    set -l num_colons (echo $issue_scope_and_summary | grep -o ':' | wc -l | tr -d '[:space:]')

    # TODO: Not sure the likelihood of having more than 2 scopes, but would be good to account for this scenario too
    # if 2 colons, then there are multiple scopes
    if test $num_colons = 2
        set issue_scope (echo $issue_scope_and_summary | tr '/' '-' | cut -d ':' -f1,2 | tr '[:space:]' '-' | tr ':' '-' | sed 's/--/-/g' | tr a-z A-Z | sed 's/-$//')
        set issue_summary (echo $issue_scope_and_summary | cut -d ':' -f3 | sed 's/ //' | tr ' ' '-' | tr A-Z a-z | sed 's/(//' | sed 's/)//')
    else
        set issue_scope (echo $issue_scope_and_summary | tr '/' '-' | cut -d ':' -f1 | tr '[:space:]' '-' | tr ':' '-' | sed 's/--/-/g' | tr a-z A-Z | sed 's/-$//')
        set issue_summary (echo $issue_scope_and_summary | cut -d ':' -f2 | sed 's/ //' | tr ' ' '-' | tr A-Z a-z | sed 's/(//' | sed 's/)//')
    end

    # TODO: This functionality of either copying or echoing to stdout is used in a bunch of these utility functions, can probably make this into a reusable function
    # TODO: Store shared string in a variable
    if test $issue_type = Story
        if set -q _flag_c
            echo -n "feat/$jira_ticket_id/$issue_scope-$issue_summary" | pbcopy
            if test -z "$_flag_q"
                echo "Copied Git Branch Name to Clipboard: feat/$jira_ticket_id/$issue_scope-$issue_summary"
            end
        else
            echo -n "feat/$jira_ticket_id/$issue_scope-$issue_summary"
        end
    else
        if set -q _flag_c
            echo -n "fix/$jira_ticket_id/$issue_scope-$issue_summary" | pbcopy
            if test -z "$_flag_q"
                echo "Copied Git Branch Name to Clipboard: fix/$jira_ticket_id/$issue_scope-$issue_summary"
            end
        else
            echo -n "fix/$jira_ticket_id/$issue_scope-$issue_summary"
        end
    end

end
