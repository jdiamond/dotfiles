#!/bin/bash

# shellcheck disable=SC1090

# Override default tools with Homebrew.
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# Tools in my local bin override all others.
export PATH="$HOME/bin:$PATH"

# Use Vim.
export EDITOR=vim

# Create and change to new directory with one command.
md() { mkdir -p "$@" && cd "$@" || return 1; }

# Aliases.
alias ..='cd ..'
alias ll='ls -lha'
alias dr='docker run -it'
alias drr='docker run -it --rm'
alias dc='docker-compose'
alias flushdns='sudo killall -HUP mDNSResponder'

# Colors for ls.
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Case insensitive tab completion.
bind 'set completion-ignore-case on'

# Customize history.
HISTTIMEFORMAT='%F %T ' # Record timestamps.
HISTCONTROL=ignoreboth  # Ignore duplicate commands and commands prefixed with space.
shopt -s histappend     # Append instead of overwrite.

# Enable Bash completions for packages installed with Homebrew.
# brew install bash-completion
[ -f /usr/local/etc/bash_completion ] && source /usr/local/etc/bash_completion

# Docker completions:
# https://github.com/docker/docker-ce/blob/master/components/cli/contrib/completion/bash/docker
# Update like this:
# curl https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker > .docker-completion.sh
[ -f ~/.docker-completion.sh ] && source ~/.docker-completion.sh

# fzf integration:
# https://github.com/junegunn/fzf#using-homebrew-or-linuxbrew
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"

# Customize Git prompt.
# brew install git
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUPSTREAM=verbose

# Generate dynamic PS1 after every command.
export PROMPT_COMMAND=__prompt_command

function timer_start {
  start_time=${start_time:-$SECONDS}
}

function timer_stop {
  elapsed_seconds=$((SECONDS - start_time))
  elapsed_time="$(format_seconds $elapsed_seconds)"
  elapsed_time="${elapsed_time%"${elapsed_time##*[![:space:]]}"}"
  unset start_time
}

function format_seconds {
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  [[ $D -gt 0 ]] && printf '%dd ' $D
  [[ $H -gt 0 ]] && printf '%dh ' $H
  [[ $M -gt 0 ]] && printf '%dm ' $M
  [[ $S -gt 0 ]] && printf '%ds ' $S
}

# This starts the timer every time a command is executed.
trap 'timer_start' DEBUG

function __prompt_command() {
  # Capture the exit code. This must be first.
  local EXIT="$?"

  # Stop the timer.
  timer_stop

  # ANSI escape codes.
  local RESET='\[\e[0m\]'
  local RED='\[\e[0;31m\]'
  local CYAN='\[\e[0;36m\]'
  local BLUE='\[\e[0;94m\]'
  local WHITE='\[\e[0;97m\]'

  # Show the current working direcotry.
  PS1="$CYAN\\w$RESET "

  # Show git info:
  if declare -f __git_ps1 > /dev/null; then
      PS1+="\$(__git_ps1 \"$BLUE(%s)$RESET \")"
  fi

  # Show elapsed time.
  if [[ "${elapsed_time}" != "" ]]; then
    PS1+="[${elapsed_time}] "
  fi

  # Show bad exit codes.
  if [[ $EXIT != "0" ]]; then
      PS1+="$RED$EXIT$RESET "
  fi

  # The actual prompt character.
  PS1+='\n$WHITE\$$RESET '
}
