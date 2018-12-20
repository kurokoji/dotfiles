#!/bin/bash

DOT_DIRECTORY=$(pwd)
SPECIFY_FILES=''
EXCLUDE_FILES="Brewfile .env.fish .git .gitignore .gitmodules .DS_Store README.md LICENSE init.bash $(basename ${0})"

list=""

for f in .??* *
do
  list=$list"${f} "
done

echo $list

for f in ${EXCLUDE_FILES}
do
  list=${list/$f/}
done

for f in ${list} ${SPECIFY_FILES}
do
  # ディレクトリの場合，$HOME/.configに置く
  if [ -d ${DOT_DIRECTORY}/${f} ]; then
    ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/.config
  fi

  # dotfileの場合，$HOMEに置く
  if [ -f ${DOT_DIRECTORY}/${f} ]; then
    ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}
  fi
done

cp ./.env.fish $HOME

echo $(tput setaf 1)✔︎ Complete!!$(tput sgr0)
echo $(tput setaf 1)please set _proxy_address and _dns in ${HOME}/.env.fish$(tput sgr0)
