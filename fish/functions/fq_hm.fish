function fq_hm --description "Forcefully quits rails"
    # TODO: Check if file exists first before attempting to remove
    # TODO: Add logging that explains what is happening at each step
    # TODO: De-hardcode path to hm
    rm /Users/drew.daniels/projects/sites/healthmatters/tmp/pids/server.pid
    ps -ef | grep rails | grep -v grep | awk '{print $2}' | xargs kill -9
    ps -ef | grep sidekiq | grep -v grep | awk '{print $2}' | xargs kill -9
end
