function fq_rails --description "Forcefully quits rails"
    # TODO: De-hardcode path to hm
    rm /Users/drew.daniels/projects/sites/healthmatters/tmp/pids/server.pid
    ps -ef | grep rails | grep -v grep | awk '{print $2}' | xargs kill -9
    ps -ef | grep sidekiq | grep -v grep | awk '{print $2}' | xargs kill -9
end
