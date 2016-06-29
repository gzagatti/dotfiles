"Basic Settings {{{
""Basic {{{
set nocompatible
set encoding=utf-8
set lazyredraw
filetype off
syntax on
"}}}

""Leaders {{{
let mapleader = ";"
let maplocalleader = "\\"
"}}}

""Mouse {{{
set mouse=a
if has('mouse')
  set mouse=a
  if &term =~ "xterm" || &term =~ "screen"
    " for some reason, doing this directly with 'set ttymouse=xterm2'
    " doesn't work -- 'set ttymouse?' returns xterm2 but the mouse
    " makes tmux enter copy mode instead of selecting or scrolling
    " inside Vim -- but luckily, setting it up from within autocmds
    " works
    autocmd VimEnter * set ttymouse=xterm2
    autocmd FocusGained * set ttymouse=xterm2
    autocmd BufEnter * set ttymouse=xterm2
  endif
endif
""}}}

""Autocompletion {{{
set wildmenu "autocomplete feature when cycling through TAB
set wildmode=longest:full,full
set wildignorecase
""}}}

""Line ruler {{{
set number numberwidth=4
"}}}

""White Space {{{
set wrap
set shiftround shiftwidth=2
set softtabstop=2
set expandtab
set backspace=indent,eol,start
set list
set listchars=""
set listchars=tab:>\ 
set listchars+=trail:.
set listchars+=extends:>
set listchars+=precedes:>
set listchars+=nbsp:%
"}}}

""Folding {{{
set foldlevelstart=0
highlight FoldColumn ctermbg=darkgray guibg=darkgray
highlight Folded ctermbg=darkgray guibg=darkgray
"}}}

""Cursor {{{
if exists('$ITERM_PROFILE')
    let &t_SI = "\033[4 q"
    let &t_EI = "\033[2 q"
    autocmd VimLeave * silent !echo -ne "\033[2 q"
endif

"upon hitting escape to change modes,
"send successive move-left and move-right
"commands to immediately redraw the cursor
inoremap <special> <Esc> <Esc>hl
"}}}

""Searching {{{
set incsearch ignorecase smartcase
""}}}

""Buffers {{{
set switchbuf=useopen
set autowriteall
""}}}

""Backup and swap files {{{
set backupdir=~/.vim/_backup/   "where to put backup files
set directory=~/.vim/_swap/     "where to put swap files
""}}}

""Tags {{{
set tags=.git/tags,tags,./tags
""}}}

""Sign Column {{{
highlight SignColumn ctermbg=NONE guibg=NONE
""}}}

""Status line {{{
set laststatus=2
""}}}

""Auto save {{{
augroup auto_save
  autocmd!
  au CursorHold,InsertLeave * silent! wall
augroup END
""}}}
"}}}

"Vundle: Plugin Manager {{{
""Set Up {{{
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
""}}}

""Tools {{{
Plugin 'ZoomWin'                        " to zoom in and out of windowsf
Plugin 'scrooloose/nerdtree'            " file management from within Vim
Plugin 'scrooloose/nerdcommenter'       " wrangle code comments
Plugin 'junegunn/vim-easy-align'        " for easy alignment
Plugin 'tpope/vim-fugitive'             " git support
Plugin 'tpope/vim-surround'             " surround text with pairs of elements
Plugin 'easymotion/vim-easymotion'      " to make motion around vim easier
Plugin 'scrooloose/syntastic'           " syntax checking hacks
Plugin 'itspriddle/vim-marked'          " to open markdown files in marked
Plugin 'Valloric/YouCompleteMe'         " code completion engine
Plugin 'terryma/vim-multiple-cursors'   " multiple cursors
Plugin 'chrisbra/NrrwRgn'               " a narrow Region Plugin
Plugin 'Yggdroot/indentLine'            " display the indention levels with thin vertical lines
Plugin 'editorconfig/editorconfig-vim'  " editorConfig plugin for Vim http://editorconfig.org
Plugin 'mattn/emmet-vim'                " improves HTML and CSS workflow
Plugin 'kana/vim-textobj-user'          " create your own text objects
Plugin 'junegunn/goyo.vim'              " distraction free vim
Plugin 'danro/rename.vim'               " rename files in vim
Plugin 'Shougo/unite.vim'               " unite and create user interfaces
Plugin 'Shougo/vimproc.vim'             " interactive command execution
Plugin 'rhysd/vim-grammarous'           " powerful grammar checker using LanguageTool
Plugin 'christoomey/vim-tmux-navigator' " seamless navigation between tmux panes and vim splits
Plugin 'epeli/slimux'                   " tmux/vim integration
Plugin 'godlygeek/tabular'              " easy alignment of text
Plugin 'lambdalisue/vim-gista'          " gist management
Plugin 'lambdalisue/vim-gista-unite'    " gist source for unite.vim
Plugin 'majutsushi/tagbar'              " Easy tags navigation
Plugin 'tsukkee/unite-tag'              " tag source for unite.vim
Plugin 'vim-airline/vim-airline'        " lean & mean status/tabline for vim that's light as air
Plugin 'vim-scripts/matchit.zip'        " extended % matching for HTML, Latex and many other languages
"Plugin 'edkolev/tmuxline.vim'          " simple tmux statusline generator with support for powerline symbols and statusline / airline / lightline integration
"Plugin 'xolox/vim-easytags'            " automated tag file generation and syntax highlighting of tags
"Plugin 'xolox/vim-misc'                " auxiliary functions for vim-easytags
""}}}

""Languages {{{
Plugin 'vim-pandoc/vim-pandoc'          " pandoc support
Plugin 'vim-pandoc/vim-pandoc-syntax'   " pandoc syntax
Plugin 'tmhedberg/SimpylFold'           " for easy python folding
Plugin 'hdima/python-syntax'            " python syntax
Plugin 'elzr/vim-json'                  " json support
Plugin 'jvirtanen/vim-octave'           " octave support
"Plugin 'ervandew/eclim'                " java support
"""}}}

""Clean up {{{
call vundle#end()
"}}}

"}}}

"Plugin Specific {{{

""airline {{{
" powerline symbols
let g:airline_porwerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffers_label = 'b'
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab

" turn off whitespace warnings
let g:airline#extensions#whitespace#enabled = 0
""}}}

""nerdcommenter {{{
let NERDDefaultNesting=1
""}}}

""nerdtree {{{
nnoremap <f8> :NERDTreeToggle<cr>
""}}}

""slimux {{{
""" only allow panes from current window
let g:slimux_select_from_current_window = 1

""" key mappings
map <Leader>s :SlimuxREPLSendLine<CR>
vmap <Leader>s :SlimuxREPLSendSelection<CR>
map <leader>sc :SlimuxGlobalConfigure<cr>
map <leader>sb :SlimuxREPLSendBuffer<cr>
map <Leader>sa :SlimuxShellLast<CR>
map <Leader>sk :SlimuxSendKeysLast<CR>

""" slimux and python integration
augroup loadfile_slimux:
  autocmd!
  autocmd FileType python noremap <leader>sf :execute ':SlimuxShellRun %run -i '.@%<cr>
  autocmd FileType matlab noremap <leader>sf :execute ':SlimuxShellRun run('''.@%.''')'<cr>
  autocmd FileType ruby noremap <leader>sf :execute ':SlimuxShellRun load '''.@%.''''<cr>
augroup END

"}}}

""easy-align {{{
vmap <Enter> <Plug>(EasyAlign)
""}}}

""python-syntax{{{
let g:python_highlight_all = 1
"""}}}

""vim-pandoc{{{
let g:pandoc#modules#disabled = ["chdir"]
let g:pandoc#formatting#equalprg = 'pandoc -t markdown --atx-headers --wrap=none'
"""open current reference
nmap <localleader>ro <Plug>(pandoc-keyboard-ref-goto)<Plug>(pandoc-keyboard-links-open)<Plug>(pandoc-keyboard-ref-backfrom)
""}}}

""vim-pandoc-syntax{{{
let g:pandoc#syntax#conceal#blacklist = ['codeblock_start', 'codeblock_delim', 'list', 'atx']
let g:pandoc#syntax#codeblocks#embeds#use = 1
let g:pandoc#syntax#codeblock#embeds#lang = ['python']
""}}}

""you complete me{{{
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_collect_identifiers_from_tags_files = 1
nnoremap <leader>jd :YcmCompleter GoTo<cr>'
nnoremap <leader>jh :YcmCompleter GetDoc<cr>'
""}}}

""narrow negion {{{
let g:nrrw_custom_options={}
let g:nrrw_custom_options['filetype'] = ''
let g_nrrw_rgn_nohl = 3
let g:nrrw_rgn_resize_window = 'percentage'
let g:nrrw_rgn_rel_min = 20
"""allows to set the filetype of the region to be narrowed
command! -nargs=* -bang -range -complete=filetype NN
            \ :<line1>,<line2> call nrrwrgn#NrrwRgn('',<q-bang>)
            \ | set filetype=<args>
""}}}

""indent line {{{
let g:indentLine_loaded = 0
let g:identLine_fileType = ['python', 'json']
let g:indentLine_concealcursor=''
""}}}

""editor conf {{{
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
""}}}

""goyo {{{
let g:check_foldcolumn = 0
function! s:goyo_enter()
    silent !tmux set status off
    silent !tmux resize-pane -Z
    if &foldcolumn
        set foldcolumn=0
        let g:check_foldcolumn = 1
    endif
    set number
endfunction

function! s:goyo_leave()
    silent !tmux set status on
    silent !tmux resize-pane -Z
    if g:check_foldcolumn
        set foldcolumn=1
        let g:check_foldcolumn
    endif
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
""}}}

""unite {{{
""" custom preferences: open smaller buffer split at the bottom and$
""" creating a new one avoid
call unite#custom#profile('default', 'context', {'direction': 'botright', 'prompt_visible': 1, 'create': 0})
""" use ag for grep
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts =
  \ '-i --vimgrep --hidden --ignore ' .
  \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
let g:unite_source_grep_recursive_opt = ''
""" key mappings
nnoremap [unite] <Nop>
nmap <space> [unite]
nnoremap [unite]p :Unite -start-insert file_rec/async<cr>
nnoremap [unite]/ :Unite grep:.<cr>
nnoremap [unite]y :Unite -quick-match register<cr>
nnoremap [unite]s :Unite -start-insert buffer<cr>
""}}}

""tagbar {{{
nnoremap <silent> <F9> :TagbarToggle<CR>
let g:tagbar_compact = 1
let g:tagbar_show_linenumbers = -1
let g:tagbar_foldlevel = 2
let g:tagbar_autofocus = 1
"" }}}

""tmux line {{{
"let g:tmuxline_preset = {
      "\'a'    : '#S',
      "\'win'  : ['#I', '#W'],
      "\'cwin' : ['#I', '#W', '#F'],
      "\'y'    : ['%R', '%a', '%Y'],
      "\'z'    : '#H'}
""}}}

""eclim {{{
let g:EclimCompletionMethod = 'omnifunc'
let g:EclimCValidate = 0
let g:EclimHtmlValidate = 0
let g:EclimJavascriptValidate = 0
let g:EclimPhpValidate = 0
let g:EclimPhpHtmlValidate = 0
let g:EclimPythonValidate = 0
let g:EclimRubyValidate = 0
let g:EclimScalaValidate = 0
let g:EclimXmlValidate  = 0
let g:EclimDtdValidate = 0
let g:EclimXsdValidate = 0
"" }}}

"}}}

"Key Mappings {{{

"".vimrc {{{
"""Open .vimrc in an horizantal split$
nnoremap <leader>ev :split $MYVIMRC<cr>
"""Source .vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
"}}}

""Search highlight {{{
set incsearch hlsearch
"}}}

""Deletions {{{
"""Delete to the end of the line in insert mode
inoremap <c-e> <c-o>d$
"}}}

""Highlight search {{{
nnoremap <leader>hs :set hls! hls?<cr>
"}}}

""Map j and k such that is based on display lines, not physical ones {{{
noremap j gj
noremap k gk
""}}}

""Paste Mode Toggle {{{
nnoremap <F4> :set invpaste paste?<cr>
inoremap <F4> <c-o>:set invpaste paste?<cr>
noremap <leader>p "*p
noremap <leader>y "*y
set pastetoggle=<F4>
""}}}

""Clipboard Toogle{{{
noremap <F5> :call ToggleClipboard()<cr>
function! ToggleClipboard()
  if &clipboard == 'unnamed'
    set clipboard& clipboard?
  else
    set clipboard=unnamed clipboard?
  endif
endfunction
""}}}

""Line Transposition {{{
nnoremap <down> :set fdm=manual<cr>:m .+1<cr>:set fdm=marker<cr>
nnoremap <up> :set fdm=manual<cr>:m .-2<cr>:set fdm=marker<cr>
inoremap <down> <esc>:set fdm=manual<cr>:m .+1<cr>:set fdm=marker<cr>i
inoremap <up> <esc>:set fdm=manual<cr>:m .-2<cr>:set fdm=marker<cr>i
vnoremap <down> <esc>:set fdm=manual<cr>'<V'>:m '>+1<cr>:set fdm=marker<cr>gv
vnoremap <up> <esc>:set fdm=manual<cr>'<V'>:m '<-2<cr>:set fdm=marker<cr>gv
function! ToggleFold()
  if &clipboard == 'unnamed'
    set clipboard& clipboard?
  else
    set clipboard=unnamed clipboard?
  endif
endfunction
""}}}

""Select last inserted text {{{
nnoremap gV `[v`]
""}}}

""Line Filter{{{
nnoremap <leader>= mxgg=Gg`x
""}}}

""Write with Capital W{{{
command! W w
""}}}

""Delete trailling whitespace {{{
nnoremap <silent> <leader>dt :%s/\s\+$//g<cr>
""}}}
"}}}

"FileType Specific {{{
""Vimscript {{{
augroup filetype_vim
    autocmd!
    "folding
    autocmd FileType vim setlocal foldmethod=marker
augroup END
""}}}

""Markdown{{{
augroup markdown
  autocmd!
  autocmd FileType pandoc,markdown,md :set shiftround shiftwidth=4 softtabstop=4
""}}}

""Json {{{
augroup json
  autocmd!
  autocmd FileType json :setlocal foldmethod=syntax
""}}}
"}}}

"Conditioning {{{
""Avoid using arrow keys in normal and insert mode {{{
nnoremap <Left> <nop>
nnoremap <Right> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>
"}}}
"}}}

"Clean Up {{{
filetype plugin indent on
set nohlsearch
"}}}

