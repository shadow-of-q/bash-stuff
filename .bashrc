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
export MARKPATH=$HOME/.marks

# very simple bookmark system. see:
# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
function _jump {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local marks=$(find $MARKPATH -type l -printf "%f\n")
  COMPREPLY=($(compgen -W '${marks[@]}' -- "$cur"))
  return 0
}
function jump {
  cd -P $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"
}
function mark {
  mkdir -p $MARKPATH; ln -s $(pwd) $MARKPATH/$1
}
function unmark {
  rm -i $MARKPATH/$1
}
function marks {
  ls -l $MARKPATH | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}
complete -o default -o nospace -F _jump jump

