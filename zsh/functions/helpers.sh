# TODO: modularize
force_quit_rails() {
  ps -ef | grep "rails" | grep -v grep | awk '{print $2}' | xargs kill -2
}

force_quit_sidekiq() {
  ps -ef | grep "sidekiq" | grep -v grep | awk '{print $2}' | xargs kill -2
}

backupdb() {
  if [ -z "$BACKUP_DB_NAME" ]; then
    echo "BACKUP_DB_NAME is not set - defaulting to kipu_demo_development"
    db_name="kipu_demo_development"
  else
    db_name=$BACKUP_DB_NAME
  fi

  if [ -z "$BACKUP_DIR" ]; then
    echo "BACKUP_DIR is not set - defaulting to $HOME/backups"
    db_backup_dir="$HOME/backups"
  else
    db_backup_dir=$BACKUP_DIR
  fi

  user=$(whoami)
  current_branch=$(git branch --show-current)
  # Branch name 'type/ABC-XXXXX/summary-of-changes' transforms into filename 'type_ABC-XXXXX_summary-of-changes'
  dump_file_name=$(echo "$current_branch" | tr '/' '_')
  db_backup_path="$db_backup_dir/$dump_file_name.dump"

  echo "Backing up $current_branch database ($db_name) to $db_backup_path"

  mkdir -p "$db_backup_dir"
  pg_dump -U "$user" -d "$db_name" -f "$db_backup_path" -v --format=custom

  if [ $? -eq 0 ]; then
    echo "Successfully backed up $current_branch database to $db_backup_path"
  else
    echo "Failed to backup $current_branch database to $db_backup_path"
  fi
}

restoredb() {
  if [ -z "$BACKUP_DB_NAME" ]; then
    echo "BACKUP_DB_NAME is not set - defaulting to kipu_demo_development"
    db_name="kipu_demo_development"
  else
    db_name=$BACKUP_DB_NAME
  fi

  if [ -z "$BACKUP_DIR" ]; then
    echo "BACKUP_DIR is not set - defaulting to $HOME/backups"
    db_backup_dir="$HOME/backups"
  else
    db_backup_dir=$BACKUP_DIR
  fi

  user=$(whoami)
  current_branch=$(git branch --show-current)
  # Branch name 'type/ABC-XXXXX/summary-of-changes' transforms into filename 'type_ABC-XXXXX_summary-of-changes'
  dump_file_name=$(echo "$current_branch" | tr '/' '_')
  db_backup_path="$db_backup_dir/$dump_file_name.dump"
  jobs=$(nproc)

  if [ -f "$db_backup_path" ]; then
    echo "Dropping $db_name"
    dropdb "$db_name" -f

    echo "Creating $db_name database"
    createdb -U "$user" "$db_name"

    echo "Restoring $db_name database from $db_backup_path"

    pg_restore --verbose --clean --no-acl --no-owner -h localhost -U "$user" -d "$db_name" -j "$jobs" "$db_backup_path"

    if [ $? -eq 0 ]; then
      echo "Database ($db_name) restore for $current_branch completed"
    else
      echo "Database ($db_name) restore for $current_branch completed with errors"
    fi
  else
    echo "Backup for $current_branch does not exist"
  fi
}
