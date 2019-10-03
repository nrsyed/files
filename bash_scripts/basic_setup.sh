#!/bin/bash

# Install basic packages and perform basic configuration setup for
# development and productivity on a new (Debian-based) system.

sudo apt update && sudo apt -y install git htop ranger vim tmux

cd ~
git clone https://github.com/nrsyed/files.git
echo '[alias]
  glog = log --decorate --graph --all' > .gitconfig

cp files/vim/.vimrc ./
cp -r files/vim/.vim ./
cp files/tmux/.tmux.conf ./

# Add tmux-resurrect. TODO: update .tmux.conf
mkdir .tmux
cd .tmux
git clone https://github.com/tmux-plugins/tmux-resurrect.git
cd ~
echo '
# tmux-resurrect
run-shell ~/.tmux/tmux-resurrect/resurrect.tmux' >> ~/.tmux.conf

pip install virtualenv virtualenvwrapper
echo "
# virtualenv and virtualenvwrapper
export WORKON_HOME=~/.virtualenv
source $(find / -name virtualenvwrapper.sh 2>/dev/null)
alias lsvirtualenv='lsvirtualenv -b'" >> ~/.bashrc
