#!/bin/sh

set -eu

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <firefox-profile-path>" >&2
  exit 1
fi

PROFILE_PATH=$1

if [ ! -d "$PROFILE_PATH" ]; then
  echo "Firefox profile directory does not exist: $PROFILE_PATH" >&2
  exit 1
fi

SCRIPT_DIRECTORY=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DOT_DIRECTORY=$(dirname -- "$SCRIPT_DIRECTORY")
SOURCE_PATH="${DOT_DIRECTORY}/userChrome.css"
CHROME_DIRECTORY="${PROFILE_PATH}/chrome"
LINK_PATH="${CHROME_DIRECTORY}/userChrome.css"

mkdir -p -- "$CHROME_DIRECTORY"

if [ -L "$LINK_PATH" ]; then
  rm -- "$LINK_PATH"
elif [ -e "$LINK_PATH" ]; then
  echo "Refusing to overwrite an existing file: $LINK_PATH" >&2
  exit 1
fi

ln -snfv -- "$SOURCE_PATH" "$LINK_PATH"

echo "Complete!!"
