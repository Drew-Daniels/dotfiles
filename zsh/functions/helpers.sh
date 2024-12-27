# TODO: modularize
force_quit_rails() {
  ps -ef | grep "rails" | grep -v grep | awk '{print $2}' | xargs kill -2
}

force_quit_sidekiq() {
  ps -ef | grep "sidekiq" | grep -v grep | awk '{print $2}' | xargs kill -2
}

backupdb() {
  # TODO: Set default backup dirs
  # TODO: Rename BACKUP_DB_NAME env var to something else
  if [ -z "$BACKUP_DB_NAME" ]; then
    echo "BACKUP_DB_NAME is not set"
    exit 1
  fi

  if [ -z "$BACKUP_DIR" ]; then
    echo "BACKUP_DIR is not set"
    exit 1
  fi

  user=$(whoami)
  db_name=$BACKUP_DB_NAME
  current_branch=$(git branch --show-current)
  # TODO: Add error handling for more complex branch names that don't follow feat|fix/ABC-XXXXX/summary-of-changes format
  dump_file_name=$(echo "$current_branch" | tr '/' '_')
  db_backup_path="$BACKUP_DIR/$dump_file_name.dump"

  echo "Backing up $current_branch database ($db_name) to $db_backup_path"
  pg_dump -U "$user" -d "$db_name" -f "$db_backup_path" -v --format=custom

  # TODO: Verify what happens if any errors are generated during migrations - does this cause the script to indicate failure?
  if [ $? -eq 0 ]; then
    echo "Successfully backed up $current_branch database to $db_backup_path"
  else
    echo "Failed to backup $current_branch database to $db_backup_path"
  fi
}

restoredb() {
  user=$(whoami)
  db_name=$BACKUP_DB_NAME
  current_branch=$(git branch --show-current)
  # TODO: Add error handling for more complex branch names that don't follow feat|fix/ABC-XXXXX/summary-of-changes format
  dump_file_name=$(echo "$current_branch" | tr '/' '_')
  db_backup_path="$BACKUP_DIR/$dump_file_name.dump"
  jobs=$(nproc)

  if [ -f "$db_backup_path" ]; then
    echo "Dropping $db_name"
    dropdb "$db_name" -f

    echo "Creating $db_name database"
    createdb -U "$user" "$db_name"

    echo "Restoring $db_name database from $db_backup_path"

    pg_restore --verbose --clean --no-acl --no-owner -h localhost -U "$user" -d "$db_name" -j "$jobs" "$db_backup_path"

    if [ $? -eq 0 ]; then
      echo "Database ($db_name) for $current_branch restored"
    else
      echo "Database ($db_name) for $current_branch restore completed with errors"
    fi
  else
    echo "Backup for $current_branch does not exist"
  fi
}
