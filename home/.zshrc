# ==============================================================================
# OH MY ZSH CONFIGURATION
# ==============================================================================

export ZSH=~/.oh-my-zsh
ZSH_DISABLE_COMPFIX=true
ZSH_THEME="agnoster"
DISABLE_UPDATE_PROMPT=true
plugins=(zsh-nvm git tmux github)

source $ZSH/oh-my-zsh.sh
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# Custom prompt (hide user@hostname)
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
  fi
}

# ==============================================================================
# ENVIRONMENT VARIABLES
# ==============================================================================

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export TERM="xterm-256color"
export EDITOR="/opt/homebrew/bin/nvim"
export MANPAGER="col -b | vim -c 'set ft=man ts=8 nomod nolist nonu' -c 'nnoremap i <nop>' -"

# Tool configurations
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export FZF_DEFAULT_COMMAND="rg --files"
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export PNPM_HOME="$HOME/Library/pnpm"

# ==============================================================================
# PATH CONFIGURATION
# ==============================================================================

export PATH="$PATH:/usr/local/bin:/usr/local/bin/git:/usr/local/heroku/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$HOME/.local/bin"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ==============================================================================
# ALIASES - DOTFILES MANAGEMENT
# ==============================================================================

alias cdh='cd ~/.homesick/repos/dotfiles/home/'
alias hup='cdh && cd .. && git add -A . && git commit -m "Update dotfiles" && git push && cd - && source ~/.zshrc && clear'

# Sensitive/Claude dotfiles
alias cds='cd ~/.homesick/repos/dotfiles/home/sensitive'
alias sup='cds && git add . && git commit -m "Update sensitive configs" && git push && cd - && echo "✅ Sensitive configs updated!"'
alias sdup='cd ~/.homesick/repos/dotfiles && git submodule update --recursive --remote && echo "✅ Submodules updated!"'

# ==============================================================================
# ALIASES - GIT
# ==============================================================================

alias git="noglob git"
alias main='git checkout main && git pull origin main'
alias gco='git checkout $(git branch | fzf)'
alias cherry_pick_branch='f() { local branch=$(command git branch | fzf); [ -n "$branch" ] && echo "Cherry-picking from main..$branch" && command git cherry-pick $(command git log --reverse --pretty=format="%H" main.."$branch"); }; f'
alias rebase='f() { local current_branch=$(git branch --show-current); git fetch origin main:main && git rebase main; }; f'

# ==============================================================================
# ALIASES - EDITOR
# ==============================================================================

alias vim="noglob nvim"
alias vi="noglob nvim"

# ==============================================================================
# ALIASES - DEVELOPMENT
# ==============================================================================

# Ruby/Rails
alias rspec='f() { local specs=$(find spec -name "*.rb" -type f | fzf --multi); [ -n "$specs" ] && echo "bundle exec rspec $(echo "$specs" | tr "\n" " ")" && echo "$specs" | xargs bundle exec rspec; }; f'
alias standard='(cd ~/Work/core/back-end && bundle exec standardrb --format progress)'

# Ripgrep
alias rgf='rg --files | rg'
alias sg='rg --max-columns=150 --max-columns-preview -g "!*.js.map" -g "!spec/**" -g "!app/frontend/spa/**" -g "!app/assets/javascripts/vendor/**"'

# Process management
alias kill3000="fuser -k -n tcp 3000"
alias killtest='pkill -f "vitest|rspec|parallel_test|spring" && echo "✓ Killed test processes" || echo "No test processes found"'

# ==============================================================================
# ALIASES - UTILITIES
# ==============================================================================

# Tmux
alias tmux-pane="tmux display-message -p \"#{session_name}:#{window_index}.#{pane_index}\""

# ==============================================================================
# FUNCTIONS
# ==============================================================================

# Open all changed files in vim
function open_changed() {
  nvim -O $(git status -s | awk '{print $2}')
}

# Run Rails migrations for dev and test
function mygr8() {
  bin/rake db:migrate
  bin/rake db:migrate RAILS_ENV=test
}

# ==============================================================================
# TOOL INITIALIZATIONS
# ==============================================================================

# Emacs keybindings (allows Ctrl+P and Ctrl+N in terminal)
bindkey -e

# z - jump around
. `brew --prefix`/etc/profile.d/z.sh

# fzf - fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# tmuxinator
source ~/.homesick/repos/dotfiles/home/.tmuxinator/.tmuxinator.zsh

# direnv - automatic environment switching
eval "$(direnv hook zsh)"

# asdf - version manager
. $(brew --prefix asdf)/libexec/asdf.sh

# starship - prompt
eval "$(starship init zsh)"

# heroku autocomplete
HEROKU_AC_ZSH_SETUP_PATH=$HOME/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH

# zsh site functions
source /opt/homebrew/share/zsh/site-functions
