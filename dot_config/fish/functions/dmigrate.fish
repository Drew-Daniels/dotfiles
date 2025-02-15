function dmigrate -d "Runs rails migrations in Dev env"
    bundle exec rake db:migrate RAILS_ENV=development
end
