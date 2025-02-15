function fq --description "Locates and forcefully kills process(es) matching the grep pattern"
    ps -ef | grep "$argv" | grep -v grep | awk '{print $2}' | xargs kill -9
end
