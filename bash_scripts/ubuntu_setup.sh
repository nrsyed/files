#!/bin/bash

BASICS="arp-scan bzip2 chromium-browser dropbox evince firefox gzip hplip hplip-gui redshift transmission"
MEDIA="audacity brasero browser-plugin-vlc cheese gimp inkscape lame openshot ripperx texstudio vlc vokoscreen"
DEV="arduino build-essential chromium-chromedriver cmake git octave openssh-server python-pip python3-pip virtualbox valgrind tesseract-ocr testdisk vim"
EXTRA="lm-sensors clamav clamtk flashplugin-installer gnome-tweak-tool pdfshuffler p7zip p7zip-full sqlitebrowser"

sudo apt update && sudo apt upgrade -y
sudo apt install -y $BASICS
sudo apt install -y $DEV
sudo apt install -y $MEDIA
sudo apt install -y $EXTRA

pip install virtualenv virtualenvwrapper
sudo ln -s ~/.local/bin/virtualenv /usr/local/bin/virtualenv

# TODO: 18.04 specific stuff: tweak, config and .*rc files, 
