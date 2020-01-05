#!/bin/bash

CPUS=$(lscpu | grep -i "^cpu(s):" | awk {'print $2'})

sudo apt update
sudo apt install -y build-essential cmake pkg-config
sudo apt install -y libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev
sudo apt install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt install -y libxvidcore-dev libx264-dev
sudo apt install -y libgtk2.0-dev libgtk-3-dev
sudo apt install -y libatlas-base-dev gfortran
sudo apt install -y python2.7-dev python3-dev

mkdir ~/envs
cd ~/envs
virtualenv -p python3 cv_env
source cv_env/bin/activate
pip install numpy

cd ~
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git
cd ~/opencv
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D INSTALL_PYTHON_EXAMPLES=ON \
  -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
  -D PYTHON_EXECUTABLE=~/envs/cv_env/bin/python \
  -D BUILD_EXAMPLES=ON \
  -D BUILD_OPENCV_PYTHON3=YES ..

make -j$CPUS
sudo make install
sudo ldconfig
