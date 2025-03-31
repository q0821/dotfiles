#!/bin/bash

cd ~/dotfiles || exit 1

# 記錄當前時間
NOW=$(date "+%Y-%m-%d %H:%M:%S")

# Git 操作
git add .
git commit -m "dotfiles auto backup: $NOW" >/dev/null 2>&1 || echo "⚠️ No changes to commit"
git push origin main