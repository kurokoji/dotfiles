#!/bin/bash

echo ${0}

if [ "$(uname)" = 'Darwin' ]; then
  for f in ./etc/init/osx/*.sh
  do
    sh ${f}
  done
elif [ "$(expr substr "$(uname -s)" 1 5)" = 'Linux' ]; then
  for f in ./etc/init/linux/*.sh
  do
    sh ${f}
  done

  # WSL2
  if [[ "$(uname -r)" == *microsoft* ]]; then
    for f in ./etc/init/wsl/*.sh
    do
      sh ${f}
    done
  fi
fi

for f in ./etc/init/*.sh
do
  sh ${f}
done
