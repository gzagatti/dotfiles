"Basic Settings {{{

""Python location {{{
" let g:python_host_prog = $HOME . "/.pyenv/versions/vim2/bin/python"
let g:loaded_python_provider=0
let g:python3_host_prog = $HOME . "/.pyenv/versions/vim3/bin/python"
""}}}

""Importing Settings from vim {{{
set runtimepath^=~/.vim
let &packpath = &runtimepath
source ~/.vimrc
""}}}

"}}}
