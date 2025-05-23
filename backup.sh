#!/bin/bash

cd ~/dotfiles || exit 1

# 執行前清理一次
~/dotfiles/utils/cleanup.sh

# 記錄當前時間
NOW=$(date "+%Y-%m-%d %H:%M:%S")

# Git 操作
git add .
git commit -m "dotfiles auto backup: $NOW" >/dev/null 2>&1 || echo "⚠️ No changes to commit"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
git push origin "$CURRENT_BRANCH"