#!/bin/bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# AI Full-Stack 环境一键安装脚本 (M1/M2/M3 优化版)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

echo "🚀 开始构建你的 AI 全栈开发机..."

# 1. 安装 Rosetta 2 (确保部分 Intel 架构 App 兼容)
if [[ $(uname -m) == 'arm64' ]]; then
  echo "🔧 检测到 Apple Silicon，正在安装 Rosetta 2..."
  sudo softwareupdate --install-rosetta --agree-to-license
fi

# 2. 检查并安装 Homebrew
if ! command -v brew &> /dev/null; then
  echo "🍺 正在安装 Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew 已安装，跳过。"
fi

# 【关键点】立即激活 Homebrew 环境变量，否则脚本后续无法识别 brew 命令
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 3. 运行 Brewfile
echo "📦 正在同步 Brewfile 中的 App 和工具 (请耐心等待)..."
brew update
# 确保在 .dotfiles 目录下执行
if [[ -f "./Brewfile" ]]; then
  brew bundle --file="./Brewfile"
else
  echo "❌ 错误：未找到 Brewfile，请确保你在 .dotfiles 文件夹下运行脚本。"
  exit 1
fi

# 4. 配置 NVM (Node.js 版本管理)
echo "🟢 正在配置 Node.js 20 环境..."
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"

# 临时加载 NVM 以便在脚本中使用
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"

if command -v nvm &> /dev/null; then
  nvm install 20
  nvm alias default 20
  nvm use default
else
  echo "❌ NVM 安装失败，请检查 Brewfile 是否包含 nvm。"
fi

# 5. 安装 Claude-code
if command -v npm &> /dev/null; then
  echo "🤖 正在全局安装 Claude-code..."
  npm install -g @anthropic-ai/claude-code
else
  echo "⚠️ 警告：npm 未找到，跳过 Claude-code 安装。"
fi

# 6. 建立配置文件链接 (Symbolic Link)
echo "🔗 正在建立 zshrc 链接..."
# 如果已有 .zshrc 则备份
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
ln -sf "$HOME/.dotfiles/zshrc" "$HOME/.zshrc"

# 7. macOS 系统优化
echo "⚙️ 优化 macOS 系统设置..."
defaults write com.apple.dock autohide -bool true        # 自动隐藏 Dock
defaults write NSGlobalDomain KeyRepeat -int 1          # 提高键盘重复频率
defaults write NSGlobalDomain InitialKeyRepeat -int 15  # 缩短首次重复延迟

# 8. 刷新系统配置
killall Dock &> /dev/null

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "🎉 安装完成！"
echo "👉 1. 请重启你的终端 (Warp/iTerm2)"
echo "👉 2. 运行 'source ~/.zshrc' 激活所有配置"
echo "👉 3. 运行 'ip' 测试网络状态"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
