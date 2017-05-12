ZSH_THEME="af-magic"

alias rake="noglob rake"

alias serve="jekyll serve"

alias record="asciinema rec"

alias tree="tree -I '.git|node_modules|bower_components'"

# Mac Helpers
alias show_hidden="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hide_hidden="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"

# Leo's commandments
alias flounce='echo "I can'\''t work under these conditions" | lolcat; sleep 1; exit'
alias hissy_fit='echo "I can'\''t work under these conditions" | lolcat; sleep 1;sudo shutdown -h now'

# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx tmux github fasd history-substring-search zsh-syntax-highlighting zsh-autosuggestions nyan)

export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

export PATH=$PATH:"/usr/local/bin:/usr/local/bin/git:/usr/local/heroku/bin:/Users/dan/.rvm/gems/ruby-2.3.1/bin:/Users/dan/.rvm/gems/ruby-2.3.1@global/bin:/Users/dan/.rvm/rubies/ruby-2.3.1/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/dan/.rvm/bin"

export MANPAGER="col -b | vim -c 'set ft=man ts=8 nomod nolist nonu' -c 'nnoremap i <nop>' -"

export EDITOR="/usr/bin/vim"

# sets vi keybinding
bindkey -v

alias cdh='cd ~/.homesick/repos/home-files/home'
alias hup='cdh && sh ~/.homesick/repos/home-files/commit.sh && source ~/.zshrc && cd - && clear'

#############
# FUNCTIONS
#############

function mygr8() {
  bin/rake db:migrate
  bin/rake db:migrate RAILS_ENV=test
}

mcd() { # creates a directory and places you in it
  mkdir -p $1
  cd $1
}

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

#Junit
export JUNIT_HOME="$HOME/java"
export PATH="$PATH:$JUNIT_HOME"
export CLASSPATH="$CLASSPATH:$JUNIT_HOME/junit-4.12.jar:$JUNIT_HOME/hamcrest-core-1.3.jar"

#Medium
export MEDIUM_USER_ID="1b122721308038dbc8b286ce6256d80efc887dd09914d4ebc7c5fbc4b6d95bae8"
export MEDIUM_INTEGRATION_TOKEN="2e70dfec4a2add03b5a588beb5288a3cf2ba6253bf686a50cb78533f688b43442"


# Config for 'z': http://jilles.me/badassify-your-terminal-and-shell/
. `brew --prefix`/etc/profile.d/z.sh
source /usr/local/share/zsh/site-functions
alias s="~/chat.txt << "

alias rubes="ruby -run -ehttpd . -p8000"
alias roigrok="ngrok -subdomain=roi 8000"

source $(brew --prefix)/share/antigen/antigen.zsh

export NVM_DIR="/Users/dan/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
