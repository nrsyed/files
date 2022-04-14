#!/bin/bash

dirs="asus_n55s kw my_old_dell_inspiron_e1705 old_60gb_hdd old_pictures dione old_10gb_hdd old_dell_inspiron_e1705 s10_plus videos"

#tar -czvf - $dirs | gpg -c > storage.tar.gz.gpg
#export GPG_TTY=$(tty)
# NOTE: If gpg command times out, try adding `pinentry-timeout 0`
# to ~/.gnupg/gpg-agent.conf. Also run `gpgconf --kill gpg-agent` to kill
# currently running agent.

read -s -p "gpg password: " password
echo

tmp=storage.tar.pgz
dst=storage.tar.pgz.gpg

tar -I pigz -cvf $tmp $dirs
gpg -c --batch --passphrase "$password" > $dst
rm $tmp
