export PATH=~/go/bin/:$PATH
export PKG_CONFIG_PATH=~/lib/pkgconfig:/usr/local/lib/pkgconfig/:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=~/lib
export MANPATH=~/share/man:$MANPATH
export GOROOT=~/go/
export GOPATH=~/src/go/

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

set -o vi
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -la'
alias m='make'
export PS1="`whoami`-nuc >$ "
export EDITOR=vim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

