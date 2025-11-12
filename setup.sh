#!/bin/bash

# Setup script for dotfiles with private sensitive submodule
# Run this after cloning the dotfiles repo

echo "🚀 Setting up dotfiles with sensitive configs..."

# Initialize submodules
echo "📦 Initializing submodules..."
cd ~/.homesick/repos/dotfiles
git submodule update --init --recursive

# Create symlinks for main dotfiles
echo "🔗 Creating symlinks for main dotfiles..."
homesick symlink dotfiles

# Create symlink for Claude configs
echo "🤖 Creating symlink for Claude configs..."
if [ -d ~/.homesick/repos/dotfiles/home/sensitive/.claude ]; then
    ln -sf ~/.homesick/repos/dotfiles/home/sensitive/.claude ~/.claude
    echo "✅ Claude symlink created"
else
    echo "⚠️  Sensitive submodule not found - Claude configs not linked"
fi

# Run vim setup
echo "📝 Installing vim plugins..."
homesick rc dotfiles

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📋 Available commands:"
echo "  hup    - Update main dotfiles"
echo "  sup    - Update sensitive configs"
echo "  sdup   - Update submodules"
echo "  cdh    - Go to main dotfiles"
echo "  cds    - Go to sensitive configs"
echo "  claude - Go to Claude config folder"
echo ""
echo "💡 To commit sensitive configs: cds → git add . → git commit → git push"