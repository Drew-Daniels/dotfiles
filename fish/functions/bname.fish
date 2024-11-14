function bname -d "Generates a Git branch name using a Jira Ticket ID"
    # TODO: Add handling to join scopes together when multiple are listed in the ticket summary (E.g, 'eRx: DrFirst: Some Summary')
    # TODO: Only add "EMR-" prefix if not passed in argument to bname
    # TODO: Cut off the summary after the first n characters - would be nice to ensure that only whole words are output
    set -l jira_ticket_id $argv[1]

    set -l raw_issue_data (jira issue view $jira_ticket_id --raw)

    set -l issue_type (echo $raw_issue_data | jq -r '.fields.issuetype.name')
    set -l issue_scope_and_summary (echo $raw_issue_data | jq -r '.fields.summary')

    set -l issue_scope (echo $issue_scope_and_summary | cut -d ':' -f1 | tr -d '[:space:]')
    set -l issue_summary (echo $issue_scope_and_summary | cut -d ':' -f2 | sed 's/ //' | tr ' ' '-' | tr A-Z a-z)

    if test $issue_type = Story
        echo -n "feat/EMR-$jira_ticket_id/$issue_scope-$issue_summary"
    else
        echo -n "fix/EMR-$jira_ticket_id/$issue_scope-$issue_summary"
    end

end
