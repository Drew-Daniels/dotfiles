function copydb -d "Copies the database from another backup"
    set -l source_db_name $argv[1]
    set -l target_db_name $argv[2]

    if test -z $source_db_name || test -z $target_db_name
        echo "Must provide a database name to copy from and the database name to copy to"
    end

    set -l user (whoami)
    set -l current_branch $(git branch --show-current)
    set -l branch_data (string split / $current_branch)
    set -l db_name $branch_data[2] || set -l db_name $branch_data[1]
    set -l db_backup_path ~/backups/$source_db_name.dump
    set -l jobs 14

    if test -f $db_backup_path
        echo "Dropping $db_name"
        dropdb $db_name -f

        echo "Creating $db_name database"
        createdb -U $user $target_db_name

        echo "Restoring $db_name database from $db_backup_path"

        pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $user -d $target_db_name -j $jobs $db_backup_path

        if test $status -eq 0
            echo "Database ($db_name) for $current_branch restored"
        else
            echo "Database ($db_name) for $current_branch restore failed"
        end
    else
        echo "Backup for $current_branch does not exist"
    end

end
