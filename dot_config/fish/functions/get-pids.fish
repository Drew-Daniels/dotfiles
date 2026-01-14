function get-pids --description "Locates process(es) matching the grep pattern"
    ps -ef | grep "$argv" | grep -v grep | awk '{print $2}'
end
