#!/bin/bash

# Setup for fresh Ubuntu 18.04 install

# TODO: dropbox
BASIC_PKGS="arp-scan bzip2 chromium-browser evince firefox geoclue-2.0 \
  guake gzip hplip hplip-gui htop libreoffice openssh-server ranger redshift \
  tmux texstudio transmission vim"
DEV_PKGS="build-essential chromium-chromedriver cmake git libopencv-dev octave \
  python-pip python3-pip virtualbox valgrind testdisk"
EXTRA_PKGS="lm-sensors clamav clamtk flashplugin-installer gnome-tweak-tool \
  pdfshuffler p7zip p7zip-full sqlitebrowser tesseract-ocr wine-stable \
  winetricks"
MEDIA_PKGS="audacity brasero browser-plugin-vlc cheese ffmpeg gimp inkscape \
  lame openshot ripperx vlc vokoscreen"

sudo add-apt-repository universe
sudo add-apt-repository multiverse
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y $BASIC_PKGS $DEV_PKGS $EXTRA_PKGS $MEDIA_PKGS

# Clone `files` repo (of config files and dotfiles).
cd $HOME
git clone https://github.com/nrsyed/files.git
cd files
git submodule update --init

# Create .gitconfig.
cd $HOME
echo '[alias]
  glog = log --decorate --graph --all' > .gitconfig
git config --global user.name 'Najam Syed'
git config --global user.email 'najam.r.syed@gmail.com'

# Symlink .vimrc and .vim directory of plugins.
ln -s $HOME/files/vim/.vimrc $HOME/.vimrc
ln -s $HOME/files/vim/.vim $HOME/.vim

# Symlink tmux config and tmux plugins.
ln -s $HOME/files/tmux/.tmux.conf $HOME/.tmux.conf
ln -s $HOME/files/tmux/.tmux $HOME/.tmux

# Symlink redshift config.
ln -s $HOME/files/redshift/redshift.conf $HOME/.config/redshift.conf

# Add redshift to geoclue.conf, as this seems to be an issue with the
# newer versions of geoclue?
geoclue_conf=/etc/geoclue/geoclue.conf
if ! grep -q "\[redshift\]" $geoclue_conf; then
  echo "
[redshift]
allowed=true
system=false
users=" | sudo tee -a $geoclue_conf > /dev/null
fi

# Enable and start redshift.
systemctl --user enable redshift
systemctl --user start redshift

# .bashrc stuff
echo "
alias duh='du -h -d 1 | sort -h'" >> $HOME/.bashrc
echo "
export GIT_EDITOR=vim" >> $HOME/.bashrc

# Turn off bell sound in bash by modifying /etc/inputrc. First check if an
# existing mode has been set and change it to `none` if so; else check if
# the correct line is commented, in which case uncomment it; else append
# the correct line to the file. These checks keep the file clean/organized.
inputrc=/etc/inputrc
if egrep -q "^set bell-style (.*)" $inputrc; then
  sudo sed -i 's/^set bell-style.*/set bell-style none/' $inputrc
elif grep -q "# set bell-style none" $inputrc; then
  sudo sed -i 's/# set bell-style none/set bell-style none/' $inputrc
else
  echo -e "\nset bell-style none" | sudo tee -a $inputrc > /dev/null
fi

# Load guake on startup.
sudo ln -s /usr/share/applications/guake.desktop /etc/xdg/autostart

# Update nautilus user dirs (lowercase rules!).
cd $HOME
rmdir Templates
rmdir Public
mv Desktop desktop
mv Downloads downloads
mv Documents documents
mv Music music
mv Pictures pictures
mv Videos videos

echo 'XDG_DESKTOP_DIR="$HOME/desktop"
XDG_DOWNLOAD_DIR="$HOME/downloads"
XDG_DOCUMENTS_DIR="$HOME/documents"
XDG_MUSIC_DIR="$HOME/music"
XDG_PICTURES_DIR="$HOME/pictures"
XDG_VIDEOS_DIR="$HOME/videos"' > $HOME/.config/user-dirs.dirs

# Install virtualenv and virtualenvwrapper.
pip install virtualenv virtualenvwrapper
echo "
# virtualenv and virtualenvwrapper
export WORKON_HOME=~/.virtualenv
export PATH=\$PATH:$HOME/.local/bin
source $(find $HOME -name virtualenvwrapper.sh 2>/dev/null)
alias lsvirtualenv='lsvirtualenv -b'" >> $HOME/.bashrc

source $HOME/.bashrc

#PY3_MINOR_VER=$(python3 -c 'import sys; print(sys.version_info[1])')
#mkvirtualenv -p python3 py3$PY3_MINOR_VER
#workon py3$PY3_MINOR_VER
#pip install numpy ipython
