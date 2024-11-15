function bname -d "Generates a Git branch name using a Jira Ticket ID"
    # TODO: Get ticket id from branch name if no argument provided
    # TODO: Gracefully exit if no argument provided, and no jira ticket found using git branch name
    # TODO: Add error handling
    # TODO: Enable getting jira id from all forms:
    # - EMR-12345 (already covered)
    # - 12345 (already covered)
    # - https://kipusystems.atlassian.net/browse/EMR-17631
    # - https://kipusystems.atlassian.net/browse/EMR-17631?atlOrigin=eyJpIjoiNDg0YzVkMDE0ZTA3NDMzYmEyNmQyMDY3ZjBhNGQ5ZDMiLCJwIjoiaiJ9
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

    # refactor shared functionality with prd into separate function
    # TODO: Cut off the summary after the first n characters - would be nice to ensure that only whole words are output
    set -l jira_ticket_id $argv[1]

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
    # TODO: Add handling for when the scope(s) contain spaces, need to replace with dashes
    if test $num_colons = 2
        set issue_scope (echo $issue_scope_and_summary | tr '/' '-' | cut -d ':' -f1,2 | tr '[:space:]' '-' | sed 's/--/-/' | tr ':' '-' | tr a-z A-Z | sed 's/-$//')
        set issue_summary (echo $issue_scope_and_summary | cut -d ':' -f3 | sed 's/ //' | tr ' ' '-' | tr A-Z a-z | sed 's/(//' | sed 's/)//')
    else
        set issue_scope (echo $issue_scope_and_summary | tr '/' '-' | cut -d ':' -f1 | tr '[:space:]' '-' | sed 's/--/-/' | tr ':' '-' | tr a-z A-Z | sed 's/-$//')
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
