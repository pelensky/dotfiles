ZSH_DISABLE_COMPFIX=true
ZSH_THEME="agnoster"
DISABLE_UPDATE_PROMPT=true
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export FZF_DEFAULT_COMMAND="rg --files"

# tmuxinator
source ~/.homesick/repos/dotfiles/home/.tmuxinator/.tmuxinator.zsh

alias rake="noglob rake"

alias record="asciinema rec"

alias tree="tree -I '.git|node_modules|bower_components'"

# Mac Helpers
alias show_hidden="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hide_hidden="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"

alias kill3000="fuser -k -n tcp 3000"

# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(zsh-nvm git tmux github fasd history-substring-search)

export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.8/libexec/openjdk.jdk/Contents/Home
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

export PATH=$PATH:"/usr/local/bin:/usr/local/bin/git:/usr/local/heroku/bin:/Users/pelensky/.rvm/gems/ruby-2.3.1/bin:/Users/pelensky/.rvm/gems/ruby-2.3.1@global/bin:/Users/pelensky/.rvm/rubies/ruby-2.3.1/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/pelensky/.rvm/bin:/Users/pelensky/.local/bin"
export MANPAGER="col -b | vim -c 'set ft=man ts=8 nomod nolist nonu' -c 'nnoremap i <nop>' -"
export EDITOR="/usr/local/bin/vim"

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# sets emacs keybinding - allows Cp and Cn in terminal
bindkey -e

alias cdh='cd ~/.homesick/repos/dotfiles/home/'
alias hup='cdh && sh ~/.homesick/repos/dotfiles/commit.sh && source ~/.zshrc && cd - && clear'

#############
# FUNCTIONS
#############

function open_changed() {
  vim -O $(git status -s | awk '{print $2}')
}

function cherry_pick_branch() {
  BRANCH=${1}
  git cherry-pick $(git log --reverse --pretty=format:'%H' master..${BRANCH})
}

function mygr8() {
  bin/rake db:migrate
  bin/rake db:migrate RAILS_ENV=test
}

mcd() { # creates a directory and places you in it
  mkdir -p $1
  cd $1
}

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# Config for 'z': http://jilles.me/badassify-your-terminal-and-shell/
. `brew --prefix`/etc/profile.d/z.sh
source /usr/local/share/zsh/site-functions
alias s="~/chat.txt << "

alias rubes="ruby -run -ehttpd . -p8000"
alias roigrok="ngrok -subdomain=roi 8000"

# added by travis gem
[ -f /Users/pelensky/.travis/travis.sh ] && source /Users/pelensky/.travis/travis.sh
 alias tmux="TERM=screen-256color-bce tmux"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"

export LOCO2_USER=danp

export PATH="/usr/local/opt/postgresql@14/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@14/bin:$PATH"

prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
  fi
}

# added by travis gem
[ -f /Users/pelensky/.travis/travis.sh ] && source /Users/pelensky/.travis/travis.sh
export PATH="/usr/local/opt/terraform@0.12/bin:$PATH"

eval "$(direnv hook zsh)"

# rbenv
eval "$(rbenv init - zsh)"

# ffi - to fix 2.7.1 issues
export LDFLAGS="-L/opt/homebrew/opt/libffi/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libffi/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libffi/lib/pkgconfig"

# Chromium - to fix M1 yarn issues with puppeteer
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`
export PATH="/opt/homebrew/opt/terraform@0.12/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export THOR_MERGE="code -d $1 $2"

# Android Paste
alias ap="pbpaste | xargs adb shell input text"

# ripgrep
alias rgf='rg --files | rg'

# neovim
alias vim="nvim"
alias vi="nvim"
alias oldvim="vim"

# python
alias python="python3"
alias pip="pip3"
