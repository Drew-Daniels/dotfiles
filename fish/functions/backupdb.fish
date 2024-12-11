function backupdb -d "Backs up the database used for current branch"
    set -l user (whoami)
    set -l db_name $WORK_DB_NAME
    set -l current_branch $(git branch --show-current)
    set -l db_backup_path $BACKUPS_DIR/$current_branch.dump

    echo "Backing up $current_branch database ($db_name) to $db_backup_path"
    pg_dump -U $user -d $db_name -f $db_backup_path -v --format=custom

    if test $status -eq 0
        echo "Successfully backed up $current_branch database to $db_backup_path"
    else
        echo "Failed to backup $current_branch database to $db_backup_path"
    end
end
