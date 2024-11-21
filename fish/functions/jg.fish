function jg --argument-names cmd -d "Jira Genie"
    switch "$cmd"

        case "" -h --help
            printf "Usage: jg <COMMAND>\n\n"
    end
end
