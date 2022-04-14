#!/bin/bash

root=/mnt/win/Users/nsyed/Documents/pdf_scans/photo_albums

read -s -p "gpg password: " password
echo

for group_dir in $(ls $root); do
  group_dirpath="$root/$group_dir"

  [ -d $group_dir ] || mkdir $group_dir

  for album_dir in $(ls $group_dirpath); do
    dst_path="$group_dir/$album_dir.tar.gpg"
    tar -C "$group_dirpath" -cvf - $album_dir | gpg -c --batch --passphrase "$password" > "$dst_path"
  done
done
