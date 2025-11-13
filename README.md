# Dotfiles

This contains all my dotfile configurations (in particular my vim setup) so that I can share it across computers. Before you go diving in, please be aware that there are a few pre-requisites:

This repo is designed to work with [homesick](https://github.com/technicalpickles/homesick) which handles all my symlinking for me automatically. Much of the configuration is inspired by [Thoughtbot's dotfiles](https://github.com/thoughtbot/dotfiles).

## Sensitive Files Management

This repository uses a git submodule (`home/sensitive`) for private configs that shouldn't be public:

- API keys, tokens, Claude Code credentials
- Private configurations with secrets

**Why a submodule?** Keeps sensitive data separate while maintaining version control across machines.

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

### Setting Up Your Sensitive Submodule

1. **Create a private repository** on GitHub (e.g., `your-username/sensitive-dotfiles`)
2. **Update `.gitmodules`** to point to your private repository
3. **Add your sensitive files** and the setup script will handle the rest

## Automated Setup

The setup script handles all pre-installations and configuration:

    homesick rc dotfiles

This will install all dependencies, create symlinks, and set up everything you need. Then restart your terminal.

## Personalize Your Fork

After forking, update these files with your personal info:

1. **`home/.gitconfig`** - Change name and email to yours
2. **`.gitmodules`** - Update the sensitive-dotfiles URL to your private repository
3. **Create your sensitive submodule** with private configs before running setup

Everything else uses `~` or `$HOME` and will work across different machines!

### Working with the Sensitive Submodule

The submodule works like a separate git repo:

Adding files: `cds` → add files → `git add . && git commit && git push`
Sync across computers: `sup` (pulls latest sensitive configs)

## Additional Commands

**Main dotfiles:**
- `hup` - Update, commit and push all dotfiles
- `cdh` - Navigate to main dotfiles folder

**Sensitive/Claude configs:**
- `sup` - Commit and push sensitive configs (ensures main branch tracking)
- `cds` - Navigate to sensitive configs folder
- `sdup` - Update all submodules (sync changes across computers)

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
