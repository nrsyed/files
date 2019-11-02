#!/bin/bash

FILEPATH="$1"

sudo apt install -y \
  make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
  libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils \
  tk-dev

if [ -z "$FILEPATH" ]; then
  echo "No .tar.gz archive supplied. Exiting"
  exit 1
fi

DIRNAME=$(dirname "$FILEPATH")
PYTHON_DIR="$DIRNAME"/src
mkdir -p "$PYTHON_DIR"
tar -xzvf "$FILEPATH" -C "$PYTHON_DIR"
cd "$PYTHON_DIR"
mv */* .

./configure --enable-optimizations --with-ensurepip=install
make -j$(nproc)
sudo make altinstall
