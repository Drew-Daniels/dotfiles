function main_release_requested -d "Generates a Slack message when a release is requested"
    set -l main_release_requested_template ~/projects/dotfiles/work/main_release_requested_template.md
    set -l tmp_file $PWD/tmp/main_release_requested_template.md

    # Get list of issues that will be deployed in the next release
    set -l issue_keys (jira issue list --status="Dev Complete" --plain -q="pod = 'Core'" --columns=key --no-headers | tr '\n' ',' | sed 's/,$//g;')
    if [ -z $issue_keys ]
        echo "No issues are in Dev Complete. Aborting."
        return 1
    end

    # Create temp file from template
    # TODO: Use mktemp instead
    cat $main_release_requested_template >$tmp_file

    # Ping /heartbeat to get last release information
    set -l heartbeat (curl $MAIN_HEARTBEAT_URL)
    # TODO: Verify that 'core-sr' bit is consistent across deployments
    set -l heartbeat_data (string match -r '(.*)\.core-sr\.(\d\d\d\d-\d\d-\d\d)\.(\d)\.aws.*' $heartbeat | tail -n3 | tr '\n' ' ')
    set -l heartbeat_prefix (echo $heartbeat_data | cut -d ' ' -f 1)
    set -l heartbeat_date (echo $heartbeat_data | cut -d ' ' -f2)
    set -l heartbeat_version (echo $heartbeat_data | cut -d ' ' -f3-)

    # Determine what the new qualifier version should be
    set -l curr_heartbeat_date (date +'%Y-%m-%d')
    if [ $heartbeat_date != $curr_heartbeat_date ]
        set heartbeat_version 1
    else
        set heartbeat_version (expr $heartbeat_version + 1)
    end

    # Replace placeholders
    set -l short_date (date +"%m/%d")
    gsed -i -e "s#insert-short-date-here#$short_date#g; s#insert-prefix-here#$heartbeat_prefix#g; s#insert-long-date-here#$curr_heartbeat_date#g; s#insert-version-here#$heartbeat_version#g; s#insert-issue-keys-here#$issue_keys#g;" $tmp_file

    # Display
    bat --paging=never $tmp_file

    # Copy
    pbcopy <$tmp_file

    # Clean up
    rm $tmp_file
end
