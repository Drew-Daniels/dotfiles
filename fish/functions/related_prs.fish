function related_prs -d "Finds related pull requests and copies the results to the clipboard"
    set -l pr_urls (gh search prs "$argv" --assignee=@me --json=url | jq -r '.[].url')

    if test -z "$pr_urls"
        echo "No PRs found for $argv"
        return 1
    end

    set -l joined (string join "\n- " $pr_urls)
    set -l joined "- $joined"
    printf "Copied PR Links to clipboard: \n$joined\n"
    printf $joined | pbcopy
end
