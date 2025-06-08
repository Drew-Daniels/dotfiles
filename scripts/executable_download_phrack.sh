#!/bin/sh

# TODO: Accept alternative file path as argument
cd ~/Downloads || exit

# TODO: Run these downloads in parallel
END=71
for ((i=1;i<=END;i++)); do
  folder_name="phrack${i}"
  tgz=$folder_name.tar.gz
  curl -LO "https://archives.phrack.org/tgz/$tgz"
  # decompress
  mkdir -p "$folder_name"
  tar -xzf "$tgz" -C $folder_name
  rm "$tgz"
done

