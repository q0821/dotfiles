#!/bin/bash

set -e

echo "🚀 開始部署 dotfiles 開發環境..."

# 1️⃣ 安裝 Homebrew（如果尚未安裝）
if ! command -v brew &> /dev/null; then
  echo "🔧 安裝 Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew 已安裝"
fi

# 2️⃣ 安裝必要套件（stow + zimfw + zsh 基本模組）
echo "📦 安裝 stow 與 zimfw..."
brew install stow

# 3️⃣ 建立 symlink（使用 stow 管理設定檔）
echo "🔗 建立 Zsh 設定檔 symlink..."
cd ~/dotfiles
stow zsh

echo "🔗 建立 Git 設定檔 symlink..."
stow config

# 4️⃣ 安裝 Brewfile 中的所有套件
echo "📦 執行 brew bundle 安裝所有工具..."
brew bundle --file=~/dotfiles/Brewfile

# 5️⃣ 初始化 Zim
echo "🔄 初始化 Zim 模組..."
source ~/.zshrc || true

# 6️⃣ 還原 Claude Code 配置
echo "🤖 還原 Claude Code 配置..."
if [ -d ~/dotfiles/claude/.claude ]; then
  mkdir -p ~/.claude/{agents,skills,project-types,specialized,tech-stacks}
  cp ~/dotfiles/claude/.claude/CLAUDE.md ~/.claude/ 2>/dev/null || true
  cp ~/dotfiles/claude/.claude/README.md ~/.claude/ 2>/dev/null || true
  cp ~/dotfiles/claude/.claude/settings.json ~/.claude/ 2>/dev/null || true
  rsync -a ~/dotfiles/claude/.claude/agents/ ~/.claude/agents/ 2>/dev/null || true
  rsync -a ~/dotfiles/claude/.claude/skills/ ~/.claude/skills/ 2>/dev/null || true
  rsync -a ~/dotfiles/claude/.claude/project-types/ ~/.claude/project-types/ 2>/dev/null || true
  rsync -a ~/dotfiles/claude/.claude/specialized/ ~/.claude/specialized/ 2>/dev/null || true
  rsync -a ~/dotfiles/claude/.claude/tech-stacks/ ~/.claude/tech-stacks/ 2>/dev/null || true
  echo "✅ Claude Code 配置已還原"
fi

echo ""
echo "✅ 完成！請重新啟動 Terminal 或執行：exec zsh"