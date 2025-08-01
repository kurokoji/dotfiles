#!/usr/bin/env bash
set -euo pipefail

# 1. OWNER/REPO を設定
OWNER="asdf-vm"
REPO="asdf"

# 2. OS 判定 → "linux", "darwin", "windows"
UNAME_OS=$(uname | tr '[:upper:]' '[:lower:]')
case "$UNAME_OS" in
  linux*)   OS="linux" ;;
  darwin*)  OS="darwin" ;;
  msys*|mingw*|cygwin*) OS="windows" ;;
  *)        echo "Unsupported OS: $UNAME_OS" >&2; exit 1 ;;
esac

# 3. アーキテクチャ判定 → "amd64", "arm64", "386"
UNAME_ARCH=$(uname -m)
case "$UNAME_ARCH" in
  x86_64)    ARCH="amd64" ;;
  aarch64)   ARCH="arm64" ;;
  armv7*|armv6l*) ARCH="armv6" ;;  # 必要なら追記
  i386|i686) ARCH="386" ;;
  *)         echo "Unsupported ARCH: $UNAME_ARCH" >&2; exit 1 ;;
esac

# 4. GitHub API から最新リリース情報を取得し、OS と ARCH の両方でフィルタ
API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"

DOWNLOAD_URL=$(curl -sSf \
  -H "Accept: application/vnd.github.v3+json" \
  "$API_URL" \
  | jq -r --arg os "$OS" --arg arch "$ARCH" '
      .assets[]
      | select(
          (.name | test($os;  "i")) and
          (.name | test($arch;"i"))
        )
      | .browser_download_url
    ' \
  | head -n1)

if [[ -z "$DOWNLOAD_URL" ]]; then
  echo "No matching asset found for OS=$OS ARCH=$ARCH" >&2
  exit 1
fi

# 5. ダウンロード
FNAME="${DOWNLOAD_URL##*/}"
echo "Downloading $FNAME for $OS / $ARCH …"
curl -L --progress-bar -o "$FNAME" "$DOWNLOAD_URL"
echo "Done: $FNAME"

tar -zxvf $FNAME -C $HOME/.bin
rm $FNAME
