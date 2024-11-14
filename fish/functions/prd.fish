function prd -d "Generates a Description for a Given PR"
    # Refactor this and bname so this functionality is stripped into a separate function
    set -l jira_ticket_id $argv[1]

    set -l raw_issue_data (jira issue view $jira_ticket_id --raw)

    set -l issue_type (echo $raw_issue_data | jq -r '.fields.issuetype.name')
    set -l issue_scope_and_summary (echo $raw_issue_data | jq -r '.fields.summary')

    set -l issue_scope (echo $issue_scope_and_summary | cut -d ':' -f1 | tr -d '[:space:]')
    set -l issue_summary (echo $issue_scope_and_summary | cut -d ':' -f2 | sed 's/ //')

    if test $issue_type = Story
        echo -n "feat($issue_scope): [EMR-$jira_ticket_id] $issue_summary"
    else
        echo -n "fix($issue_scope): [EMR-$jira_ticket_id] $issue_summary"
    end

end
