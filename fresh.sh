#!/bin/sh

echo "🎬 开始构建你的 AI 全栈开发机..."

# 1. 安装 Rosetta 2 (确保 Intel 架构 App 兼容)
echo "🔧 正在安装 Rosetta 2..."
sudo softwareupdate --install-rosetta --agree-to-license

# 2. 检查并安装 Homebrew
if test ! $(which brew); then
  echo "🍺 正在安装 Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 3. 运行 Brewfile 安装所有 App 和工具
echo "📦 正在执行 Brewfile 批量安装 (请耐心等待)..."
brew update
brew tap homebrew/bundle
brew bundle --file=./Brewfile

# 4. 配置 NVM 并默认安装 Node 20
echo "🟢 正在配置 Node.js 20 环境..."
mkdir -p ~/.nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"
nvm install 20
nvm alias default 20
nvm use default

# 5. 安装 Claude-code
echo "🤖 正在全局安装 Claude-code..."
npm install -g @anthropic-ai/claude-code

# 6. 建立配置文件链接 (Symbolic Link)
echo "🔗 正在建立配置文件链接..."
rm -f $HOME/.zshrc
ln -s $HOME/.dotfiles/zshrc $HOME/.zshrc

# 7. macOS 系统手感调优
echo "⚙️ 优化 macOS 系统设置..."
# 自动隐藏 Dock
defaults write com.apple.dock autohide -bool true
# 加快窗口缩放速度
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
# 提高键盘重复频率 (写代码更爽)
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# 8. 刷新 Dock
killall Dock

echo "🎉 全部安装完成！"
echo "👉 请【重启终端】或者输入 'source ~/.zshrc' 开始使用。"
echo "👉 运行 'ip' 测试网络，运行 'claude' 登录 AI 助手。"
