#!/bin/sh

echo ${0}

git clone https://github.com/pyenv/pyenv.git ~/.pyenv

python3=$(pyenv install -l | grep -v '[a-zA-Z]' | grep -e '\s3\.?*' | tail -1)
pyenv install $python3
pyenv global $python3
pyenv rehash

pip install --upgrade pip
pip install neovim
pip install python-language-server
