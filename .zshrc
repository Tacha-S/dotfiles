

export EDITOR='vim'
#KCODE utf-8
export KCODE=u
export

# General

setopt no_beep
setopt ignore_eof
setopt auto_param_slash
#Add '/' to directory
setopt mark_dirs
#Japanese
setopt print_eight_bit
#Fix typo
setopt correct
#Extend wild card
setopt extended_glob
#dotfile
setopt globdots

# Directory

setopt auto_cd
#Add directory stack
setopt auto_pushd
#Don't add almost exist directory
setopt pushd_ignore_dups

# History

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt inc_append_history
#Don't store 'history' command
setopt hist_no_store

# Key Bind

bindkey -v

# Colors

autoload -Uz colors; colors
export LS_COLORS='no=00;38;5;252:rs=0:di=01;38;5;111:ln=01;38;5;113:mh=00:pi=48;5;241;38;5;192;01:so=48;5;241;38;5;192;01:do=48;5;241;38;5;192;01:bd=48;5;241;38;5;177;01:cd=48;5;241;38;5;177;01:or=48;5;236;38;5;196:su=48;5;209;38;5;235:sg=48;5;192;38;5;235:ca=30;41:tw=48;5;113;38;5;235:ow=48;5;113;38;5;111:st=48;5;111;38;5;235:ex=01;38;5;209:*#=00;38;5;246:*~=00;38;5;246:*.o=00;38;5;246:*.swp=00;38;5;246:'

# cdr

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook 
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file    "$HOME/.config/zsh/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-max     1000
zstyle ':chpwd:*' recent-dirs-pushd   true

[ ! -d $HOME/.config/zsh ] && mkdir -p $HOME/.config/zsh


# Completion

autoload -Uz compinit; compinit
#Complete after equal
setopt magic_equal_subst
setopt list_packed

zstyle ':Completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':Completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' '+m:{a-z}={A-Z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
#Enable ↑↓←→
zstyle ':completion:*:default' menu select=2
#Faster apg-get and so on
zstyle ':completion:*' use-cache true
zstyle ':completion:*' recent-dirs-insert both
zstyle ':completion:*:*:cdr:*:*' menu selection
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:processes-names' command  'ps c -u ${USER} -o command | uniq'

# Prompt

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{red}'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}'
zstyle ':vcs_info:*' formats '%u%c%b'
zstyle ':vcs_info:*' actionformats '%u%c%b|%a'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

function +vi-git-untracked() {
  if command git status --porcelain 2> /dev/null \
    | awk '{print $1}' \
    | command grep -F '??' > /dev/null 2>&1 ; then
    hook_com[unstaged]+='%F{yellow}'
  fi
}

function update_vcs_info() {
  psvar=()
  vcs_info
  [[ -n $vcs_info_msg_0_ ]] && echo $vcs_info_msg_0_
}

setopt prompt_subst
PROMPT=$'
%{$fg_bold[yellow]%}%n@%m %{$fg_bold[green]%}%~%{$reset_color%} %{$fg_bold[blue]%}`update_vcs_info`%{$reset_color%}
%(?,,%{$fg_bold[red]%}%? )%{$reset_color%}❯ '
RPROMPT='%D{%H:%M:%S}'



# Alias

alias ls='ls --color=auto'
alias lla='ls -la --color=auto'
alias ll='ls -l --color=auto'
alias la='ls -a --color=auto'
alias grep='grep --color=auto'
alias df='df -h'

