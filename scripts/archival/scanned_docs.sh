#!/bin/bash

root=/mnt/win/Users/nsyed/Documents/pdf_scans/scanned_docs
dst=scanned_docs.tar.gz.gpg

tar -C "$root" -czvf - . | gpg -c > "$dst"
