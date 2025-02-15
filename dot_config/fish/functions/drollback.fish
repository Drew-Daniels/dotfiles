function drollback -d "Rolls back last rails migration"
    bundle exec rake db:rollback
end
