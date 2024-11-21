function jg --argument-names cmd -d "Jira Genie"
    set -l jg_version 0.0.1

    switch "$cmd"
        case -v --version
            echo "jg version, $jg_version"
        case "" help -h --help
            _jg_help
        case link
            _jg_link $argv[2..-1]
        case bname
            _jg_bname $argv[2..-1]
        case pr
            _jg_pr $argv[2..-1]
        case cc
            _jg_cc $argv[2..-1]
        case '*'
            echo "Unknown command: $cmd"
            _jg_help
    end
end
