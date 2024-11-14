function pr -d "Generates a Slack Message to Link to a Jira Ticket and Pull Request"
    begin
        jlink -m
        set -l jira_issue_md_link (pbpaste)

        jlink -i
        set -l jira_issue_id (pbpaste)
    end &>/dev/null

    set -l gh_link (gh search prs $jira_issue_id --assignee="@me" --json=title,url --match=title --limit=1 | jq -r '.[0].url')

    set -l message "@here PR for $jira_issue_md_link: $gh_link"

    echo -n $message | pbcopy
    echo "Copied Slack Message to Clipboard: $message"
end
