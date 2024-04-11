# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

export EDITOR=nano

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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

function debug() {
    if [[ -n $LL_DEBUG ]]; then
        echo $@ 1>&2
    fi
}

function source_if_exists() {
    if [[ -f $1 ]]; then
        debug "Sourcing $1 because it exists."
        source $1
    else
        debug "Not source $1 because it could not be found."
    fi
}

export PATH=$PATH:$HOME/.cargo/bin:$HOME/.local/bin:/opt/homebrew/bin

source_if_exists $HOME/.bash_aliases
source_if_exists $HOME/.bash_aws
source_if_exists $HOME/.bash_completions
source_if_exists $HOME/.bash_go
source_if_exists $HOME/.bash_secrets
source_if_exists $HOME/.bash_kubectl
source_if_exists $HOME/.bash_libvirt
source_if_exists $HOME/.bash-preexec.sh
source_if_exists $HOME/.bash_fzf
source_if_exists $HOME/.bash_prompt
source_if_exists $HOME/.bash_php
source_if_exists $HOME/.bash_pulumi
source_if_exists $HOME/.bash_rust
source_if_exists $HOME/.bash_venv
source_if_exists $HOME/.bash_wayland
source_if_exists $HOME/.bash_work
