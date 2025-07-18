function md_to_jira -d "Converts a Markdown File to Jira Issue Format"
    # TODO: Clean this up
    # Usage: md_to_jira infile.md outfile.jira
    # pandoc -f gfm -w jira -o outfile.jira infile.md
    echo "$1"
    echo "$2"
    command pandoc -f gfm -w jira -o $argv[2] $argv[1]
end
