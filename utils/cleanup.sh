#!/bin/bash

# 建立暫存備份區
TRASH=~/maybe_unused
mkdir -p "$TRASH"

echo "🧹 開始搬移可能沒用的 dotfiles..."

# 清單：看起來沒作用的東西
CANDIDATES=(
  ".bashrc"
  ".bash_history"
  ".vim"
  ".viminfo"
  ".Trash"
  ".DS_Store"
  ".lesshst"
  ".wget-hsts"
  ".509342.padl"
  ".mac_cleanup_py"
  ".iboysoft-magic-menu-license-backup"
  ".ntfs-for-mac-license-backup"
  ".wp-cli"
  ".writerside"
  ".cursor"
  ".cursor-tutor"
  ".katago"
  ".keras"
  ".matplotlib"
  ".cups"
  ".reboot"
  ".shutdown"
  ".sleep"
  ".wakeup"
  ".anydesk"
)

for item in "${CANDIDATES[@]}"; do
  TARGET="$HOME/$item"
  if [ -e "$TARGET" ]; then
    mv -v "$TARGET" "$TRASH/"
  fi
done

echo "✅ 已搬移所有可能沒用的項目至：$TRASH"
echo "📦 請手動確認無誤後，可執行：rm -rf $TRASH"