function restoredb -d "Restores database for current branch from backup"
    set -l user (whoami)
    set -l current_branch $(git branch --show-current)
    set -l branch_data (string split / $current_branch)
    set -l db_name $branch_data[2] || set -l db_name $branch_data[1]
    set -l full_db_name kipu_demo_development_$db_name
    set -l db_backup_path ~/backups/$full_db_name
    set -l jobs (nproc)

    if test -d $db_backup_path
        echo "Dropping $full_db_name"
        dropdb $full_db_name -f

        echo "Creating $full_db_name database"
        createdb -U $user $full_db_name

        echo "Restoring $full_db_name database from $db_backup_path"

        pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $user -d $full_db_name -j $jobs $db_backup_path

        if test $status -eq 0
            echo "Database ($full_db_name) for $current_branch restored"
        else
            echo "Database ($full_db_name) for $current_branch restore failed"
        end
    else
        echo "Backup for $current_branch does not exist"
    end

end
