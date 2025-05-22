#!/bin/sh
set -eu

# ① GitHub API から最新プレリリース１件を取得
json=$(curl -s 'https://api.github.com/repos/dlang-community/DCD/releases?per_page=1')

# ② OS 判定
uname_s=$(uname -s)
case "$uname_s" in
  Linux*)    pattern='linux'   ;;
  Darwin*)   pattern='osx'     ;;
  *CYGWIN*|*MINGW*|*MSYS*) pattern='windows' ;;
  *) echo "Unsupported OS: $uname_s" 1>&2; exit 1 ;;
esac

# ③ jq で対応するアセットの browser_download_url を抽出
url=$(printf '%s' "$json" | \
     jq -r --arg pat "$pattern" '
       .[0].assets[]
       | select(.name | ascii_downcase | test($pat))
       | .browser_download_url
     ' | head -n 1)

if [ -z "$url" ] || [ "$url" = "null" ]; then
  echo "Error: no matching asset for OS pattern '$pattern'" 1>&2
  exit 1
fi

# ④ wget でダウンロード
#    └ URL 末尾のファイル名を取得
filename=$(printf '%s' "$url" | sed 's:.*/::')
echo "Downloading ${filename} from ${url}..."
wget -O "$filename" "$url"

echo "Downloaded: $filename"

tar -zxvf "$filename"
mv dcd-client $HOME/.bin
mv dcd-server $HOME/.bin
rm $filename
