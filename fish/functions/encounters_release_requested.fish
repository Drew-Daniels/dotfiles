function encounters_release_requested -d "Generates a Slack message when a release is requested"
    set -l encounters_release_requested_template $XDG_CONFIG_HOME/work/encounters_release_requested_template.md
    set -l date (date +"%m/%d")
    echo "Date: $date"
    gsed -i "s#insert-date-here#$date#g;" $encounters_release_requested_template
    # ping heartbeat url
    set -l heartbeat (curl $ENCOUNTERS_DEV_HEARTBEAT_URL)
    echo $heartbeat
    # parse qualifier from heartbeat response
    # update the date of the qualifier
    # increment the version if necessary
    # update the template

    # get a list of all the jira tickets that are in 'Dev Complete' and on our board

    # print results
    bat --paging=never $encounters_release_requested_template

    # copy to clipboard
    # pbcopy <$encounters_release_requested_template
end
