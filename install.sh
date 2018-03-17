#!/bin/sh

if [ ! -e $XDG_CONFIG_HOME ]; then
  echo please set $XDG_CONFIG_HOME
  exit 1
fi

if [ ! -e $XDG_CONFIG_HOME/nvim ]; then
  mkdir -p $XDG_CONFIG_HOME/nvim
fi

ln -s ./nvim $XDG_CONFIG_HOME/nvim

if [ ! -e $XDG_CONFIG_HOME/fish ]; then
  mkdir -p $XDG_CONFIG_HOME/fish
fi

cp -r ./fish $XDG_CONFIG_HOME/fish
