"Basic Settings {{{
""Basic {{{
set nocompatible
set encoding=utf-8
set lazyredraw
filetype off
syntax on
""}}}

""Leaders {{{
let mapleader = ";"
let maplocalleader = "\\"
"}}}

""Mouse {{{
if has('mouse')
  set mouse=a
  if !has('nvim')
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
"set shiftround shiftwidth=2
"set softtabstop=2
"set expandtab
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
set autoread
autocmd FocusGained,CursorHold * if getcmdwintype() == '' | checktime | endif
""}}}

""Backup and swap files {{{
set backupdir=~/.vim/_tmp/   "where to put backup files
set directory=~/.vim/_tmp/     "where to put swap files
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

""Conceal {{{
set conceallevel=0
""}}}

"}}}

"Plugin Manager {{{
""Set Up {{{
call plug#begin('~/.vim/plugged')
""}}}

""Tools {{{
" Most Used Functionalities
Plug 'scrooloose/nerdtree'                  "  file management from within Vim
Plug 'tpope/vim-commentary'                 "  comment stuff out
Plug 'suy/vim-context-commentstring'        "  set commentstring value dynamically
Plug 'scrooloose/syntastic'                 "  syntax checking hacks
Plug 'tpope/vim-fugitive'                   "  git support
Plug 'tpope/vim-surround'                   "  surround text with pairs of elements
Plug 'Shougo/vimproc.vim', {'do' : 'make'}  "  interactive command execution
Plug 'Shougo/unite.vim'                     "  unite and create user interfaces
Plug 'lambdalisue/vim-gista'                "  gist management
Plug 'lambdalisue/vim-gista-unite'          "  gist source for unite.vim
Plug 'christoomey/vim-tmux-navigator'       "  seamless navigation between tmux panes and vim splits
Plug 'epeli/slimux'                         "  tmux/vim integration
Plug 'danro/rename.vim'                     "  rename files in vim
Plug 'vim-airline/vim-airline'              "  lean & mean status/tabline for vim that's light as air
Plug 'dracula/vim'                          "  dracula theme
Plug 'Yggdroot/indentLine'                  "  displays thin vertical lines at each indentation level for code indented with spaces
Plug 'previm/previm'                        "  realtime preview
Plug 'dpelle/vim-LanguageTool'              "  LanguageTool grammar checker

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'neovim/nvim-lsp'                   " neovim built-in language server
  Plug 'Shougo/deoplete-lsp'               " deoplete support for lsp
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Least Used Functionalities
Plug 'majutsushi/tagbar'                " easy tags navigation
Plug 'ludovicchabant/vim-gutentags'     " tag management
Plug 'tsukkee/unite-tag'                " tag for unite.vim
Plug 'vim-scripts/matchit.zip'          " extended % matching for HTML, Latex and many other languages
"Plug 'inkarkat/SyntaxAttr.vim'         " show syntax highlighing attributes under cursor; for debugging

Plug 'easymotion/vim-easymotion'        " to make motion around vim easier
Plug 'junegunn/vim-easy-align'          " for easy alignment
Plug 'terryma/vim-multiple-cursors'     " multiple cursors
Plug 'chrisbra/NrrwRgn'                 " a narrow Region Plugin
Plug 'godlygeek/tabular'                " easy alignment of text
Plug 'tpope/vim-sleuth'                 " heuristically set indent/tab options
Plug 'jamessan/vim-gnupg'               " easy gpg handling
Plug 'gzagatti/vim-pencil'              " rethinking Vim as a tool for writing
Plug 'junegunn/goyo.vim'                " distraction free-writing in Vim
""}}}

""Languages {{{
Plug 'mattn/emmet-vim'                  " improves HTML and CSS workflow
Plug 'plasticboy/vim-markdown'          " markdown vim mode
Plug 'lervag/vimtex'                    " latex support
Plug 'zchee/deoplete-jedi'              " python autocomplete
Plug 'tmhedberg/SimpylFold'             " for easy python folding
Plug 'hdima/python-syntax'              " python syntax
Plug 'elzr/vim-json'                    " json support
Plug 'jvirtanen/vim-octave'             " octave support
Plug 'pedrohdz/vim-yaml-folds'          " YAML folding
Plug 'coyotebush/vim-pweave'            " pweave files
Plug 'JuliaEditorSupport/julia-vim'     " julia support
Plug 'habamax/vim-asciidoctor'          " asciidoctor support



""}}}

""Archive {{{
"Plug 'edkolev/tmuxline.vim'           " simple tmux statusline generator with support for powerline symbols and statusline / airline / lightline integration
"Plug 'ervandew/eclim'                   " java support
""}}}

""Clean up {{{
call plug#end()
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
let g:airline#extensions#tabline#overflow_marker = '…'
let airline#extensions#tabline#disable_refresh = 1
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

""commentary {{{
xmap <leader>c  <Plug>Commentary
nmap <leader>c  <Plug>Commentary
omap <leader>c  <Plug>Commentary
nmap <leader>cc <Plug>CommentaryLine
""}}}

""context comment string {{{
" load the autoloaded variable first
silent! echo g:context#commentstring#table
if exists("g:context#commentstring#table")
  let g:context#commentstring#table.markdown = {
    \ 'mkdSnippetR': '# %s',
    \ 'mkdSnippetPYTHON': '# %s',
    \ 'mkdSnippetSH': '# %s',
    \}
  let g:context#commentstring#table.rmd = g:context#commentstring#table.markdown
endif
""}}}

""syntastic {{{
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_mode_map = { "mode": "passive" }

" checkers
" python
let g:syntastic_python_checkers = ['pylint']

" r
let g:syntastic_r_checkers = ['lintr']
let g:syntastic_enable_r_lintr_checker = 1
let g:syntastic_r_lintr_quiet_messages = { "regex": "Variable and function names should be all lowercase." }

""}}}

""nerdtree {{{
"ignore certain files from NERDTree
let NERDTreeIgnore=['__pycache__', '\.egg-info$']
"open NERDTree automatically when vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

function! s:NERDTreeCustomToggle(pathStr)
  let l:pathStr = !empty(a:pathStr) ? a:pathStr : expand('%:p')
  if g:NERDTree.ExistsForTab()
    if !g:NERDTree.IsOpen()
      if empty(l:pathStr)
        execute "NERDTree ."
      else
        execute "NERDTreeFind" l:pathStr
      endif
    else
      NERDTreeClose
    endif
  else
    if empty(l:pathStr)
      execute "NERDTree ."
    else
      execute "NERDTreeFind" l:pathStr
    endif
  endif
endfunction

command! -n=? -complete=file -bar NERDTreeCustomToggle call s:NERDTreeCustomToggle('<args>')

nnoremap <f8> :NERDTreeCustomToggle<cr>
""}}}

""slimux {{{
function! SlimuxSendFenced()
  let view = winsaveview()
  let line = line('.')
  let start = search('^\s*[`~]\{3,}\s*\%({\s*\.\?\)\?\a\+', 'bnW')

  if !start
      echohl WarningMsg
      echom "Not inside fenced code block."
      echohl None
      return
  endif

  call cursor(start, 1)
  let [fence, lang] = matchlist(getline(start),
              \ '^\s*\([`~]\{3,}\)\s*\%({\s*\.\?\)\?\(\a\+\)\?')[1:2]
  let end = search('^\s*' . fence . '\s*$', 'nW')

  if end < line
      call winrestview(view)
      echohl WarningMsg
      echom "Not inside fenced code block."
      echohl None
      return
    endif

  let block = getline(start + 1, end - 1)
  call add(block, "\n")

  call winrestview(view)
 call SlimuxSendCode(block)

endfunction

""" only allow panes from current window
let g:slimux_select_from_current_window = 1

""" key mappings
map <leader>sl :SlimuxREPLSendLine<CR>
vmap <leader>sl :SlimuxREPLSendSelection<CR>
map <leader>sd :call SlimuxSendFenced()<CR>
map <leader>sc :SlimuxGlobalConfigure<cr>
map <leader>sb :SlimuxREPLSendBuffer<cr>
map <leader>sr :SlimuxShellLast<CR>
map <leader>sk :SlimuxSendKeysLast<CR>

augroup loadfile_slimux:
  autocmd!
  autocmd FileType python noremap <buffer> <silent> <leader>sf
    \ :execute ":silent SlimuxShellRun %run -i " . @% <cr>
  autocmd FileType matlab noremap <buffer> <silent> <leader>sf
    \ :execute ":silent SlimuxShellRun run('".@% . "')" <cr>
  autocmd FileType ruby noremap <buffer> <silent> <leader>sf
    \ :execute ":silent SlimuxShellRun load '" . @% . "'" <cr>
  autocmd FileType sql noremap <buffer> <silent> <leader>sf
    \ :execute ":silent SlimuxShellRun \\i " . @% <cr>
  autocmd FileType r noremap <buffer> <silent> <leader>sf
    \ :execute ":silent SlimuxShellRun source('" . @% . "', echo=TRUE)" <cr>
  autocmd FileType rmd noremap <buffer> <silent> <leader>sf
    \ :execute ":silent SlimuxShellRun rmarkdown::render('" . @% . "', output_format='all', quiet=TRUE)" <cr>
  autocmd FileType hdl noremap <buffer> <silent> <leader>sf
    \ :execute ":silent SlimuxShellRun sh tools/HardwareSimulator.sh " . expand("%:r") . ".tst" <cr>
  autocmd FileType asm noremap <buffer> <silent> <leader>sf
    \ :execute ":silent SlimuxShellRun sh tools/Assembler.sh " . @% . " && sh tools/CPUEmulator.sh " . expand("%:r") . ".tst"  <cr>
  autocmd FileType markdown noremap <buffer> <silent> <leader>sd
    \ :call SlimuxSendFenced()<cr>
augroup END

function! SlimuxEscape_r(text)
  " clear console line
  let text = "" . a:text
  " eval(parse(text=readLines()))
  return text
endfunction

"}}}

""easy-align {{{
vmap <Enter> <Plug>(EasyAlign)
""}}}

""vim-markdown {{{
let g:vim_markdown_conceal = 0
let g:tex_conceal = ""
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_fenced_languages = ['julia=julia']
""}}}

""deoplete{{{
let g:deoplete#enable_at_startup = 1
autocmd CompleteDone * silent! pclose!
""}}}

""narrow negion {{{
let g_nrrw_rgn_nohl = 3
let g:nrrw_rgn_resize_window = 'percentage'
let g:nrrw_rgn_rel_min = 20
let g:nrrw_topbot_leftright = 'leftabove'

"""allows to set the filetype of the region to be narrowed
command! -nargs=* -bang -range -complete=filetype NN
            \ :<line1>,<line2> call nrrwrgn#NrrwRgn('',<q-bang>)
            \ | set filetype=<args>
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
nnoremap [unite]b :Unite -start-insert buffer<cr>
nnoremap [unite]g :Unite -start-insert gista<cr>
""}}}

""tagbar {{{
nnoremap <silent> <F9> :TagbarToggle<CR>
let g:tagbar_compact = 1
let g:tagbar_show_linenumbers = -1
let g:tagbar_foldlevel = 2
let g:tagbar_autofocus = 1
"" }}}

""tmux line {{{
let g:airline#extensions#tmuxline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 1
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'win'  : ['#I', '#W'],
      \'cwin' : ['#I', '#W', '#F'],
      \'y'    : ['%R', '%a', '%Y'],
      \'z'    : '#H'}
"" }}}

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

""goyo{{{
function! s:goyo_enter()
  silent !tmux set -w status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  nnoremap <f8> :NERDTreeToggle<cr>:Goyo x<cr>
  autocmd VimResized * exe "normal \<c-w>="
  set noshowmode
  set noshowcmd
endfunction


function! s:goyo_leave()
  silent !tmux set -w status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  nnoremap <f8> :NERDTreeToggle<cr>
  set showmode
  set showcmd
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
""}}}

""pencil {{{
let g:pencil#conceallevel = 0
augroup pencil
  autocmd!
  autocmd FileType tex call pencil#init({'wrap': 'soft'})
augroup END
"}}}

""vimtex {{{
let g:vimtex_fold_enabled = 1
let g:vimtex_complete_enabled = 1
let g:vimtex_quickfix_mode= 0
let g:vimtex_view_enabled=0
call deoplete#custom#var('omni', 'input_patterns', {
    \ 'tex': g:vimtex#re#deoplete
  \})
augroup vimtex
  au!
  au User VimtexEventQuit call vimtex#compiler#clean(0)
augroup END
""}}}

""gutentags {{{
let g:gutentags_enabled = 0
""}}}

""previm {{{
let g:previm_open_cmd = 'open -a "Google Chrome"'
""}}}

""gnupg {{{
let g:GPGPreferSymmetric = 1
""}}}

""language tool {{{
let g:languagetool_jar="/usr/local/Cellar/languagetool/4.8/libexec/languagetool-commandline.jar"
""}}}

""julia {{{
let g:latex_to_unicode_file_types = ["julia", "lisp", "jmd"]
"" }}}

""language server {{{
lua << EOF
    local nvim_lsp = require'nvim_lsp'
    nvim_lsp.julials.setup({
      filetypes = {'julia', 'jmd'}
    })
EOF
""}}}

""aasciidoctor {{{
let g:asciidoctor_folding = 1
let g:asciidoctor_fold_options = 1
let g:asciidoctor_fenced_languages = ['sh', 'css']
""}}}

"}}}

"Key Mappings {{{

"".vimrc {{{
"""Open .vimrc in an horizantal split$
if has('nvim')
  nnoremap <leader>ev :split ~/.vimrc<cr>
  nnoremap <leader>sv :source ~/.vimrc<cr>
else
  nnoremap <leader>ev :split $MYVIMRC<cr>
endif

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

""Copy/Paste mode toggle and shortcuts {{{
nnoremap <F4> :set invpaste paste?<cr>
inoremap <F4> <c-o>:set invpaste paste?<cr>
if has("mac")
  noremap <leader>p "*p
  noremap <leader>y "*y
elseif has("unix")
  noremap <leader>p "+p
  noremap <leader>y "+y
endif

" 'bracketed paste mode' support: programs that support it send the terminal
" an escape sequence to enable this mode, in which the terminal surrounds
" pasted text with a pair of escape sequences that identify the start and end.
" http://stackoverflow.com/questions/5585129/pasting-code-into-terminal-window-into-vim-on-mac-os-x
if &term =~ "xterm.*"
    let &t_ti = &t_ti . "\e[?2004h"
    let &t_te = "\e[?2004l" . &t_te
    function! XTermPasteBegin(ret)
        set pastetoggle=<Esc>[201~
        set paste
        return a:ret
    endfunction
    map <expr> <Esc>[200~ XTermPasteBegin("i")
    imap <expr> <Esc>[200~ XTermPasteBegin("")
    vmap <expr> <Esc>[200~ XTermPasteBegin("c")
    cmap <Esc>[200~ <nop>
    cmap <Esc>[201~ <nop>
  endif
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
nnoremap <s-down> :set fdm=manual<cr>:m .+1<cr>:set fdm=marker<cr>
nnoremap <s-up> :set fdm=manual<cr>:m .-2<cr>:set fdm=marker<cr>
vnoremap <s-down> <esc>:set fdm=manual<cr>'<V'>:m '>+1<cr>:set fdm=marker<cr>gv
vnoremap <s-up> <esc>:set fdm=manual<cr>'<V'>:m '<-2<cr>:set fdm=marker<cr>gv
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
nnoremap <silent> <leader>dt :execute "silent normal! mq" ':%s/\s\+$//ge' "\r`q"<cr>
""}}}

""Starts very magic regex {{{
nnoremap / /\v
nnoremap ? ?\v
""}}}

""Pop up navigation{{{
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : deoplete#manual_complete()
inoremap <expr> <s-tab>       pumvisible() ? "\<C-p>" : "\<s-tab>"
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c
""}}}

"}}}

" FileType Specific {{{
augroup vimrctweaks
  autocmd!

""Configuration files {{{
  autocmd BufNewFile,BufRead *.*rc setlocal foldmethod=marker
""}}}

""json {{{
  autocmd FileType json setlocal foldmethod=syntax
""}}}

""python {{{
  autocmd FileType python set equalprg=yapf\ --style='pep8'
""}}}

""rmd {{{
  " adds vim-markdown as a filetype plugin in order to allow
  " for syntax highlighing and folding.
  autocmd FileType rmd runtime ftplugin/markdown.vim
  autocmd FileType rmd runtime after/ftplugin/markdown.vim
""}}}

""julia {{{
  autocmd BufNewFile,BufRead *.jmd set filetype=jmd
  autocmd BufNewFile,BufRead *.jmd runtime! syntax/markdown.vim
  autocmd FileType jmd runtime ftplugin/markdown.vim
  autocmd FileType jmd runtime after/ftplugin/markdown.vim
  autocmd Filetype julia nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
""}}}

""asciidoctor {{{
  autocmd BufWritePost *.adoc :execute "silent normal! mq" ':Asciidoctor2HTML' "\r`q"
""}}}

augroup END
""}}}

"Conditioning {{{
""Avoid using arrow keys in normal and insert mode {{{
nnoremap <Left> <nop>
nnoremap <Right> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>
"}}}
"}}}

" Color Scheme {{{
syntax enable
au ColorScheme dracula highlight Normal ctermfg=253 ctermbg='NONE'
colorscheme dracula
"}}}

"Clean Up {{{
filetype plugin indent on
set nohlsearch
"}}}
