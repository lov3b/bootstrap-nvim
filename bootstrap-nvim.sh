#!/usr/bin/env bash

set -euo pipefail

INSTALL_LOCATION="$HOME/local/.bin/"
VERSION="v0.11.1"


echo "Installing required packages..."
sudo apt update
sudo apt install -y \
  ninja-build \
  cmake \
  git \
  build-essential \
  gettext \
  luajit

tmp="$(mktemp -d)"
trap "rm -rf $tmp" EXIT
cd "$tmp"

echo "Pulling neovim"
git clone https://github.com/neovim/neovim
cd neovim

echo "Using neovim $VERSION"
git checkout tags/$VERSION -b build-$VERSION

cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$INSTALL_LOCATION"
cmake --build build --parallel
cmake --install build
