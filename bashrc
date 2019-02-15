# Avoid breaking non-interactive logins (eg sftp)
if [[ $- == *i* ]]; then

  # Exported Variables {{{
  export R_PROFILE=~/.RProfile
  # }}}

  # Terminal {{{
  export TERM=xterm-256color
  # }}}

  # Coloring output {{{
  # https://geoff.greer.fm/lscolors/
  export CLICOLOR=1
  export LSCOLORS="excxhxDxbxhxhxhxhxfxfx"
  export LS_COLORS="no=00:fi=00:di=34::ln=32:so=37:pi=1;33:ex=31:bd=37:cd=37:su=37:sg=37:tw=35:ow=35"
  # }}}

  # History {{{
  export HISTFILE=~/.bash_history
  export HISTSIZE=5000
  export HISTFILESIZE=10000
  export HISTIGNORE="&:[ ]*:exit:sudo*"
  export HISTCONTROL=ignoreboth
  export HISTTIMEFORMAT="%F %T %Z "
  #export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND" #turn on to update bash history across terminals
  shopt -s histappend histverify
  # }}}

  # Aliases {{{
  # source .bashrc
  alias bashrc='source ~/.bashrc'
  # }}}

  # Linux Specific {{{
  if [[ $OSTYPE == linux* ]]; then
    # magic envrionments in order to make slimux work in tmux
    export EVENT_NOEPOLL=1
    # add ~/bin to PATH
    export PATH=$HOME/bin:$PATH
  fi
  # }}}

  # Mac Specific {{{
  if [[ $OSTYPE == darwin* ]]; then

    # sets the preferred PATH order
    if [ -r $(brew --prefix) ]; then
      export PATH=$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH
   fi

    # removes duplicates from the PATH, given that the above can introduce duplicates
    PATH=`printf %s "$PATH" | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}'`

    # set editor preferences
    export GTK_PATH=/usr/local/lib/gtk-2.0
    export EDITOR=/usr/local/bin/vim

    # magic environments in order to make slimux work in tmux
    export EVENT_NOKQUEUE=1
    export EVENT_NOPOLL=1

    # turn on/off hidden files visibility
    alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
    alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

    # ql: show a "Quick Look" view of files
    ql() { /usr/bin/qlmanage -p "$@" >& /dev/null & }

    # marked: open document in Marked 2
    marked() { if [ $1 ]; then open -a "Marked 2" $1; else open -a "Marked 2"; fi }

    # rm_DS_Store_files: removes all .DS_Store file from the current dir and below
    alias rm_DS='find . -name .DS_Store -exec rm {} \;'

    # bash completion
    [ -r $(brew --prefix)/etc/bash_completion ] && source $(brew --prefix)/etc/bash_completion

  fi
  # }}}

  # Python configuration {{{
  # load pyenv
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
  # export WORKON_HOME=$(pyenv root)/versions
  # activate virtualenvs
  function workon() {
    source activate $1
  }
  function _deactivate() {
    source deactivate
  }
  # it is not possible to declare a a function called
  # deactivate as it clashes with the pyenv shim of same name,
  # thus we create an internal function and alias to deactivate
  alias deactivate=_deactivate
  # }}}

  # PS1 Customization {{{
  # [host user]:~ 99$

  function _pyenv_ps1() {
    if [ -n "$(type -t pyenv)" ]; then
      local venv=$(pyenv version-name)
      if [ -n "$venv" ] && [ $venv != system ]; then
        printf "(py $venv) "
      fi
    fi
    return
  }

  function _ps1() {
    local color='$(if [[ $? == 0 ]]; then echo "\[\e[00;30m\]";else echo "\[\e[00;31m\]"; fi)'
    local info='[\h \u]:\W \#\$'
    local reset_color='\[\e[0m\] \[\e[33m\]'
    printf %s "$color$(_pyenv_ps1)$info$reset_color"
    return 0
  }

  # prompt will be highlighted in red if previous command fails
  # command prompt text is always highlited in yellow
  function PreCommand() {
    if [ -z "$AT_PROMPT" ]; then
      return
    fi
    unset AT_PROMPT
    echo -en '\e[0m'
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

fi
