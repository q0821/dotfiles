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
alias ll='ls -alh'
alias czsh='source ~/.zshrc'

# 更新相關
alias update-all='brew update && brew upgrade && brew cleanup'