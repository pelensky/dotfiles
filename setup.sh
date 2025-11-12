#!/bin/bash

# Setup script for dotfiles with private sensitive submodule
# Run this after cloning the dotfiles repo

echo "Setting up dotfiles with sensitive configs..."

# Check for homesick installation
if ! command -v homesick &> /dev/null; then
    echo "Installing homesick..."
    sudo gem install homesick
fi

# Install Oh My ZSH if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My ZSH..."
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
    echo "Oh My ZSH already installed"
fi

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for macOS Apple Silicon
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed"
fi

# Install required Homebrew packages
echo "Installing required packages..."
brew_packages=(tmux z git vim nvim ripgrep fzf direnv asdf starship zsh-history-substring-search claude-code)

for package in "${brew_packages[@]}"; do
    if brew list "$package" &> /dev/null; then
        echo "$package already installed"
    else
        echo "Installing $package..."
        brew install "$package"
    fi
done

# Install zsh-nvm plugin if not present
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-nvm" ]; then
    echo "Installing zsh-nvm plugin..."
    git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
else
    echo "zsh-nvm plugin already installed"
fi

# Initialize submodules
echo "Initializing submodules..."
cd ~/.homesick/repos/dotfiles
git submodule update --init --recursive

# Create symlinks for main dotfiles
echo "Creating symlinks for main dotfiles..."
homesick symlink dotfiles

# Create symlink for Claude configs
echo "Creating symlink for Claude configs..."
if [ -d ~/.homesick/repos/dotfiles/home/sensitive/.claude ]; then
    ln -sf ~/.homesick/repos/dotfiles/home/sensitive/.claude ~/.claude
    echo "Claude symlink created"
else
    echo "Warning: Sensitive submodule not found - Claude configs not linked"
fi

# Run vim setup
echo "Installing vim plugins..."
homesick rc dotfiles

echo ""
echo "Setup complete!"
echo ""
echo "Available commands:"
echo "  hup    - Update main dotfiles"
echo "  sup    - Update sensitive configs"
echo "  sdup   - Update submodules"
echo "  cdh    - Go to main dotfiles"
echo "  cds    - Go to sensitive configs"
echo ""
echo "To commit sensitive configs: cds → git add . → git commit → git push"