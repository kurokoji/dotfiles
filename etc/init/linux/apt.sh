#!/bin/sh

sudo -E apt update
sudo -E apt install dub ldc \
  git gcc make openssl libssl-dev libbz2-dev \
  libreadline-dev libsqlite3-dev zlib1g-dev
