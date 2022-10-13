#!/bin/bash

DOT_DIRECTORY=$(pwd)

config_list=""
dot_list=""

# configディレクトリ群
for f in config/*
do
  config_list=$config_list"${f} "
done

# dots
for f in dots/.??*
do
  dot_list=$dot_list"${f} "
done


for f in ${config_list}
do
  path=${DOT_DIRECTORY}/${f}

  ln -snfv ${path} ${HOME}/.config
done

for f in ${dot_list}
do
  path=${DOT_DIRECTORY}/${f}
  file_basename=$(basename ${f})

  ln -snfv ${path} ${HOME}/${file_basename}
done

ln -snfv ${DOT_DIRECTORY}/bin ${HOME}/.bin

echo $(tput setaf 1)✔︎ Complete!!$(tput sgr0)
# echo $(tput setaf 1)please set _proxy_address and _dns in ${HOME}/.env.fish$(tput sgr0)
