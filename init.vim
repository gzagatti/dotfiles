"Basic Settings {{{

""Python provider {{{
let g:loaded_python_provider=0
let g:python3_host_prog = $HOME . "/.pyenv/versions/vim3/bin/python"
""}}}

""Ruby provider {{{
let g:loaded_ruby_provider = 0
""}}

""Perl provider {{{
let g:loaded_perl_provider = 0
""}}}

""Importing Settings from vim {{{
set runtimepath^=~/.vim
let &packpath = &runtimepath
source ~/.vimrc
""}}}

"}}}
