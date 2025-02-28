function backupdb -d "Backs up the database used for current branch"
    set -l user (whoami)
    set -l current_branch (git branch --show-current)
    set -l branch_data (string split / $current_branch)
    set -l db_name $branch_data[2] || set -l db_name $branch_data[1]
    set -l full_db_name kipu_demo_development_$db_name
    set -l db_backup_path ~/backups/$full_db_name
    set -l jobs (nproc)

    echo "Deleting previous backup"
    rm -rf $db_backup_path

    echo "Backing up $current_branch database ($full_db_name) to $db_backup_path"
    pg_dump -U $user -d $full_db_name -f $db_backup_path -v --format=d --jobs=$jobs

    if test $status -eq 0
        echo "Successfully backed up $current_branch database to $db_backup_path"
    else
        echo "Failed to backup $current_branch database to $db_backup_path"
    end
end
