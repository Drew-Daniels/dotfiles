function restoredb -d "Restores database for current branch from backup"
    set -l user (whoami)
    set -l current_branch $(git branch --show-current)
    set -l db_name kipu_demo_development_$current_branch
    set -l db_backup_path $BACKUPS_DIR/$db_name.dump
    set -l jobs 14

    # exit with an error when not on main or encounters-dev branch
    if test $current_branch != main && test $current_branch != encounters-dev
        echo "Must be on main or encounters-dev branch to restore"
    end

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

end
