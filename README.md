# 🛠️ HD's Dotfiles

這是我在 macOS 上使用的 Zsh 開發環境設定，包含：

- ⚡ 使用 Zim 管理 Zsh 模組
- 💻 Powerlevel10k 顯示主題
- 🚀 zoxide 快速目錄跳轉
- 🔍 fzf 模糊搜尋整合
- 🧠 alias 模組化
- 🍺 Homebrew 套件備份
- 🧼 使用 GNU stow 管理 symlink
- 💡 一鍵部署腳本 `install.sh`

---

## ✅ 安裝方式

用於全新 macOS 環境，請執行：

```bash
git clone git@github.com:q0821/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

這會完成：

1. 安裝 Homebrew（若尚未安裝）
2. 安裝 `stow`
3. 建立 `.zshrc`、`.zimrc`、`.p10k.zsh`、`.zshenv` 的 symlink
4. 安裝 `Brewfile` 中所有工具
5. 自動啟用 Zim + Powerlevel10k + zoxide + fzf 等功能

---

## 🗂️ 資料夾結構

```
dotfiles/
├── zsh/
│   ├── .zshrc         # 主設定檔
│   ├── .zimrc         # Zim 模組清單
│   ├── .p10k.zsh      # Powerlevel10k 主題設定
│   ├── .zshenv        # 提前初始化的環境變數（修正補完錯誤）
│   └── aliases.zsh    # 常用 alias 模組化管理
├── Brewfile           # Homebrew 套件清單備份
├── install.sh         # 一鍵部署腳本
├── .gitignore         # 忽略無關檔案
└── README.md          # 說明文件
```

---

## 🔧 使用工具模組

- [Zim](https://zimfw.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [fzf](https://github.com/junegunn/fzf)
- [Homebrew](https://brew.sh/)
- [GNU Stow](https://www.gnu.org/software/stow/)

---

## ✨ 常用 alias（定義於 `aliases.zsh`）

```bash
# Git 快捷鍵
gst         # git status
gl          # git pull
gp          # git push
ga          # git add .
gc          # git commit -m
gco         # git checkout

# 目錄操作
..          # cd ..
...         # cd ../..
zi          # 用 zoxide + fzf 快速跳目錄

# 系統
ll          # ls -alh
czsh        # 重新載入 .zshrc
update-all  # 一鍵更新 brew / node 等
```

---

## 🧠 常見問題

### Q: 為什麼我看到 `completion was already initialized before completion module` 的警告？
A: 已在 `.zshenv` 和 `.zshrc` 中加入修正，該警告應不再出現。若仍有出現，請確認 `zoxide` 初始化是否放在 `.zshrc` 最底部。

### Q: 可以用在 Linux 上嗎？
A: 可以，不過 Brewfile 和某些路徑需調整，建議使用另一分支如 `linux` 分支管理。

---

## 🛡 注意事項

- 機密檔案請勿加入：`.ssh/`、Token、帳密等
- `.gitignore` 已處理常見暫存檔與作業系統垃圾檔（如 `.DS_Store`, `.swp` 等）
- 建議使用 GitHub SSH 金鑰操作

---

## ☁️ 備份建議

- 搭配 GitHub 上傳管理
- 可搭配 `cron` 或 `launchd` 定期 push dotfiles
- 支援 stow 還原至任意機器（只需 symlink）

---

## 🧩 建議補充

- VS Code 設定備份（`settings.json`）
- neovim / tmux / ssh 設定一併納入
- 製作 Linux 版 dotfiles 分支（如 `dotfiles-linux`）