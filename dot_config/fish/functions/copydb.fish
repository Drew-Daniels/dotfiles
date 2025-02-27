function copydb -d "Copies the database from another backup"
    set -l source_db_name $argv[1]
    set -l target_db_name $argv[2]

    if test -z $source_db_name || test -z $target_db_name
        echo "Must provide a database name to copy from and the database name to copy to"
    end

    set -l user (whoami)
    set -l current_branch $(git branch --show-current)
    set -l branch_data (string split / $current_branch)
    set -l source_db_backup_path ~/backups/$source_db_name
    set -l target_db_backup_path ~/backups/$target_db_name
    set -l jobs (nproc)

    if test -d $source_db_backup_path
        echo "Copying source backup from $source_db_backup_path to $target_db_backup_path"
        cp -R $source_db_backup_path $target_db_backup_path

        echo "Creating $target_db_name database"
        createdb -U $user $target_db_name

        echo "Restoring $target_db_name database from $target_db_backup_path"
        pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $user -d $target_db_name -j $jobs $target_db_backup_path

        if test $status -eq 0
            echo "Database ($target_db_name) for $current_branch restored"
        else
            echo "Database ($target_db_name) for $current_branch restore failed"
        end
    else
        echo "Backup for $current_branch does not exist"
    end

end
