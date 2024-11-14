function bname -d "Generates a Git branch name using a Jira Ticket ID"
    # TODO: Only add "EMR-" prefix if not passed in argument to bname
    # TODO: Get the scope from whatever comes before the first ":"
    # TODO: Replace spaces in summary with dashes
    # TODO: Cut off the summary after the first n characters
    # get the jira issue id to fetch data against
    set -l jira_ticket_id $argv[1]
    # get issue data
    set -l raw_issue_data (jira issue view $jira_ticket_id --raw)
    # get issue type (Story, Bug)
    set -l issue_type (echo $raw_issue_data | jq -r '.fields.issuetype.name')
    echo $issue_type

    # get issue summary
    set -l issue_scope_and_summary (echo $raw_issue_data | jq -r '.fields.summary')
    echo $issue_scope_and_summary
    set -l issue_scope (echo $issue_scope_and_summary | cut -d ':' -f1 | tr -d '[:space:]')
    echo $issue_scope

    if test $issue_type = Story
        echo -n "feat/EMR-$jira_ticket_id/$issue_scope-"
    else
        echo -n "fix/EMR-$jira_ticket_id/$issue_scope-"
    end

end
