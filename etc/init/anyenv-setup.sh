#!/bin/sh

echo ${0}

git clone https://github.com/anyenv/anyenv ~/.anyenv
anyenv install --init

anyenv install pyenv
anyenv install rbenv
anyenv install nodenv
