#!/bin/sh

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

fisher install pure-fish/pure jethrokuan/fzf
