function renamedb -d "renames a postgres database"
    set old_name $argv[1]
    set new_name $argv[2]

    echo "old_name: $old_name"
    echo "new_name: $new_name"

    psql -U postgres -c "ALTER DATABASE \"$old_name\" RENAME TO \"$new_name\";"
end
