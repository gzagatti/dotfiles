# Avoid breaking non-interactive logins (eg sftp)
if [[ $- == *i* ]]; then

  # Determine OS type {{{
  export OSTYPE="$(uname -s)"
  # }}}

  # Shell options {{{
  setopt NO_CASE_GLOB
  setopt AUTO_CD
  bindkey -v
  bindkey "^?" backward-delete-char
  bindkey "^R" history-incremental-search-backward
  # }}}

  # History {{{
  setopt SHARE_HISTORY
  setopt APPEND_HISTORY
  setopt INC_APPEND_HISTORY
  setopt HIST_IGNORE_DUPS
  setopt HIST_REDUCE_BLANKS
  setopt HIST_VERIFY
  export HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
  export SAVEHIST=100000
  export HISTSIZE=$SAVEHIST
  # }}}

  # Program specific {{{

  ## PATH {{{
  # add ~/.local/bin to PATH, before looking for other commands
  export PATH=$HOME/.local/bin:$PATH
  hash -f
  ## }}}

  ## ls {{{
  # color scheme
  # https://geoff.greer.fm/lscolors/
  export CLICOLOR=1
  export LSCOLORS="excxhxDxbxhxhxhxhxfxfx"
  export LS_COLORS="no=00:fi=00:di=34::ln=32:so=37:pi=1;33:ex=31:bd=37:cd=37:su=37:sg=37:tw=35:ow=35"
  ## }}}

  ## brew {{{
  if hash brew &>/dev/null; then
    export PATH=$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH
    export FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    hash -f
  elif [ -f $HOME/.linuxbrew/bin/brew ]; then
    export HOMEBREW_PREFIX=$HOME/.linuxbrew
  elif [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    export HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew
  fi

  if [ -n "$HOMEBREW_PREFIX" ]; then
    export HOMEBREW_CELLAR=$HOMEBREW_PREFIX/Cellar
    export HOMEBREW_REPOSITORY=$HOMEBREW_PREFIX/Homebrew
    export MANPATH=$HOMEBREW_PREFIX/share/man::
    export INFOPATH=$HOMEBREW_PREFIX/share/info:
    export PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH
    export FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    hash -f
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
  # manual http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information
  autoload -Uz vcs_info
  setopt prompt_subst
  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:git*+set-message:*' hooks git-changes
  # see https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples#L159
  +vi-git-changes(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]]; then
      local git_status=`git status --porcelain`
      if [[ -z $git_status ]]; then
        hook_com[staged]+=''
      elif echo "${git_status}" | grep -q "^[MADRCU]"; then
        hook_com[staged]+='+'
      elif echo "${git_status}" | grep -q "^ [MADRCU]"; then
        hook_com[staged]+='*'
      elif echo "${git_status}" | grep -q "^??"; then
        hook_com[staged]+='?'
      elif echo "${git_status}" | grep -q "^!!"; then
        hook_com[staged]+='!'
      fi
    fi
  }
  zstyle ':vcs_info:git:*' formats ' %b%c'
  # information about the current dev environment
  _devenv_info() {
    if hash $1 2>/dev/null; then
      local venv=$($1 version-name)
      if [ -n "$venv" ] && [ $venv != system ]; then
        printf "$2 $venv"
      fi
    fi
    return
  }
  # inspired by
  # https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples#L51
  precmd_ps1() {
    local color='%(?.%F{black}.%F{red})'
    local host_info_msg="[%m %n]:%1~ %#"
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

    vcs_info
    if [[ -n $vcs_info_msg_0_ ]]; then
      if [[ -n $dev_info_msg ]]; then
        dev_info_msg="${dev_info_msg} "
      fi
      dev_info_msg="${dev_info_msg}${vcs_info_msg_0_}"
    fi

    if [[ -n $dev_info_msg ]]; then
      dev_info_msg="(${dev_info_msg})"
    fi

    PS1="$color${dev_info_msg}${host_info_msg}%F{yellow} "

  }
  precmd_functions+=( precmd_ps1 )
  preexec() {
    echo -en '\033[0m'
  }
  # }}}

  # Tab completion {{{
  # case insensitive path-completion
  zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

  # partial completion
  zstyle ':completion:*' list-suffixes
  zstyle ':completion:*' expand prefix suffix

  # load bashcompinit for some old bash completions
  autoload bashcompinit && bashcompinit

  autoload -Uz compinit
  compinit -u
  # }}}

  # Alias and functions {{{

  ## Source zshrc {{{
  alias zshrc='source ~/.zshrc'
  ## }}}

  ## List with colors by default {{{
  alias ls='ls --color=auto'
  ## }}}

  ## simple calculator {{{
  # https://lukasmestan.com/simple-zsh-calculator/
  function = { echo "$@" | bc -l }
  ## }}}

  if [[ $OSTYPE == Linux* ]]; then

    ## More convenient xdg-open {{{
    alias open='xdg-open'
    ## }}}

  fi

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

  # }}}

  # PATH {{{
  # add ~/.local/bin to PATH to the front of the path
  export PATH=$HOME/.local/bin:$PATH
  # removes duplicates from the PATH, given that the above can introduce duplicates
  PATH=`printf %s "$PATH" | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}'`
  # }}}

fi
