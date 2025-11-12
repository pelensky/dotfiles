# Dotfiles

This contains all my dotfille configurations (in particular my vim setup) so that I can share it across computers. Before you go diving in, please be aware that there are a few pre-requisites:

### Essential Pre-installations:

##### Oh My ZSH ([link](http://ohmyz.sh/))
```bash
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```
##### Homebrew Requirements
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
```bash
brew install tmux z git vim nvim ripgrep fzf direnv asdf
```

In the cases of Oh My ZSH, Tmux and z, you will get annoying errors if you don't have these programs installed as my config files expect them to be there. If you don't want all the extra chuff and are just after my sexy Vim setup, go ahead and grab the `.vimrc` and `.vimrc.bundle` files, install Vundler, run `:PluginInstall` and away you go!

We are also installing Git and Vim via homebrew because it makes it easier to upgrade both, and also my path (which you will be copying via the `.zshrc` file will be looking for the homebrew installations first.

This repo is designed to work with [homesick](https://github.com/technicalpickles/homesick) which handles all my symlinking for me automatically. Much of the configuration is inspired by [Thoughtbot's dotfiles](https://github.com/thoughtbot/dotfiles).

To install, first install [homesick](https://github.com/technicalpickles/homesick):

    sudo gem install homesick

Next step is to FORK this repository. Clone it to your local machine, and make sure you do a find-and-replace across the entire repo for `dan` and replace it with the name of your User folder. Then go into the .gitconfig file and make sure you change your Git username and email address to your relevant details, unless you want me taking credit for your commits :)

Now commit and push back up to your remote fork. At this point, I would advise you delete the clone on your local machine as you will be re-cloning this via `homesick` so to avoid confusion it's best to have just one version of the repo cloned locally.

Next, use the homesick command to clone this repository:

    homesick clone pelensky/dotfiles

It will ask if you want to evaluate - at this stage you do not!

## Automated Setup

To automate the setup process:

    ~/.homesick/repos/dotfiles/setup.sh

This will initialize submodules, create symlinks, and install vim plugins. Then restart your terminal.

## Manual Setup (if you prefer)

Initialize submodules:

    cd ~/.homesick/repos/dotfiles
    git submodule update --init --recursive

Create symlinks:

    homesick symlink dotfiles

Create Claude symlink:

    ln -s ~/.homesick/repos/dotfiles/home/sensitive/.claude ~/.claude

Install vim plugins:

    homesick rc dotfiles


#### iTerm Settings
Open iTerm Preferences -> Profiles -> Other Actions -> Import JSON Profiles ->
navigate to `.homesick/repos/dotfiles/home/` and select `iTermProfiles.json`

##### When making changes

## Additional Commands

**Main dotfiles:**
- `hup` - Update, commit and push all dotfiles
- `cdh` - Navigate to main dotfiles folder

**Sensitive/Claude configs:**
- `sup` - Commit and push sensitive configs
- `cds` - Navigate to sensitive configs folder
- `claude` - Navigate to ~/.claude folder
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
