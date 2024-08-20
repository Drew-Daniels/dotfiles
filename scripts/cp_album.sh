#!/usr/bin/env bash

set -e

[ -z "$1" ] && {
  echo "Usage: $0 <album>"
  exit 1
}

ESCAPED_ALBUM_NAME=$(echo "$1" | sed 's/ /\\ /g')

echo "Copying $ESCAPED_ALBUM_NAME"

if ssh "$RPI_USER@$RPI_HOSTNAME" "[ ! -d $RPI_MUSIC_FOLDER/$ESCAPED_ALBUM_NAME ]"; then
  {
    echo "Copying: $MAC_MUSIC_FOLDER/$ESCAPED_ALBUM_NAME"
    echo "To: $RPI_MUSIC_FOLDER/$ESCAPED_ALBUM_NAME"
    scp -r "$MAC_MUSIC_FOLDER/$1" "$RPI_USER@$RPI_HOSTNAME:$RPI_MUSIC_FOLDER/$1"
  }
fi
