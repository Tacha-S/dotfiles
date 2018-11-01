export EDITOR='vim'
# KCODE utf-8
export KCODE=u

# General

# disable beep
setopt no_beep
# don't exit Ctrl+D
setopt ignore_eof
# don't flow control
setopt no_flow_control
# insert '/' after dir param
setopt auto_param_slash
# insert '/' after dir
setopt mark_dirs
# enable japanese
setopt print_eight_bit
# fix typo
setopt correct
# extend wild card
setopt extended_glob
# catch dotfiles nothing '.'
setopt globdots

# Directory

# can cd only dir
setopt auto_cd
# auto push by cd
setopt auto_pushd
# ignore dups
setopt pushd_ignore_dups

# History

# save history
HISTFILE=~/.zsh_history
# save size
HISTSIZE=100000
SAVEHIST=100000
# add time to history
setopt extended_history
# ignore dups
setopt hist_ignore_all_dups
# reduce blank
setopt hist_reduce_blanks
# add history soon
setopt inc_append_history
# don't store 'history'
setopt hist_no_store

# Color

TERM=xterm-256color
autoload -Uz colors; colors
export LS_COLORS='no=00;38;5;252:rs=0:di=01;38;5;111:ln=01;38;5;113:mh=00:pi=48;5;241;38;5;192;01:so=48;5;241;38;5;192;01:do=48;5;241;38;5;192;01:bd=48;5;241;38;5;177;01:cd=48;5;241;38;5;177;01:or=48;5;236;38;5;196:su=48;5;209;38;5;235:sg=48;5;192;38;5;235:ca=30;41:tw=48;5;113;38;5;235:ow=48;5;113;38;5;111:st=48;5;111;38;5;235:ex=01;38;5;209:*#=00;38;5;246:*~=00;38;5;246:*.o=00;38;5;246:*.swp=00;38;5;246:'

# Completion

autoload -Uz compinit; compinit
# complete after equal
setopt magic_equal_subst
# packed too many
setopt list_packed

zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' '+m:{a-z}={A-Z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'


# enable ↑↓←→
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin


# alias
alias ls='ls --color=auto'
alias lla='ls -la --color=auto'
alias ll='ls -l --color=auto'
alias la='ls -a --color=auto'
alias grep='grep --color=auto'
alias df='df -h'


# pyenv
export PYENV_ROOT="${HOME}/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
    export PATH=${PYENV_ROOT}/bin:$PATH
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

export PIPENV_VENV_IN_PROJECT=true

source ~/.zplug/init.zsh

zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

if ! zplug check --verbose; then
    printf 'Install? [y/N]: '
    if read -q; then
      echo; zplug install
  fi
fi

zplug load --verbose

fpath=(~/.functions ${fpath})
autoload -Uz git-escape-magic
git-escape-magic

# color theme config
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX=""
