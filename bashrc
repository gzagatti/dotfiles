# Avoid breaking non-interactive logins (eg sftp)
if [[ $- == *i* ]]; then

  # Determine OS type {{{
  export OSTYPE="$(uname -s)"
  # }}}

  # History {{{
  export HISTFILE=~/.bash_history
  export HISTFILESIZE=-1
  export HISTIGNORE="&:[ ]*:exit:sudo*"
  export HISTCONTROL=ignoreboth
  export HISTTIMEFORMAT="%F %T %Z "
  shopt -s histappend histverify
  # }}}

  # Program specific {{{

  # ls {{{
  # color scheme
  # https://geoff.greer.fm/lscolors/
  export CLICOLOR=1
  export LSCOLORS="excxhxDxbxhxhxhxhxfxfx"
  export LS_COLORS="no=00:fi=00:di=34::ln=32:so=37:pi=1;33:ex=31:bd=37:cd=37:su=37:sg=37:tw=35:ow=35"
  # }}}

  ## brew {{{
  if hash brew &>/dev/null; then
    export PATH=$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  elif [ -d $HOME/.linuxbrew ]; then
    export HOMEBREW_PREFIX=$HOME/.linuxbrew
    export HOMEBREW_CELLAR=$HOME/.linuxbrew/Cellar
    export HOMEBREW_REPOSITORY=$HOME/.linuxbrew/Homebrew
    export MANPATH=$HOME/.linuxbrew/share/man::
    export INFOPATH=$HOME/.linuxbrew/share/info:
    # exporting the PATH slows the initialization quite significantly, would be
    # good to figure an efficient way to do so.
    export PATH=$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH
  fi
  ## }}}

  ## text editor {{{
  if hash nvim 2>/dev/null; then
    export EDITOR=$(which nvim)
  elif hash vim 2>/dev/null; then
    export EDITOR=$(which vim)
  else
    export EDITOR=$(which vi)
  fi
  ## }}}

  ## tex {{{
  if hash tex 2>/dev/null; then
    export TEXMFCONFIG=$HOME/.local/share/texlive/texmf-config
    export TEXMFVAR=$HOME/.local/share/texlive/texmf-var
    export TEXMFHOME=$HOME/.local/share/texlive/texmf
  fi
  ## }}}

  ## pyenv {{{
  if hash pyenv 2>/dev/null; then

    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    export PYENV_ROOT="$(pyenv root)"

  fi
  ## }}}

  ## rbenv {{{
  if hash rbenv 2>/dev/null; then

    eval "$(rbenv init -)"
    export RBENV_ROOT="$(rbenv root)"

  fi
  ## }}}

  ## r {{{
  if hash R 2>/dev/null; then
    export R_PROFILE=$HOME/.RProfile
    alias R='R --no-save --no-restore'
    alias r='R --no-save --no-restore'
  fi
  ## }}}

  ## go {{{
  if hash go 2>/dev/null; then
    export GOPATH=$HOME/.go
  fi
  ## }}}

  ## slimux {{{
  # magic environments in order to make slimux work in tmux
  if [ -d $HOME/.vim/plugged/slimux ]; then
    case $OSTYPE in
      Linux*)
        export EVENT_NOEPOLL=1
        ;;
      Darwin*)
        export EVENT_NOKQUEUE=1
        export EVENT_NOPOLL=1
        ;;
    esac
  fi
  ## }}}

  # }}}

  # PS1 {{{
  # (py env)[host user]:~ 99$
  # information about the current dev environment
  function _devenv_info() {
    if hash $1 2>/dev/null; then
      local venv=$($1 version-name)
      if [ -n "$venv" ] && [ $venv != system ]; then
        printf "$2 $venv"
      fi
    fi
    return
  }
  function _precmd_ps1() {
    local dev_info_msg

    local pyenv_info_msg=`_devenv_info pyenv py`
    if [[ -n $pyenv_info_msg ]]; then
        dev_info_msg="${pyenv_info_msg}"
    fi

    local rbenv_info_msg=`_devenv_info rbenv rb`
    if [[ -n $rbenv_info_msg ]]; then
      if [[ -n $dev_info_msg ]]; then
        dev_info_msg="${dev_info_msg}, "
      fi
      dev_info_msg="${dev_info_msg}${rbenv_info_msg}"
    fi

    if [[ -n $dev_info_msg ]]; then
      dev_info_msg="(${dev_info_msg})"
    fi

    echo "$dev_info_msg"
  }
  function _ps1() {
    local color='$(if [[ $? == 0 ]]; then echo "\[\e[00;30m\]";else echo "\[\e[00;31m\]"; fi)'
    local info='[\h \u]:\W \$'
    local reset_color='\[\e[0m\] \[\e[33m\]'
    printf %s "$color$(_precmd_ps1)$info$reset_color"
    return 0
  }

  # prompt will be highlighted in red if previous command fails
  # command prompt text is always highlited in yellow
  function PreCommand() {
    if [ -z "$AT_PROMPT" ]; then
      return
    fi
    unset AT_PROMPT
    echo -en '\033[0m'
  }
  # reset colours prior to printing output
  trap "PreCommand" DEBUG

  FIRST_PROMPT=1
  function PostCommand() {
    AT_PROMPT=1
    PS1=$(_ps1)
    if [ -n "$FIRST_PROMPT" ]; then
      unset FIRST_PROMPT
      return
    fi
  }
  PROMPT_COMMAND="PostCommand"

  export PS1=$(_ps1)
  # }}}

  # PATH {{{
  # add ~/bin to PATH
  export PATH=$HOME/.local/bin:$PATH
  # removes duplicates from the PATH, given that the above can introduce duplicates
  PATH=`printf %s "$PATH" | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}'`
  # }}}

  # Alias {{{

  ## Source bashrc {{{
  alias bashrc='source ~/.bashrc'
  ## }}}

  ## List with colors by default {{{
  alias ls='ls --color=auto'
  ## }}}

  if [[ $OSTYPE == Linux* ]]; then

    ## More convenient xdg-open {{{
    alias open='xdg-open'
    ## }}}

  fi

  # }}}

  if  [[ $OSTYPE == Darwin* ]]; then

    ## turn on/off hidden files visibility {{{
    alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
    alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
    ## }}}

    ## ql: show a "Quick Look" view of files {{{
    ql() { /usr/bin/qlmanage -p "$@" >& /dev/null & }
    ## }}}

    ## firefox: open document in Firefox {{{
    firefox() { if [ $1 ]; then open -a Firefox $1; else open -a "Firefox"; fi }
    ## }}}

  fi

fi
