function fq_hm --description "Forcefully quits rails"
    # TODO: De-hardcode path to hm
    # TODO: Put this into a variable
    if test -e /Users/drew.daniels/projects/sites/healthmatters/tmp/pids/server.pid
        echo "Removing Rails Server PID File"
        rm /Users/drew.daniels/projects/sites/healthmatters/tmp/pids/server.pid
    end
    echo "Killing all rails processes"
    ps -ef | grep rails | grep -v grep | awk '{print $2}' | xargs kill -9
    echo "Killing all sidekiq processes"
    ps -ef | grep sidekiq | grep -v grep | awk '{print $2}' | xargs kill -9
end
