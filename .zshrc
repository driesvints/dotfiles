# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ZSH Config - AI Full-Stack Developer Edition
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# --- [1] 环境变量 ---
export DOTFILES="$HOME/.dotfiles"
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# --- [2] NVM (Node 版本管理) ---
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"
# 自动切换到 Node 20 (由 fresh.sh 预装)
nvm use 20 > /dev/null 2>&1 || nvm use default > /dev/null 2>&1

# --- [3] 终端美化 (Starship & 插件) ---
# 必须先安装 JetBrainsMono Nerd Font 并设置为终端字体
eval "$(starship init zsh)"

# 插件加载 (确保路径与 M 芯片 Homebrew 一致)
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- [4] AI 全栈开发别名 (Aliases) ---
alias cl="claude"                     # Claude-Code 启动
alias ai="ollama run deepseek-v3"      # 本地 AI 启动
alias py="python3"
alias pip="uv pip"                     # 用 uv 替代慢速 pip
alias venv="uv venv"

# --- [5] 前端开发别名 ---
alias p="pnpm"
alias dev="pnpm dev"
alias b="pnpm build"
alias ni="pnpm install"

# --- [6] 网络与系统工具 (你要求的测速与 IP) ---
# 显示内网 IP、外网 IP 及地理位置
alias ip="echo '💻 内网 IP: ' && ipconfig getifaddr en0 && echo '🌍 外网 IP: ' && curl -s https://ipapi.co/json/ | jq -r '.ip + \" (\" + .city + \", \" + .country_name + \")\"'"
# 命令行测速
alias test-speed="speedtest-cli"
# 快速查端口占用 (例: port 3000)
alias port="lsof -i tcp:"

# --- [7] 通用快捷键 ---
alias cls="clear"
alias reload="source ~/.zshrc"
alias dot="cd $DOTFILES"

# 加载本地私密变量 (如 API Keys)
[[ -f ~/.localrc ]] && source ~/.localrc
