#!/bin/bash

echo "🚀 Starting Dotfiles-Setup..."

# ----------------------------
# 1.  install system packages
# ----------------------------

echo "📦 Installing basic tools..."

# Plattform erkennen
OS=""
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  OS="mac"
else
  echo "❌ Unsupported OS: $OSTYPE"
  exit 1
fi

#  install with respective package manager
if [[ $OS == "linux" ]]; then
  sudo apt update
  sudo apt install -y \
    zsh curl git wget tree fzf ripgrep bat \
    eza nmap whois unzip nethogs btop lolcat fortune
elif [[ $OS == "mac" ]]; then
  if ! command -v brew &> /dev/null; then
    echo "🍺 Homebrew wird installiert..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  brew install \
    zsh curl git wget tree fzf ripgrep bat \
    eza nmap whois
fi

# ----------------------------
# 2. Oh My Zsh & Plugins
# ----------------------------

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "🧠 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "🔌 Installing Plugins..."

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

# Autosuggestions
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

# Syntax Highlighting
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

# ----------------------------
# 3. Powerlevel10k Theme
# ----------------------------

if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
  echo "🎨 Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
fi

# ----------------------------
# 4. set up dotfiles
# ----------------------------

echo "📂 Copying dotfiles "

cp .zshrc ~/
cp .aliases ~/
cp .p10k.zsh ~/
cp .banner.sh ~/

# ----------------------------
# 5.  set zsh as default shell
# ----------------------------

if [[ "$SHELL" != *zsh ]]; then
  echo "🌀 Setting zsh as default shell..."
  chsh -s $(which zsh)
fi

echo "✅ Done! Restart your terminal or type 'zsh'."
