function restoredb -d "Restores database for current branch from backup"
    set -l user (whoami)
    set -l db_name $WORK_DB_NAME
    set -l current_branch $(git branch --show-current)
    set -l db_backup_path $BACKUPS_DIR/$current_branch.dump
    set -l jobs 14

    if test -f $db_backup_path
        echo "Dropping $db_name"
        dropdb $db_name -f

        echo "Creating $db_name database"
        createdb -U $user $db_name

        echo "Restoring $db_name database from $db_backup_path"
        # psql -U $user -d $db_name -f $db_backup_path
        pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $user -d $db_name -j $jobs $db_backup_path

        if test $status -eq 0
            echo "Database ($db_name) for $current_branch restored"
        else
            echo "Database ($db_name) for $current_branch restore failed"
        end
    else
        echo "Backup for $current_branch does not exist"
    end

end
