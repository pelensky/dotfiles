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
brew install tmux z git vim nvim ripgrep fzf direnv
```

In the cases of Oh My ZSH, Tmux and z, you will get annoying errors if you don't have these programs installed as my config files expect them to be there. If you don't want all the extra chuff and are just after my sexy Vim setup, go ahead and grab the `.vimrc` and `.vimrc.bundle` files, install Vundler, run `:PluginInstall` and away you go!

We are also installing Git and Vim via homebrew because it makes it easier to upgrade both, and also my path (which you will be copying via the `.zshrc` file will be looking for the homebrew installations first.

This repo is designed to work with [homesick](https://github.com/technicalpickles/homesick) which handles all my symlinking for me automatically. Much of the configuration is inspired by [Thoughtbot's dotfiles](https://github.com/thoughtbot/dotfiles).

To install, first install [homesick](https://github.com/technicalpickles/homesick):

    sudo gem install homesick

Next step is to FORK this repository. Clone it to your local machine, and make sure you do a find-and-replace across the entire repo for `dan` and replace it with the name of your User folder. Then go into the .gitconfig file and make sure you change your Git username and email address to your relevant details, unless you want me taking credit for your commits :)

Now commit and push back up to your remote fork. At this point, I would advise you delete the clone on your local machine as you will be re-cloning this via `homesick` so to avoid confusion it's best to have just one version of the repo cloned locally.

Next, use the homesick command to clone this repository:

    homesick clone git://github.com/pelensky/dotfiles.git

It will ask if you want to evaluate - at this stage you do not! 

you can now link its contents into your home dir:

    homesick symlink dotfiles

run the rc file to get vundler installed:

    homesick rc dotfiles

and restart your terminal.

##### Tmuxinator
```bash
gem install tmuxinator
```

#### iTerm Settings
Open iTerm Preferences -> Profiles -> Other Actions -> Import JSON Profiles ->
navigate to `.homesick/repos/dotfiles/home/` and select `iTermProfiles.json`

##### When making changes

To commit your changes:

    homesick commit dotfiles

To push:

    homesick push dotfiles

You can now use the `hup` command to update your home files and install your vim bundles automatically.
