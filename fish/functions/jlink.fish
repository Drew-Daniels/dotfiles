function jlink -d "Copies Jira Issue Link for Current Git Branch"
    # parse text after first forward slash and before second forward slash and trim whitespace including newlines and put this into a local variable
    set -l jira_issue_id (git branch --show-current | cut -d / -f2- | cut -d / -f1 | tr -d '[:space:]')

    set -l jira_issue_link (jira open $jira_issue_id -n | tr -d '\n')

    echo -n $jira_issue_link | pbcopy

    echo "Copied URL to Clipboard: $jira_issue_link"
end
