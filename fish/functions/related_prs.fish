function related_prs -d "Finds related pull requests and copies the results to the clipboard"
    set -l options q/quiet c/clipboard h/help
    argparse $options -- $argv

    if set --query _flag_help
        printf "Usage: related_prs <JIRA_TICKET_KEY> [OPTIONS]\n\n"
        printf "Options:\n"
        printf "  -c/--clipboard  Copy result to clipboard\n"
        printf "  -q/--quiet      Don't print anything\n"
        printf "  -h/--help       Prints help and exits\n"
        return 0
    end

    set -l pr_urls (gh search prs "$argv" --assignee=@me --json=url | jq -r '.[].url')

    if test -z "$pr_urls"
        echo "No PRs found for $argv"
        return 1
    end

    set -l joined (string join "\n- " $pr_urls)
    set -l joined "- $joined"

    if set -q _flag_c
        printf $joined | pbcopy
        if test -z "$_flag_q"
            printf "Copied to Clipboard:\n$joined"
        end
    else
        printf $joined
    end
end