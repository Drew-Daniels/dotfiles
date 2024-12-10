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

    # TODO: Figure out how to filter to just open PRs, or closed and merged PRs (i.e., do not include PRs that were closed but not merged)
    set -l pr_urls (gh search prs "$argv" --assignee=@me --json=url | jq -r '.[].url')

    if test -z "$pr_urls"
        echo "No PRs found for $argv"
        return 1
    end

    if set -q _flag_c
        echo $pr_urls | pbcopy
        if test -z "$_flag_q"
            printf "Copied to Clipboard:\n$pr_urls"
        end
    else
        echo $pr_urls
    end
end
