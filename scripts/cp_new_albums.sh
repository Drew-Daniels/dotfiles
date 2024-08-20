#!/usr/bin/env bash

# for every folder in the Mac Music directory
# check if any album in the dir is not in the RPi Music directory
# if it is not, copy it to the RPi Music directory
set -e

for dir in "$MAC_MUSIC_FOLDER"/*; do
  for subdir in "$dir"/*; do
    artist_name=$(basename "$dir")
    album_name=$(basename "$subdir")

    escaped_artist_name=$(echo "$artist_name" | sed 's/ /\\ /g')
    escaped_album_name=$(echo "$album_name" | sed 's/ /\\ /g')

    cp_from_path="${MAC_MUSIC_FOLDER}/${escaped_artist_name}/${escaped_album_name}"
    cp_to_path="${RPI_MUSIC_FOLDER}/${escaped_artist_name}/${escaped_album_name}"

    if ssh "$RPI_USER@$RPI_HOSTNAME" "[ ! -d $cp_to_path ]"; then
      {
        mkdir -p "$cp_to_path"
        echo "Copying: $cp_from_path"
      }
    fi
  done
done
