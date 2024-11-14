function pr -d "Generates a Slack Message to Link to a Jira Ticket and Pull Request"
    jlink -m
    set -l jira_issue_md_link (pbpaste)

    jlink -i
    set -l jira_issue_id (pbpaste)

    # TODO: Figure out how to interpolate issue id into jq query
    set -l gh_link (gh search prs --assignee="@me" --json=title,url -q '.[] | select(.title | contains("17631")) | .url')

    set -l message "@here PR for $jira_issue_md_link: $gh_link"

    echo -n $message | pbcopy
    echo "Copied Slack Message to Clipboard: $message"
end
