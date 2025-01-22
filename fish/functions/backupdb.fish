function backupdb -d "Backs up the database used for current branch"
    set -l user (whoami)
    set -l current_branch (git branch --show-current)
    set -l db_name kipu_demo_development_$current_branch
    set -l db_backup_path ~/backups/$db_name.dump

    # exit with an error when not on main or encounters-dev branch
    if test $current_branch != main && test $current_branch != encounters-dev
        echo "Must be on main or encounters-dev branch to backup"
    end

    echo "Backing up $current_branch database ($db_name) to $db_backup_path"
    pg_dump -U $user -d $db_name -f $db_backup_path -v --format=custom

    if test $status -eq 0
        echo "Successfully backed up $current_branch database to $db_backup_path"
    else
        echo "Failed to backup $current_branch database to $db_backup_path"
    end
end
