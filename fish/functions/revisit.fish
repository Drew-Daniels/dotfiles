function revisit -d "Finds related pull requests and opens them in the browser"
    set -l related_prs (related_prs $argv)
    for pr in (string split " " $related_prs)
        open $pr
    end
end
