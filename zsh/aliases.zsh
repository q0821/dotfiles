# 查詢外部ip
alias myip='curl -s ifconfig.me | tee >(pbcopy); echo'

# Git 快捷指令
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias ga='git add .'
alias gc='git commit -m'
alias gco='git checkout'

# 路徑 & 系統
alias ..='cd ..'
alias ...='cd ../..'
alias ll='eza -alh --git'        # 使用 eza 替代 ls
alias la='eza -la --git'
alias lt='eza -T --git'          # 樹狀目錄顯示
alias czsh='source ~/.zshrc'

# Git 增強
alias lg='lazygit'               # Terminal UI for git
alias gdiff='git diff --name-only --diff-filter=d | xargs bat --diff'

# 開發工具
alias cat='bat'                  # 使用 bat 替代 cat
alias find='fd'                  # 使用 fd 替代 find

# 更新相關
alias update-all='brew update && brew upgrade && brew cleanup'
alias update-dotfiles='cd ~/dotfiles && git pull && brew bundle'