# ==============================================================================
# OH MY ZSH CONFIGURATION
# ==============================================================================

export ZSH=~/.oh-my-zsh
ZSH_DISABLE_COMPFIX=true
ZSH_THEME="agnoster"
DISABLE_UPDATE_PROMPT=true
plugins=(zsh-vi-mode zsh-nvm git tmux github)

# Prevent accidental shell exit with Ctrl-D
# Setting IGNOREEOF=999 means you must press Ctrl-D 999 times consecutively to exit the shell
# This effectively disables Ctrl-D for exiting - use Ctrl-a X instead
export IGNOREEOF=999

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
export FZF_DEFAULT_COMMAND="rg --files --no-messages --hidden"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="rg --files --no-messages --hidden --only-directories"
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

export PATH="$HOME/.asdf/shims:$PATH"

# ==============================================================================
# DOTFILES MANAGEMENT
# ==============================================================================

cdh() {
  cd ~/.homesick/repos/dotfiles/home/
}

hup() {
  cdh && cd .. && git add -A . && git commit -m "Update dotfiles" && git push && cd - && source ~/.zshrc && clear
}

cds() {
  cd ~/.homesick/repos/dotfiles/home/sensitive
}

sup() {
  cds && git checkout main 2>/dev/null || git switch main 2>/dev/null || true && git add . && git commit -m "Update sensitive configs" && git push && cd - && echo "✅ Sensitive configs updated!"
}

sdup() {
  cd ~/.homesick/repos/dotfiles && git submodule update --recursive --remote && echo "✅ Submodules updated!"
}

# ==============================================================================
# GIT COMMANDS
# ==============================================================================

git() {
  local write_cmds=(add commit merge rebase revert reset pull push checkout switch)
  local cmd="$1"
  [[ "$cmd" == *"("* ]] && cmd="${cmd#*\'}" && cmd="${cmd%\'*}"

  if [[ " ${write_cmds[*]} " =~ " ${cmd} " ]]; then
    local lock_file=".git/index.lock"
    [[ -f "$lock_file" ]] && rm -f "$lock_file" 2>/dev/null
  fi

  noglob command git "$@"
}

main() {
  git checkout main && git pull origin main
}

unalias gco 2>/dev/null
gco() {
  git checkout $(git branch | fzf)
}

cherry-pick-branch() {
  local branch=$(command git branch | fzf)
  [ -n "$branch" ] && echo "Cherry-picking from main..$branch" && command git cherry-pick $(command git log --reverse --pretty=format:"%H" main.."$branch")
}

rebase() {
  local current_branch=$(git branch --show-current)
  git fetch origin main:main && git rebase main
}

# ==============================================================================
# EDITOR COMMANDS
# ==============================================================================
# PREVENT ACCIDENTAL SHELL EXIT
# ==============================================================================

# Additional protection: ignore EOF completely
setopt ignore_eof

# Prevent Ctrl+C from exiting the shell when no command is running
# This traps SIGINT and only shows a message instead of exiting
trap 'if [[ $BASH_COMMAND == "" || $BASH_COMMAND == *"zsh"* ]]; then echo -e "\nUse Ctrl-a X to exit the pane instead of Ctrl+C"; return 1; fi' INT

# ==============================================================================

vim() {
  noglob nvim "$@"
}

vi() {
  noglob nvim "$@"
}

# ==============================================================================
# DEVELOPMENT COMMANDS
# ==============================================================================

# Beads worktree navigation
bdcd() {
  local selection=$(bd worktree list --json | jq -r '.[] | "\(.name)|\(.path)"' | fzf --delimiter='|' --with-nth=1)
  [ -n "$selection" ] && cd "${selection##*|}" && echo "📂 Switched to worktree: $(basename "${selection##*|}")"
}

# Ruby/Rails
rspec() {
  (cd ~/Work/core/back-end && local specs=$(find spec -name "*.rb" -type f | fzf --multi); [ -n "$specs" ] && echo "bundle exec rspec $(echo "$specs" | tr "\n" " ")" && echo "$specs" | xargs bundle exec rspec)
}

reviews() {
  local file=$(find ~/Work/core/docs/pr-review -maxdepth 1 -name "*.md" | fzf)
  [ -n "$file" ] && $EDITOR "$file"
}

rspec:retest() {
  (cd ~/Work/core/back-end && bundle exec retest --rspec)
}

standard() {
  (cd ~/Work/core/back-end &&
    local changed_files=$(git diff --name-only --diff-filter=ACMRTUXB --relative=back-end $(git merge-base main HEAD) 2>/dev/null || git diff --name-only --diff-filter=ACMRTUXB --relative=back-end)
    if [ -n "$changed_files" ]; then
      echo "Formatting Ruby files changed on branch:"
      echo "$changed_files" | grep -E '\.rb$' | xargs bundle exec standardrb --fix
    else
      echo "No Ruby files to format"
    fi
  )
}

prettier() {
  (cd ~/Work/core/front-end &&
    local changed_files=$(git diff --name-only --diff-filter=ACMRTUXB --relative=front-end $(git merge-base main HEAD) 2>/dev/null || git diff --name-only --diff-filter=ACMRTUXB --relative=front-end)
    if [ -n "$changed_files" ]; then
      echo "Formatting changed files on branch:"
      echo "$changed_files" | grep -E '\.(ts|tsx|js|jsx|json|css|scss|md)$' | xargs yarn prettier --write
    else
      echo "No files to format"
    fi
  )
}

# Ripgrep
rgf() {
  rg --files | rg "$@"
}

sg() {
  rg --max-columns=150 --max-columns-preview -g "!*.js.map" -g "!spec/**" -g "!app/frontend/spa/**" -g "!app/assets/javascripts/vendor/**" "$@"
}

kill3000() {
  fuser -k -n tcp 3000
}

killtest() {
  pkill -f "vitest|rspec|parallel_test|spring" && echo "✓ Killed test processes" || echo "No test processes found"
}

tmux-pane() {
  tmux display-message -p "#{session_name}:#{window_index}.#{pane_index}"
}

# ==============================================================================
# FUNCTIONS
# ==============================================================================

# Open all changed files in vim
function open_changed() {
  nvim -O $(git status -s | awk '{print $2}')
}

# Run Rails migrations for dev and test
function mygr8() {
  (cd ~/Work/core/back-end && bin/rake db:migrate && RAILS_ENV=test bin/rake db:migrate)
}

# Nuclear reset development environment
function nuclear!() {
  echo "🔄 Resetting development environment..."

  # Kill specific development processes only
  echo "🛑 Killing development processes..."

  # Kill good_job processes specifically
  pkill -f "good_job.*start" && echo "  ✓ good_job killed" || echo "  No good_job processes found"

  # Kill dev server processes specifically
  pkill -f "bin/run-dev" && echo "  ✓ dev server killed" || echo "  No dev server processes found"

  # Kill Rails server processes by targeting the specific port/pid file approach
  if [ -f ~/Work/core/back-end/tmp/pids/server.pid ]; then
    local server_pid=$(cat ~/Work/core/back-end/tmp/pids/server.pid 2>/dev/null)
    if [ -n "$server_pid" ] && kill -0 "$server_pid" 2>/dev/null; then
      kill "$server_pid" && echo "  ✓ Rails server (PID $server_pid) killed" || echo "  Failed to kill Rails server"
    fi
    rm -f ~/Work/core/back-end/tmp/pids/server.pid && echo "  ✓ Server PID file removed"
  else
    echo "  No Rails server PID file found"
  fi

  # Kill test servers (Playwright)
  lsof -ti :5001 | xargs kill 2>/dev/null && echo "  ✓ Rails test server (5001) killed" || echo "  No test server on 5001"
  lsof -ti :5002 | xargs kill 2>/dev/null && echo "  ✓ Frontend test server (5002) killed" || echo "  No test server on 5002"

  # Kill psql processes - exclude our current shell
  pgrep -f "psql" | grep -v "^$$\$" | xargs -r kill 2>/dev/null && echo "  ✓ psql sessions killed" || echo "  No psql processes found"

  # Quit Postico if running
  osascript -e 'tell application "Postico" to quit' 2>/dev/null && echo "  ✓ Postico quit" || echo "  Postico not running"

  # Wait for all processes to fully terminate and locks to release
  echo "⏳ Waiting for processes to terminate..."
  sleep 3

  # Reset databases
  echo "💾 Resetting databases..."
  cd ~/Work/core/back-end/
  dropdb freddie_dev && echo "  ✓ freddie_dev dropped"
  dropdb freddie_test && echo "  ✓ freddie_test dropped"

  # Simple approach: just recreate the databases from scratch
  echo "  🔄 Recreating databases..."
  echo "  🔧 Loading schema and seeds..."
  bundle exec rails db:setup && echo "  ✓ db setup"

  echo "✅ Development environment reset complete!"
  echo "💡 Restart your dev server and good_job manually when ready"
}

# ==============================================================================
# ZSH-VI-MODE CONFIGURATION
# ==============================================================================

# Use Neovim as the external editor (inherits your init.lua config)
EDITOR="/opt/homebrew/bin/nvim"
VISUAL="/opt/homebrew/bin/nvim"

# Faster mode switching
KEYTIMEOUT=1

# zsh-vi-mode customizations
ZSH_VI_MODE_ENABLE_YANK_TO_CLIPBOARD=true
ZSH_VI_MODE_ESCAPE_BINDKEY=jk

# Custom mode indicators (works with agnoster theme)
function zvm_after_init() {
  # Add your custom keybindings here
  bindkey -M vicmd 'v' edit-command-line
  zvm_define_widget edit_command_line

  # Re-source FZF after zsh-vi-mode initializes to restore Ctrl-R
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}

# ==============================================================================
# TOOL INITIALIZATIONS
# ==============================================================================


# z - jump around
. `brew --prefix`/etc/profile.d/z.sh

# fzf - fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_COMPLETION_TRIGGER='**'
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=header,grid --line-range :300 {}' --preview-window=right:60%:wrap"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press C-Y to copy, C-R to reload, ? to toggle preview' --color header:italic"

# tmuxinator
source ~/.homesick/repos/dotfiles/home/.tmuxinator/.tmuxinator.zsh

# direnv - automatic environment switching
eval "$(direnv hook zsh)"


# starship - prompt
eval "$(starship init zsh)"

# heroku autocomplete
HEROKU_AC_ZSH_SETUP_PATH=$HOME/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH

# zsh site functions
source /opt/homebrew/share/zsh/site-functions
# ==============================================================================
# CLAUDE CODE MODEL MANAGEMENT
# ==============================================================================

# CCM: Switch Claude models
ccm() {
  local script="${XDG_DATA_HOME:-$HOME/.local/share}/ccm/ccm.sh"

  if [[ ! -f "$script" ]]; then
    local default1="${XDG_DATA_HOME:-$HOME/.local/share}/ccm/ccm.sh"
    local default2="$HOME/.ccm/ccm.sh"
    if [[ -f "$default1" ]]; then
      script="$default1"
    elif [[ -f "$default2" ]]; then
      script="$default2"
    fi
  fi

  if [[ ! -f "$script" ]]; then
    echo "ccm error: script not found at $script" >&2
    return 1
  fi

  case "$1" in
    ""|"help"|"-h"|"--help"|"status"|"st"|"config"|"cfg")
      "$script" "$@"
      ;;
    *)
      eval "$("$script" "$@")"
      ;;
  esac
}

# CCC: Switch model and launch Claude Code
ccc() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: ccc <model> [claude-options]"
    echo ""
    echo "Examples:"
    echo "  ccc glm                              # Launch with GLM"
    return 1
  fi

  local use_pp=false
  local model=""
  local claude_args=()

  if [[ "$1" == "pp" ]]; then
    use_pp=true
    shift
    model="$1"
    shift
  else
    model="$1"
    shift
  fi

  claude_args=("$@")

  if $use_pp; then
    echo "🔄 Switching to PPINFRA $model..."
    ccm pp "$model" || return 1
  else
    echo "🔄 Switching to $model..."
    ccm "$model" || return 1
  fi

  echo ""
  echo "🚀 Launching Claude Code..."
  echo "   Model: $ANTHROPIC_MODEL"
  echo "   Base URL: ${ANTHROPIC_BASE_URL:-Default (Anthropic)}"
  echo ""

  if [[ ${#claude_args[@]} -eq 0 ]]; then
    claude
  else
    claude "${claude_args[@]}"
  fi
}
alias python=python3
alias glm='ccc glm'

# >>> ccm function begin >>>
# CCM: define a shell function that applies exports to current shell
# Ensure no alias/function clashes
unalias ccm 2>/dev/null || true
unset -f ccm 2>/dev/null || true
ccm() {
  local script="/Users/danpelensky/.local/share/ccm/ccm.sh"
  # Fallback search if the installed script was moved or XDG paths changed
  if [[ ! -f "$script" ]]; then
    local default1="${XDG_DATA_HOME:-$HOME/.local/share}/ccm/ccm.sh"
    local default2="$HOME/.ccm/ccm.sh"
    if [[ -f "$default1" ]]; then
      script="$default1"
    elif [[ -f "$default2" ]]; then
      script="$default2"
    fi
  fi
  if [[ ! -f "$script" ]]; then
    echo "ccm error: script not found at $script" >&2
    return 1
  fi

  # All commands use eval to apply environment variables
  case "$1" in
    ""|"help"|"-h"|"--help"|"status"|"st"|"config"|"cfg"|"save-account"|"switch-account"|"list-accounts"|"delete-account"|"current-account"|"debug-keychain"|"project")
      # These commands don't need eval, execute directly
      "$script" "$@"
      ;;
    *)
      # All other commands (model switching) use eval to set environment variables
      eval "$("$script" "$@")"
      ;;
  esac
}

# CCC: Claude Code Commander - switch model and launch Claude Code
# Ensure no alias/function clashes
unalias ccc 2>/dev/null || true
unset -f ccc 2>/dev/null || true
ccc() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: ccc <model> [region|variant] [claude-options]"
    echo "       ccc open <provider> [claude-options]"
    echo "       ccc <account> [claude-options]            # Switch account then launch"
    echo "       ccc <model>:<account> [claude-options]"
    echo ""
    echo "Examples:"
    echo "  ccc deepseek                              # Launch with DeepSeek"
    echo "  ccc open kimi                             # Launch with OpenRouter (kimi)"
    echo "  ccc woohelps                              # Switch to 'woohelps' account and launch"
    echo "  ccc claude:work                           # Switch to 'work' account and use Claude"
    echo "  ccc glm --dangerously-skip-permissions    # Launch GLM with options"
    echo ""
    echo "Available models:"
    echo "  Official: deepseek, glm, kimi, qwen, seed|doubao, claude, minimax"
    echo "  OpenRouter: open <provider>"
    echo "  Account:  <account> | claude:<account>"
    return 1
  fi

  local model=""
  local open_provider=""
  local region_arg=""
  local seed_variant=""

  if [[ "$1" == "open" ]]; then
    shift || true
    if [[ $# -lt 1 ]]; then
      echo "Usage: ccc open <provider> [claude-options]"
      return 1
    fi
    model="open"
    open_provider="$1"
    shift || true
  else
    model="$1"
    shift || true
  fi
  
  # Helper: known model keyword
  _is_known_model() {
    case "$1" in
      deepseek|ds|glm|glm5|kimi|kimi2|qwen|minimax|mm|seed|doubao|claude|sonnet|s|open)
        return 0 ;;
      *)
        return 1 ;;
    esac
  }

  # Configure environment via ccm
  if [[ "$model" != "open" ]] && [[ "$model" != *:* ]] && ! _is_known_model "$model" && [[ ! "$model" =~ ^- ]]; then
    # Treat as account name
    local account="$model"
    echo "🔄 Switching account to $account..."
    ccm switch-account "$account" || return 1
    ccm current-account || true
    ccm claude || return 1
  else
    if [[ "$model" == "open" ]]; then
      echo "🔄 Switching to OpenRouter ($open_provider)..."
      ccm open "$open_provider" || return 1
    else
      case "$model" in
        kimi|kimi2|qwen|glm|glm5|minimax|mm)
          if [[ "${1:-}" =~ ^(global|china|cn)$ ]]; then
            region_arg="$1"
            shift || true
          fi
          ;;
        seed|doubao)
          if [[ "${1:-}" =~ ^(doubao|glm|glm5|deepseek|ds|kimi|kimi2)$ ]]; then
            seed_variant="$1"
            shift || true
          fi
          ;;
      esac

      if [[ -n "$seed_variant" ]]; then
        echo "🔄 Switching to $model ($seed_variant)..."
        ccm "$model" "$seed_variant" || return 1
      elif [[ -n "$region_arg" ]]; then
        echo "🔄 Switching to $model ($region_arg)..."
        ccm "$model" "$region_arg" || return 1
      else
        echo "🔄 Switching to $model..."
        ccm "$model" || return 1
      fi
    fi
  fi

  # Collect additional Claude Code arguments
  local claude_args=("$@")

  echo ""
  echo "🚀 Launching Claude Code..."
  echo "   Model: $ANTHROPIC_MODEL"
  echo "   Base URL: ${ANTHROPIC_BASE_URL:-Default (Anthropic)}"
  echo ""

  # Ensure  CLI exists
  if ! type -p claude >/dev/null 2>&1; then
    echo "❌ 'claude' CLI not found. Install: npm install -g @anthropic-ai/claude-code" >&2
    return 127
  fi

  # Launch Claude Code
  if [[ ${#claude_args[@]} -eq 0 ]]; then
    exec claude
  else
    exec claude "${claude_args[@]}"
  fi
}
# <<< ccm function end <<<

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/danpelensky/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/danpelensky/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/danpelensky/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/danpelensky/google-cloud-sdk/completion.zsh.inc'; fi
alias newrelic="$(brew --prefix newrelic-cli)/bin/newrelic"

# sentry
fpath=("/Users/danpelensky/.local/share/zsh/site-functions" $fpath)
