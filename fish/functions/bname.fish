function bname -d "Generates a Git branch name using a Jira Ticket ID"
    # TODO: Only add "EMR-" prefix if not passed in argument to bname
    # get the jira issue id to fetch data against
    set -l jira_ticket_id $argv[1]
    # get issue data
    set -l raw_issue_data (jira issue view $jira_ticket_id --raw)
    # get issue type (Story, Bug)
    set -l issue_type (echo $raw_issue_data | jq -r '.fields.issuetype.name')
    echo $issue_type

    # get issue summary
    set -l issue_summary (echo $raw_issue_data | jq -r '.fields.summary')
    echo $issue_summary

    if test $issue_type = Story
        echo -n "feat/EMR-$jira_ticket_id/$issue_summary"
    else
        echo -n "fix/EMR-$jira_ticket_id/$issue_summary"
    end

end
