#!/bin/sh

echo ${0}
curl https://sh.rustup.rs -sSf | sh

echo 'alacritty setup'

git clone https://github.com/jwilm/alacritty.git
cd alacritty

if [ "$(uname)" = 'Darwin' ]; then
  make app
  cp -r target/release/osx/Alacritty.app /Applications/
elif [ "$(expr substr "$(uname -s)" 1 5)" = 'Linux' ]; then
  cargo build --release
  sudo cp target/release/alacritty /usr/local/bin
  sudo desktop-file-install alacritty.desktop
  sudo update-desktop-database
fi

cd ..
rm -rf alacritty
