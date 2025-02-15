function resetdb -d "Resets local database to a back up from S3, and sets everything up for first time use"
    set -l user (whoami)
    set -l dbname $WORK_DB_NAME
    set -l s3_backup s3://$S3_BACKUP_PATH
    set -l local_backup $LOCAL_BACKUP_PATH
    set -l jobs 14

    dropdb $dbname -f

    createdb $dbname -E UTF8 -l en_US.UTF-8 -h localhost -U $user -w

    aws s3 cp $s3_backup $local_backup

    pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $USER -d $dbname -j $jobs $local_backup

    bundle exec rake db:migrate

    bundle exec rake dev:delete_db_encryption

    bundle exec rails runner ~/projects/dotfiles/scripts/work/create_super_admin.rb

    bundle exec rails runner ~/projects/dotfiles/scripts/work/create_doctor.rb

end
