#!/usr/bin/env bash

set -e

for dir in "$MAC_MUSIC_FOLDER"/*; do
  for subdir in "$dir"/*; do
    artist_name=$(basename "$dir")
    album_name=$(basename "$subdir")

    escaped_artist_name=$(printf '%q\n' "$artist_name")
    escaped_album_name=$(printf '%q\n' "$album_name")

    cp_from_path="${MAC_MUSIC_FOLDER}/${escaped_artist_name}/${escaped_album_name}"
    cp_to_path="${RPI_MUSIC_FOLDER}/${escaped_artist_name}/${escaped_album_name}"

    if ssh "$RPI_USER@$RPI_HOSTNAME" "[ ! -d $cp_to_path ]"; then
      {
        ssh "$RPI_USER@$RPI_HOSTNAME" "mkdir -p $cp_to_path"
        scp -r "$cp_from_path" "$RPI_USER@$RPI_HOSTNAME:$cp_to_path"
      }
    fi
  done
done
