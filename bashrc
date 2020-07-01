# Avoid breaking non-interactive logins (eg sftp)
if [[ $- == *i* ]]; then

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
  fi
  ## }}}

  ## text editor {{{
  if hash nvim 2>/dev/null; then
    export EDITOR=/usr/local/bin/nvim
  else
    export EDITOR=/usr/local/bin/vim
  fi
  ## }}}

  ## tex {{{
  if hash tex 2>/dev/null; then
    export TEXMFHOME=$HOME/.texmf
  fi
  ## }}}

  ## python {{{
  # load pyenv
  if hash pyenv 2>/dev/null; then

    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1

    function _pyenv_info() {
      if hash pyenv 2>/dev/null; then
        local venv=$(pyenv version-name)
        if [ -n "$venv" ] && [ $venv != system ]; then
          printf "(py $venv)"
        fi
      fi
      return
    }
  fi
  ## }}}

  ## r {{{
  if hash R 2>/dev/null; then
    export R_PROFILE=$HOME/.RProfile
    alias R='R --no-save --no-restore'
  fi
  ## }}}

  ## slimux {{{
  # magic environments in order to make slimux work in tmux
  if [ -d $HOME/.vim/plugged/slimux ]; then
    case $OSTYPE in
      linux*)
        export EVENT_NOEPOLL=1
        ;;
      darwin*)
        export EVENT_NOKQUEUE=1
        export EVENT_NOPOLL=1
        ;;
    esac
  fi
  ## }}}

  # }}}

  # PS1 {{{
  # (py env)[host user]:~ 99$

  function _ps1() {
    local color='$(if [[ $? == 0 ]]; then echo "\[\e[00;30m\]";else echo "\[\e[00;31m\]"; fi)'
    local info='[\h \u]:\W \$'
    local reset_color='\[\e[0m\] \[\e[33m\]'
    printf %s "$color$(_pyenv_info)$info$reset_color"
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
  export PATH=$HOME/dev/bin:$PATH
  # removes duplicates from the PATH, given that the above can introduce duplicates
  PATH=`printf %s "$PATH" | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}'`
  # }}}

  # Alias {{{

  ## Source bashrc {{{
  alias bashrc='source ~/.bashrc'
  ## }}}

  # }}}

  # Mac specific {{{
  if  [[ $OSTYPE == darwin* ]]; then

    # turn on/off hidden files visibility
    alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
    alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

    # ql: show a "Quick Look" view of files
    ql() { /usr/bin/qlmanage -p "$@" >& /dev/null & }

    # firefox: open document in Firefox
    firefox() { if [ $1 ]; then open -a Firefox $1; else open -a "Firefox"; fi }

  fi
  # }}}

fi


