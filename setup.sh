#!/bin/bash

echo "🚀 Starte Dotfiles-Setup..."

# ----------------------------
# 1. Systempakete installieren
# ----------------------------

echo "📦 Installiere grundlegende Tools..."

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

# Paketmanager-spezifisch installieren
if [[ $OS == "linux" ]]; then
  sudo apt update
  sudo apt install -y \
    zsh curl git wget tree fzf ripgrep bat \
    eza nmap whois unzip
elif [[ $OS == "mac" ]]; then
  if ! command -v brew &> /dev/null; then
    echo "🍺 Homebrew wird installiert..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  brew install \
    zsh curl git wget tree fzf ripgrep bat \
    eza neofetch nmap whois
fi

# 🔁 batcat-Fix (nur bei Debian/Kali)
if [[ $OS == "linux" && -f /usr/bin/batcat ]]; then
  echo "🛠 Alias für batcat → bat"
  echo "alias bat='batcat'" >> ~/.aliases
fi

# ----------------------------
# 2. Oh My Zsh & Plugins
# ----------------------------

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "🧠 Installiere Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "🔌 Installiere Plugins..."

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
  echo "🎨 Installiere Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
fi

# ----------------------------
# 4. Dotfiles einrichten
# ----------------------------

echo "📂 Dotfiles verlinken/kopieren..."

cp .zshrc ~/
cp .aliases ~/
cp .p10k.zsh ~/

# ----------------------------
# 5. Standard-Shell auf zsh setzen
# ----------------------------

if [[ "$SHELL" != *zsh ]]; then
  echo "🌀 Setze zsh als Standard-Shell..."
  chsh -s $(which zsh)
fi

echo "✅ Fertig! Starte dein Terminal neu oder gib 'zsh' ein."
