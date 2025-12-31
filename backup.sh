#!/bin/bash

cd ~/dotfiles || exit 1

# 執行前清理一次
~/dotfiles/utils/cleanup.sh

# 同步 ~/.claude 配置檔案
CLAUDE_BACKUP=~/dotfiles/claude/.claude
mkdir -p "$CLAUDE_BACKUP"/{agents,skills,project-types,specialized,tech-stacks}

# 複製單一檔案
cp ~/.claude/CLAUDE.md "$CLAUDE_BACKUP/" 2>/dev/null || true
cp ~/.claude/README.md "$CLAUDE_BACKUP/" 2>/dev/null || true
cp ~/.claude/settings.json "$CLAUDE_BACKUP/" 2>/dev/null || true

# 同步目錄（如果來源存在）
rsync -a --delete ~/.claude/agents/ "$CLAUDE_BACKUP/agents/" 2>/dev/null || true
rsync -a --delete ~/.claude/skills/ "$CLAUDE_BACKUP/skills/" 2>/dev/null || true
rsync -a --delete ~/.claude/project-types/ "$CLAUDE_BACKUP/project-types/" 2>/dev/null || true
rsync -a --delete ~/.claude/specialized/ "$CLAUDE_BACKUP/specialized/" 2>/dev/null || true
rsync -a --delete ~/.claude/tech-stacks/ "$CLAUDE_BACKUP/tech-stacks/" 2>/dev/null || true

# 記錄當前時間
NOW=$(date "+%Y-%m-%d %H:%M:%S")

# Git 操作
git add .
git commit -m "dotfiles auto backup: $NOW" >/dev/null 2>&1 || echo "⚠️ No changes to commit"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
git push origin "$CURRENT_BRANCH"