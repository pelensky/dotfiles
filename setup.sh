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
brew_packages=(tmux z git nvim ripgrep fzf direnv asdf starship zsh-history-substring-search claude-code gh tmuxinator reattach-to-user-namespace heroku)

for package in "${brew_packages[@]}"; do
    if brew list "$package" &> /dev/null; then
        echo "$package already installed"
    else
        echo "Installing $package..."
        brew install "$package"
    fi
done

# Install fonts
echo "Installing Nerd Fonts..."
if brew list --cask font-inconsolata-go-nerd-font &> /dev/null; then
    echo "font-inconsolata-go-nerd-font already installed"
else
    echo "Installing font-inconsolata-go-nerd-font..."
    brew install --cask font-inconsolata-go-nerd-font
fi

# Install ngrok
echo "Installing ngrok..."
if brew list --cask ngrok &> /dev/null; then
    echo "ngrok already installed"
else
    echo "Installing ngrok..."
    brew install --cask ngrok
fi

# Install zsh-nvm plugin if not present
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-nvm" ]; then
    echo "Installing zsh-nvm plugin..."
    git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
else
    echo "zsh-nvm plugin already installed"
fi

# Set up fzf shell integration (keybindings and completion)
if [ ! -f "$HOME/.fzf.zsh" ]; then
    echo "Setting up fzf shell integration..."
    /opt/homebrew/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
else
    echo "fzf shell integration already installed"
fi

# Install Tmux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "Tmux Plugin Manager already installed"
fi

# Initialize submodules
echo "Initializing submodules..."
cd ~/.homesick/repos/dotfiles
git submodule update --init --recursive

# Update sensitive submodule to track main branch
echo "Updating sensitive submodule to track main branch..."
git submodule foreach 'if [ "$path" = "home/sensitive" ]; then git checkout main 2>/dev/null || git switch main 2>/dev/null || echo "Already on main branch"; fi'

# Update submodules to latest remote
echo "Updating submodules to latest versions..."
git submodule update --remote

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
echo "To update sensitive configs: sup"
echo "To commit sensitive configs: cds → git add . → git commit → git push"