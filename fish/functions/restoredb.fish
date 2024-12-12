function restoredb -d "Restores database for current branch from backup"
    set -l user (whoami)
    set -l db_name $WORK_DB_NAME
    set -l current_branch $(git branch --show-current)
    set -l dump_file_name (string split -r -m 1 "/" $current_branch | tail -n 1)
    set -l db_backup_path $BACKUPS_DIR/$dump_file_name.dump
    set -l jobs 14

    if test -f $db_backup_path
        echo "Dropping $db_name"
        dropdb $db_name -f

        echo "Creating $db_name database"
        createdb -U $user $db_name

        echo "Restoring $db_name database from $db_backup_path"

        pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $user -d $db_name -j $jobs $db_backup_path

        if test $status -eq 0
            echo "Database ($db_name) for $current_branch restored"
        else
            echo "Database ($db_name) for $current_branch restore failed"
        end
    else
        echo "Backup for $current_branch does not exist"
    end

    bundle install

end
