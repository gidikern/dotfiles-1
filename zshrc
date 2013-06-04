ZSH=$HOME/.oh-my-zsh
ZSH_THEME="fino"

plugins=(git bundler gem rbenv npm thor heroku history-substring-search zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Annoying, don't enable
unsetopt correct_all
unsetopt correct
# Necessary for git-achievements
setopt complete_aliases
# Commands that start with space are not recorded
setopt hist_ignore_space
# Enable comments on command line
setopt interactive_comments
# Always pushd when changing directory
setopt auto_pushd

# Override rm, learn not to trust own fingers
alias rm='trash-put'

# rbenv overrides lessc installed through npm
alias lessjs='/usr/bin/lessc'

# better commands to open GUI apps
function gvim () { nohup /usr/bin/gvim -f "$@" &>/dev/null }
function subl () { nohup /usr/bin/subl "$@" &>/dev/null }
function open () { nohup /usr/bin/xdg-open "$@" &>/dev/null }

# create folder, file and open it on sublime text
function newfile () {
  # ensure directory is created
  mkdir -p $(dirname $1)
  # ensure the file exists
  touch $1
  # open in the editor
  subl $1
}

# create file with +x and #!
function newexe () {
  # guess shebang by file extension
  case $(basename $1) in
    *.coffee) sh=coffee;;
    *.js)     sh=node;;
    # add -mode(compile), it is usually faster
    *.erl)    sh="escript\n\n-mode(compile).";;
    *.scm)    sh="racket\n#lang scheme";;
    *.rkt)    sh="racket\n#lang racket";;
    *.rb)     sh=ruby;;
    *.py)     sh=python;;
    # defaults to bash
    *)        sh=bash;;
  esac

  # ensure directory is created
  mkdir -p $(dirname $1)
  # create the file with the shebang
  if [ ! -f "$1" ]; then ( echo -n \#\!; echo -n "/usr/bin/env $sh\n\n" ) > $1; fi
  # add permissions to execute
  chmod +x $1
  # open in the editor
  subl $1
}

# mv with the last argument is guaranteed to be a directory
function mvtodir () {
  # last argument is the target directory
  dir="${@: -1}"
  # all but the last argument are the files/folders to move
  files="${@:1:-1}"
  # ensure target directory is created
  mkdir -p "$dir" || return $?
  # pass target directory explicitly
  mv --target-directory="$dir" $(echo $files)
}

# uninstall all gems from current ruby
function removeallgems () {
  gem list \
  | cut -d" " -f1 \
  | grep -v "^minitest\|rake\|bigdecimal\|io-console\|json\|rdoc\|test-unit\|psych\$" \
  | xargs gem uninstall -aIx
}

function git_current_branch() { git symbolic-ref --short HEAD 2> /dev/null; }

function git_update () {
  REMOTE=$1
  if [[ -z "$REMOTE" ]]; then echo "Usage: command REMOTE [BRANCH]" 1>&2 ; return 1 ; fi
  BRANCH=$2
  [ -n "$BRANCH" ] || BRANCH="$(git_current_branch)"
  git fetch $REMOTE && git rebase -p $REMOTE/$BRANCH
}
