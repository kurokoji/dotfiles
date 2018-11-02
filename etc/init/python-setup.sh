#!/bin/sh

echo ${0}

python3=$(pyenv install -l | grep -v '[a-zA-Z]' | grep -e '\s3\.?*' | tail -1)
pyenv install $python3
pyenv global $python3
pyenv rehash
