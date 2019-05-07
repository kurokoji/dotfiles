#!/bin/sh

# apt repository for D
sudo -E wget https://netcologne.dl.sourceforge.net/project/d-apt/files/d-apt.list -O /etc/apt/sources.list.d/d-apt.list
sudo -E apt-get update --allow-insecure-repositories
sudo -E apt -y --allow-unauthenticated install --reinstall d-apt-keyring

sudo -E add-apt-repository -y ppa:neovim-ppa/unstable
sudo -E apt update
sudo -E apt -y install dub dmd-compiler dmd-tools \
  git gcc make openssl libssl-dev libbz2-dev \
  libreadline-dev libsqlite3-dev zlib1g-dev libffi-dev \
  neovim
