#!/bin/bash

# Install basic packages and perform basic configuration setup for
# development and productivity on a new (Debian-based) system.

sudo apt update && sudo apt -y install git htop ranger vim tmux

cd ~
git clone https://github.com/nrsyed/files.git
echo '[alias]
  glog = log --decorate --graph --all' > .gitconfig

cp -r files/vim/* ./
cp files/tmux/.tmux.conf ./

# Add tmux-resurrect. TODO: update .tmux.conf
mkdir .tmux
cd .tmux
git clone https://github.com/tmux-plugins/tmux-resurrect.git
cd ~
echo '
# tmux-resurrect
run-shell ~/.tmux/tmux-resurrect/resurrect.tmux' >> .tmux.conf
