function ppu -d "Pretty prints a URL"
    set url $argv[1]
    echo "$url" | sed 's/?/\n/g; s/&/\n/g'
end
