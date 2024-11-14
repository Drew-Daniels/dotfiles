function jlink -d "Copies Jira Issue Link for Current Git Branch"
    # TODO: Add option to return result instead of copying to the clipboard
    set -l options i/id m/markdown h/help q/quiet

    argparse $options -- $argv

    if set --query _flag_help
        printf "Usage: jlink [OPTIONS]\n\n"
        printf "Options:\n"
        printf "  -h/--help       Prints help and exits\n"
        printf "  -i/--id         Get Issue ID\n"
        printf "  -m/--markdown   Get Markdown Link\n"
        printf "  -q/--quiet      Don't print anything\n"
        return 0
    end

    # validate
    if set -q _flag_i _flag_m
        echo "Cannot specify both -i and -m"
        return 1
    end

    # parse text after first forward slash and before second forward slash and trim whitespace including newlines and put this into a local variable
    set -l jira_issue_id (git branch --show-current | cut -d / -f2- | cut -d / -f1 | tr -d '[:space:]' | tr a-z A-Z)

    if set -q _flag_i
        echo -n $jira_issue_id | pbcopy
        if test -z "$_flag_q"
            echo "Copied Jira Issue ID to Clipboard: $jira_issue_id"
        end
    else
        set -l jira_issue_link (jira open $jira_issue_id -n | tr -d '\n')
        if set -q _flag_m
            set -l jira_issue_md_link "[$jira_issue_id]($jira_issue_link)"
            echo -n $jira_issue_md_link | pbcopy
            if test -z "$_flag_q"
                echo "Copied Jira Issue Markdown Link to Clipboard: $jira_issue_md_link"
            end
        else
            echo -n $jira_issue_link | pbcopy
            if test -z "$_flag_q"
                echo "Copied Jira Issue URL to Clipboard: $jira_issue_link"
            end
        end
    end
end
