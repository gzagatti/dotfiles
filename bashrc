# Avoid breaking non-interactive logins (eg sftp)
if [[ $- == *i* ]]; then

  # Exported Variables {{{
  export R_PROFILE=~/.RProfile
  # }}}

  # PS1 Customization {{{
  #format: [time] username:directory_relative_path command_number$
  #prompt will be highlighted in red if previous command fails
  #command prompt text is always highlited in yellow
  export PS1="\$(if [[ \$? == 0 ]]; then echo \"\[\e[00;30m\]\"; else echo \"\[\e[00;31m\]\"; fi)[\A] [\h \u]:\W \#\$\[\e[0m\] \[\e[33m\]"
  trap "echo -n $'\e[0m'" DEBUG #reset colours prior to printing output
  # }}}

  # Color `ls` output {{{
  export CLICOLOR=1
  export LSCOLORS=excxhxDxbxhxhxhxhxfxfx
  # }}}

  # History {{{
  export HISTFILE=~/.bash_history
  export HISTSIZE=5000
  export HISTFILESIZE=10000
  export HISTIGNORE="&:[ ]*:exit"
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
  fi
  # }}}

  # Finder Specific {{{
  if [[ $OSTYPE == darwin* ]]; then

    # environment
    export PATH=$HOME/anaconda3/bin:/usr/local/sbin:$PATH
    export GTK_PATH=/usr/local/lib/gtk-2.0
    export EDITOR=/usr/local/bin/vim
    export ECLIPSE_HOME=/opt/homebrew-cask/Caskroom/eclipse-jee/4.5.2/Eclipse.app/Contents/Eclipse
    # magic environments in order to make slimux work in tmux
    export EVENT_NOKQUEUE=1
    export EVENT_NOPOLL=1

    # turn on/off hidden files visibility
    alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
    alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

    # ql: show a "Quick Look" view of files
    ql () { /usr/bin/qlmanage -p "$@" >& /dev/null & }

    # marked: open document in Marked 2
    marked() { if [ $1 ]; then open -a "Marked 2" $1; else open -a "Marked 2"; fi }

    # rm_DS_Store_files: removes all .DS_Store file from the current dir and below
    alias rm_DS='find . -name .DS_Store -exec rm {} \;'

    # bash completion
  [ -r $(brew --prefix)/etc/bash_completion ] && source $(brew --prefix)/etc/bash_completion

  fi
  # }}}

fi
