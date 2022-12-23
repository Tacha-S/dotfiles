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
fpath=(~/.zsh/completions ~/.zsh/functions ${fpath})
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
alias rsync='rsync -rltD --progress'
function depends() {
  command apt-rdepends -p --follow=Depends,PreDepends,Recommends --show=Depends,PreDepends,Recommends $1 | grep "^\w" | sort -u
}


# ROS
source /opt/ros/`ls /opt/ros`/setup.zsh
eval "$(register-python-argcomplete3 ros2)"
eval "$(register-python-argcomplete3 colcon)"
export RCUTILS_COLORIZED_OUTPUT=1
#source ros/devel/setup.zsh
source `catkin locate --shell-verbs`
source /usr/share/vcstool-completion/vcs.zsh
export ROSCONSOLE_FORMAT='[${severity}][${node}]: ${message}'
alias cs='catkin source'
alias cba='catkin build && cs'
alias cca='catkin clean'
alias rdi='rosdep install --from-paths . -yir --rosdistro=${ROS_DISTRO}'

export PATH=$PATH:~/.local/bin

# pipenv
if type pipenv >/dev/null 2>&1; then
  export WORKON_HOME=~/.venvs
  export PIPENV_VENV_IN_PROJECT=1
  eval "$(_PIPENV_COMPLETE=zsh_source pipenv)"
fi

# pyenv
export PYENV_ROOT="${HOME}/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
  export PATH=${PYENV_ROOT}/bin:$PATH
  eval "$(pyenv init -)"
fi

# direnv
eval "$(direnv hook zsh)"

# rust
source ~/.cargo/env

## CUDA and cuDNN paths
export PATH=/usr/local/cuda/bin:${PATH}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

# dlib paths
export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:/usr/local/lib/pkgconfig

# git escape magic
autoload -Uz git-escape-magic
git-escape-magic

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zinit light zsh-users/zsh-syntax-highlighting
zinit ice as"program" pick"tmuximum"
zinit light arks22/tmuximum
zinit ice as"program" mv"zemojify -> emojify"
zinit light filipekiss/zemojify

zinit ice depth=1; zinit light romkatv/powerlevel10k
### End of Zinit's installer chunk

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
function prompt_ros() {
  if [[ -z "$ROS_MASTER_URI" ]]; then
  else
    host=`echo $ROS_MASTER_URI | sed -e 's|^[^/]*//||' -e 's|:.*$||'`
    if [ $host != "localhost" ]; then
      p10k segment -f red -i '⚙' -t "$host"
    fi
  fi
}
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=ros

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fzf-switch-branch() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m)
  BUFFER+="git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")"
  zle accept-line
}
zle -N fzf-switch-branch
bindkey "^b" fzf-switch-branch

writecmd() {
  perl -e 'ioctl STDOUT, 0x5412, $_ for split //, do{ chomp($_ = <>); $_ }' ;
}

rcd() {
    local package
    package=$(rospack list-names | fzf-tmux --query="$1" -1 -0) &&
        roscd "$package"
}
rl() {
    local package
    package=$(rospack list-names | fzf-tmux --query="$1" -1 -0) &&
        find $(catkin locate "$package") -type f -name "*.launch" -printf "%f\n" | fzf-tmux --query="$1" -1 -0 |\
        sed "s/^/roslaunch "$package" /" | writecmd
}
rb() {
   find $FZF_ROSBAG_DIRS -type f -name "*.bag" | fzf-tmux --query="$1" -1 -0 |\
        sed "s/^/\$FZF_ROSBAG_PLAY_COMMAND/" | writecmd
}
rr() {
    local package
    package=$(rospack list-names | fzf-tmux --query="$1" -1 -0) &&
        find $(catkin locate "$package") -type f -executable -printf "%f\n" | fzf-tmux --query="$1" -1 -0 |\
        sed "s/^/rosrun "$package" /" | writecmd
}
rte() {
    rostopic list > /dev/null &&
        cmd=$(rostopic list | fzf-tmux --query="$1" -1 -0 |\
        sed "s/^/rostopic echo /")
    writecmd $cmd
}
rth() {
    rostopic list > /dev/null &&
        rostopic list | fzf-tmux --query="$1" -1 -0 |\
        sed "s/^/rostopic hz /" | writecmd
}
rti() {
    rostopic list > /dev/null &&
        rostopic list | fzf-tmux --query="$1" -1 -0 |\
        sed "s/^/rostopic info /" | writecmd
}
rni() {
    rostopic list > /dev/null &&
        rosnode list | fzf-tmux --query="$1" -1 -0 |\
        sed "s/^/rosnode info /" | writecmd
}
cb() {
    local package
    package=$(rospack list-names | fzf-tmux --query="$1" -1 -0) &&
        catkin build "$package" && cs
}
cc() {
    local package
    package=$(rospack list-names | fzf-tmux --query="$1" -1 -0) &&
        catkin clean "$package" && cs
}

export LIBDYNAMIXEL=/usr/local
export SPEAKER=true
export PULSE_SERVER=$HOME/.config/pulse/server
