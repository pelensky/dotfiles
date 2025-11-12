# Dotfiles

This contains all my dotfille configurations (in particular my vim setup) so that I can share it across computers. Before you go diving in, please be aware that there are a few pre-requisites:

This repo is designed to work with [homesick](https://github.com/technicalpickles/homesick) which handles all my symlinking for me automatically. Much of the configuration is inspired by [Thoughtbot's dotfiles](https://github.com/thoughtbot/dotfiles).

**Requirements:** The setup script will automatically install:
- Homesick (for dotfile management)
- Oh My ZSH (shell framework)
- Homebrew (package manager)
- Dev tools: git, gh, nvim, tmux, tmuxinator, ripgrep, fzf, direnv, asdf, starship, heroku, ngrok
- Shell: z, zsh-history-substring-search, zsh-nvm
- Fonts: Inconsolata Go Nerd Font
- Claude Code CLI

Next step is to FORK this repository, then clone it via homesick:

    homesick clone YOUR_GITHUB_USERNAME/dotfiles

It will ask if you want to evaluate - at this stage you do not!

## Automated Setup

The setup script handles all pre-installations and configuration:

    homesick rc dotfiles

This will install all dependencies, create symlinks, and set up everything you need. Then restart your terminal.

## Personalize Your Fork

After forking, update these files with your personal info:

1. **`home/.gitconfig`** - Change name and email to yours
2. **`.gitmodules`** - Update the sensitive-dotfiles URL to your fork (or remove if not using)

Everything else uses `~` or `$HOME` and will work across different machines!

## Additional Commands

**Main dotfiles:**
- `hup` - Update, commit and push all dotfiles
- `cdh` - Navigate to main dotfiles folder

**Sensitive/Claude configs:**
- `sup` - Commit and push sensitive configs
- `cds` - Navigate to sensitive configs folder
- `sdup` - Update submodules (sync changes across computers)

**Manual commands (if needed):**

Main dotfiles:
    homesick commit dotfiles
    homesick push dotfiles

Sensitive configurations:
    cd ~/.homesick/repos/dotfiles/home/sensitive
    git add .
    git commit -m "Update sensitive configs"
    git push

Submodule updates:
    cd ~/.homesick/repos/dotfiles
    git submodule update --recursive
