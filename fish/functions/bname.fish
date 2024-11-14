function bname -d "Generates a Git branch name using a Jira Ticket ID"
    # get the jira issue id to fetch data against
    set -l jira_ticket_id (jlink -i)
    # get issue data
    set -l raw_issue_data (jira issue view $jira_ticket_id --raw)
    # get issue type (Story, Bug)
    set -l issue_type (echo $raw_issue_data | jq -r '.fields.issuetype.name')

    if test $issue_type = Story
        echo -n "feat/$jira_ticket_id/summary-goes-here"
    else
        echo -n "fix/$jira_ticket_id/summary-goes-here"
    end

end
