# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Start terminal using tmux (no exec to be able to dettach)
if command -v tmux &>/dev/null && [ -n "$PS1" ] && [ -z "$TMUX" ] && [ "$USER" = "pedro" ]; then
    tmux
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

git_prompt() {
    local rep=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/\* \(.*\)/\1/')
    if [ "$rep" != "" ]; then
        echo "  $rep "
    fi
}

# Onedark theme colors
one_none="\[\e[00m\]"
one_red_bg="\[\e[48;2;224;108;117m\]"
one_green_bg="\[\e[48;2;152;195;121m\]"
one_blue_bg="\[\e[48;2;97;175;239m\]"
one_red_fg="\[\e[38;2;224;108;117m\]"
one_green_fg="\[\e[38;2;152;195;121m\]"
one_blue_fg="\[\e[38;2;97;175;239m\]"
one_black="\[\e[38;2;40;44;52m\]"

beam_cursor="\[\e[5 q\]"

if [ "$color_prompt" = yes ]; then
    PS1="${debian_chroot:+($debian_chroot)}" 
    PS1+="\n┌${beam_cursor}"
    PS1+="${one_none}${one_green_fg}"             # Triangle separator
    PS1+="${one_green_bg}${one_black}  \u@\h "  # User and hostname
    PS1+="${one_blue_bg}${one_green_fg}"          # Triangle separator
    PS1+="${one_blue_bg}${one_black}  \w "       # Working directory
    PS1+="${one_red_bg}${one_blue_fg}"            # Triangle separator
    PS1+="${one_red_bg}${one_black}\$(git_prompt)" # Git branch
    PS1+="${one_none}${one_red_fg}"               # Triangle separator
    PS1+="${one_none}\n└ "                         # Newline and prompt
else
    export PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\n\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    export PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# alias and function to move up directories
cd_up() {
  case $1 in
    *[!0-9]*)                                          # if no a number
      cd $( pwd | sed -r "s|(.*/$1[^/]*/).*|\1|" )     # search dir_name in current path, if found - cd to it
      ;;                                               # if not found - not cd
    *)
      cd $(printf "%0.0s../" $(seq 1 $1));             # cd ../../../../  (N dirs)
    ;;
  esac
}
alias 'cd..'='cd_up'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# # Exit from both tmux and base terminal
# alias exitt='exit; exit'

# Update all
alias update='sudo snap refresh & sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y'

# Configure numa_nodes for GPU usage with tensorflow
alias numa-nodes='for a in /sys/bus/pci/devices/*; do echo 0 | sudo tee -a $a/numa_node; done'
alias vpinns-venv="source $HOME/OneDrive/Tercero/Varios/CITMAGA/Code/fastvpinns/venv/bin/activate"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Custom scripts
export PATH=$HOME/bin:$PATH

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


# Anaconda 3
# export PATH="$HOME/anaconda3/bin:$PATH"  # commented out by conda initialize


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/pedro/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/pedro/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/pedro/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/pedro/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Nvidia CUDA
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
