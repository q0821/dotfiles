# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi



### ----------------------------
### Zim 初始化（正確順序）
### ----------------------------
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

source ${ZIM_HOME}/init.zsh

# 延遲補完初始化，避免 Zim 產生 warning
autoload -Uz compinit
zstyle ':completion:*' menu select

### ----------------------------
### 路徑與工具設定（在 zoxide 前）
### ----------------------------
export PATH="/opt/homebrew/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && source "/usr/local/opt/nvm/nvm.sh"
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && source "/usr/local/opt/nvm/etc/bash_completion.d/nvm"

export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/development/flutter/bin:$PATH"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export GEM_HOME="$HOME/.gem"
export PATH="$GEM_HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# 關閉 Homebrew 自動更新
export HOMEBREW_NO_AUTO_UPDATE=1

# 隱藏 Homebrew 的環境提示
export HOMEBREW_NO_ENV_HINTS=1
### ----------------------------
### 其他外掛與功能（補完後載入）
### ----------------------------

# fzf keybindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)

# alias
[ -f ~/.config/zsh/aliases.zsh ] && source ~/.config/zsh/aliases.zsh

# zoxide 放在最後，避免提前呼叫 compinit
eval "$(zoxide init zsh)"

# Powerlevel10k 提示加速設定
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/hd/.lmstudio/bin"
# End of LM Studio CLI section


# Added by Antigravity
export PATH="/Users/hd/.antigravity/antigravity/bin:$PATH"
alias bash='/opt/homebrew/bin/bash'
