function jg --argument-names cmd -d "Jira Genie"
    set -l jg_version 0.0.1

    switch "$cmd"
        case -v --version
            echo "jg version, $jg_version"
        case "" help -h --help
            printf "Usage: jg <COMMAND> [OPTIONS]\n\n"
            printf "Commands:\n"
            printf "  help    Prints help and exits\n"
            printf "  l       Copies Jira Issue Link for Current Git Branch\n"
            printf "  bname   Generates a Git branch name using a Jira Ticket ID\n"
            printf "  pr      Generates a Slack Message to Link to a Jira Ticket and Pull Request\n"
            printf "  prd     Generates a Description for a Given PR\n"
        case l
            _l $argv[2..-1]
        case bname
            _bname $argv[2..-1]
        case pr
            _pr $argv[2..-1]
        case prd
            _prd $argv[2..-1]
    end
end
