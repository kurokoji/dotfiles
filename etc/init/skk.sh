#!/bin/sh

curl -O https://skk-dev.github.io/dict/SKK-JISYO.L.gz
mkdir ~/.skk
gzip -d SKK-JISYO.L.gz
mv SKK-JISYO.L ~/.skk
