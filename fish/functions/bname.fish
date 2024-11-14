function bname -d "Generates a Git branch name using a Jira Ticket ID"
    # TODO: Add error handling
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

    # refactor shared functionality with prd into separate function
    # TODO: Only add "EMR-" prefix if not passed in argument to bname
    # TODO: Cut off the summary after the first n characters - would be nice to ensure that only whole words are output
    set -l jira_ticket_id $argv[1]

    set -l raw_issue_data (jira issue view $jira_ticket_id --raw)

    set -l issue_type (echo $raw_issue_data | jq -r '.fields.issuetype.name')
    set -l issue_scope_and_summary (echo $raw_issue_data | jq -r '.fields.summary')
    set -l num_colons (echo $issue_scope_and_summary | grep -o ':' | wc -l | tr -d '[:space:]')

    # TODO: Not sure the likelihood of having more than 2 scopes, but would be good to account for this scenario too
    # if 2 colons, then there are multiple scopes
    if test $num_colons = 2
        set issue_scope (echo $issue_scope_and_summary | cut -d ':' -f1,2 | tr -d '[:space:]' | tr ':' '-' | tr a-z A-Z)
        set issue_summary (echo $issue_scope_and_summary | cut -d ':' -f3 | sed 's/ //' | tr ' ' '-' | tr A-Z a-z | sed 's/(//' | sed 's/)//')
    else
        set issue_scope (echo $issue_scope_and_summary | cut -d ':' -f1 | tr -d '[:space:]' | tr a-z A-Z)
        set issue_summary (echo $issue_scope_and_summary | cut -d ':' -f2 | sed 's/ //' | tr ' ' '-' | tr A-Z a-z | sed 's/(//' | sed 's/)//')
    end

    # TODO: This functionality of either copying or echoing to stdout is used in a bunch of these utility functions, can probably make this into a reusable function
    # TODO: Store shared string in a variable
    if test $issue_type = Story
        if set -q _flag_c
            echo -n "feat/EMR-$jira_ticket_id/$issue_scope-$issue_summary" | pbcopy
            if test -z "$_flag_q"
                echo "Copied Git Branch Name to Clipboard: feat/EMR-$jira_ticket_id/$issue_scope-$issue_summary"
            end
        else
            echo -n "feat/EMR-$jira_ticket_id/$issue_scope-$issue_summary"
        end
    else
        if set -q _flag_c
            echo -n "fix/EMR-$jira_ticket_id/$issue_scope-$issue_summary" | pbcopy
            if test -z "$_flag_q"
                echo "Copied Git Branch Name to Clipboard: fix/EMR-$jira_ticket_id/$issue_scope-$issue_summary"
            end
        else
            echo -n "fix/EMR-$jira_ticket_id/$issue_scope-$issue_summary"
        end
    end

end
