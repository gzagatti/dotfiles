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
set shiftround shiftwidth=2 softtabstop=2 expandtab 
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

""Newtrw{{{
let g:netrw_browsex_viewer= "-"
function! s:myNFH(filename)
  if executable("xdg-open")
    let cmd = ":!xdg-open "
  elseif executable("open")
    let cmd = ":!open "
  else
    return 0
  endif
  let path = "file://" . expand("%:p:h") . "/" . a:filename
  execute cmd . shellescape(path, 1)
  return 1
endfunction
function! NFH_jpg(filename)
  call s:myNFH(a:filename)
endfunction
function! NFH_png(filename)
  call s:myNFH(a:filename)
endfunction
function! NFH_svg(filename)
  call s:myNFH(a:filename)
endfunction
function! NFH_gif(filename)
  call s:myNFH(a:filename)
endfunction
function! NFH_pdf(filename)
  call s:myNFH(a:filename)
endfunction
""}}}

""Providers {{{
"""Python provider {{{
let g:loaded_python_provider=0
let g:python3_host_prog = $HOME . "/.pyenv/versions/vim3/bin/python"
"""}}}

"""Ruby provider {{{
let g:loaded_ruby_provider = 0
"""}}}

"""Perl provider {{{
let g:loaded_perl_provider = 0
"""}}}
""}}}

"}}}

"Plugin Manager {{{
""Set Up {{{
call plug#begin('~/.vim/plugged')
""}}}

""Tools {{{
" Most Used Functionalities
Plug 'vim-airline/vim-airline'              "  lean & mean status/tabline for vim that's light as air
Plug 'dracula/vim'                          "  dracula theme
Plug 'preservim/nerdtree'                  "  file management from within Vim
Plug 'tpope/vim-commentary'                 "  comment stuff out
Plug 'suy/vim-context-commentstring'        "  set commentstring value dynamically
Plug 'tpope/vim-fugitive'                   "  git support
Plug 'tpope/vim-surround'                   "  surround text with pairs of elements
Plug 'christoomey/vim-tmux-navigator'       "  seamless navigation between tmux panes and vim splits
Plug 'epeli/slimux'                         "  tmux/vim integration
Plug 'danro/rename.vim'                     "  rename files in vim
Plug 'Yggdroot/indentLine'                  "  displays thin vertical lines at each indentation level for code indented with spaces
Plug 'vim-scripts/matchit.zip'          " extended % matching for HTML, Latex and many other languages
Plug 'majutsushi/tagbar'                " easy tags navigation
Plug 'ludovicchabant/vim-gutentags'     " tag management
Plug 'junegunn/vim-easy-align'          " for easy alignment
Plug 'gzagatti/vim-pencil'              " rethinking Vim as a tool for writing
Plug 'junegunn/goyo.vim'                " distraction free-writing in Vim
""}}}

""Languages {{{
Plug 'jamessan/vim-gnupg'               " easy gpg handling
Plug 'mattn/emmet-vim'                  " improves HTML and CSS workflow
Plug 'plasticboy/vim-markdown'          " markdown vim mode
Plug 'jvirtanen/vim-octave'             " octave support
Plug 'coyotebush/vim-pweave'            " pweave files
Plug 'habamax/vim-asciidoctor'          " asciidoctor support
Plug 'lambdalisue/vim-gista'            " gist management
Plug 'dpelle/vim-LanguageTool'          " LanguageTool grammar checker
Plug 'eigenfoo/stan-vim'                " stan probabilistic programming language
""}}}

""Debugging {{{
"Plug 'edkolev/tmuxline.vim'           " simple tmux statusline generator
"Plug 'inkarkat/SyntaxAttr.vim'        " show syntax highlighing attributes under cursor
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
"
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

command! -n=? -complete=file -bar NERDTreeCustomToggle call <SID>NERDTreeCustomToggle('<args>')

nnoremap <f8> :NERDTreeCustomToggle<cr>
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
    \ 'mkdSnippetJULIA': '# %s',
    \}
  let g:context#commentstring#table.rmd = g:context#commentstring#table.markdown
endif
""}}}

""tmux-navigator {{{
let g:tmux_navigator_disable_when_zoomed = 1
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
map <leader>sl :SlimuxREPLSendLine<cr>
vmap <leader>sl :SlimuxREPLSendSelection<cr>
map <leader>sd :call SlimuxSendFenced()<cr>
map <leader>sc :SlimuxGlobalConfigure<cr>
map <leader>sb :SlimuxREPLSendBuffer<cr>
map <leader>sr :SlimuxShellLast<cr>
map <leader>sk :SlimuxSendKeysLast<cr>

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
  autocmd FileType r noremap <buffer> <silent> <leader>sw
    \ :execute ":silent SlimuxShellRun rmarkdown::render('" . @% . "', output_format='all', quiet=TRUE)" <cr>
  autocmd FileType rmd noremap <buffer> <silent> <leader>sw
    \ :execute ":silent SlimuxShellRun rmarkdown::render('" . @% . "', output_format='all', quiet=TRUE)" <cr>
  autocmd FileType hdl noremap <buffer> <silent> <leader>sf
    \ :execute ":silent SlimuxShellRun sh tools/HardwareSimulator.sh " . expand("%:r") . ".tst" <cr>
  autocmd FileType asm noremap <buffer> <silent> <leader>sf
    \ :execute ":silent SlimuxShellRun sh tools/Assembler.sh " . @% . " && sh tools/CPUEmulator.sh " . expand("%:r") . ".tst"  <cr>
  autocmd FileType markdown noremap <buffer> <silent> <leader>sd
    \ :call SlimuxSendFenced()<cr>
  autocmd FileType julia noremap <buffer> <silent> <leader>sf
    \ :execute ":silent SlimuxShellRun include(\\\"" . @% . "\\\");" <cr>
  autocmd FileType julia noremap <buffer> <silent> <leader>sw
    \ :execute ":silent SlimuxShellRun weave(\\\"" . @% . "\\\"; doctype=\\\"md2html\\\", out_path = :pwd, mod = Main)" <cr>
  autocmd FileType *.jmd noremap <buffer> <silent> <leader>sw
    \ :execute ":silent SlimuxShellRun weave(\\\"" . @% . "\\\"; doctype=\\\"md2html\\\", out_path = :pwd, mod = Main)" <cr>
  autocmd FileType lua noremap <buffer> <silent> <leader>sf
    \ :execute ":silent SlimuxShellRun dofile(\\\"" . @% . "\\\");" <cr>
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

""indentLine {{{
let g:indentLine_concealcursor = 'nc'
let g:indentLine_conceallevel = 2
"" }}}

""tagbar {{{
nnoremap <silent> <F9> :TagbarToggle<cr>
let g:tagbar_compact = 1
let g:tagbar_show_linenumbers = -1
let g:tagbar_foldlevel = 2
let g:tagbar_autofocus = 1
"" }}}

""gutentags {{{
let g:gutentags_enabled = 0
let g:gutentags_define_advanced_commands = 1
let g:gutentags_project_root = ["tags"]
""}}}

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

""pencil {{{
let g:pencil#conceallevel = 2
let g:pencil#concealcursor = "nc"
augroup pencil
  autocmd!
  autocmd FileType tex call pencil#init({'wrap': 'soft'})
augroup END
"}}}

""goyo{{{
function! s:GoyoEnter()
  silent !tmux set -w status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  nnoremap <f8> :NERDTreeToggle<cr>:Goyo x<cr>
  autocmd VimResized * exe "normal \<c-w>="
  set noshowmode
  set noshowcmd
endfunction


function! s:GoyoLeave()
  silent !tmux set -w status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  nnoremap <f8> :NERDTreeToggle<cr>
  set showmode
  set showcmd
endfunction

autocmd! User GoyoEnter nested call <SID>GoyoEnter()
autocmd! User GoyoLeave nested call <SID>GoyoLeave()
""}}}

""gnupg {{{
let g:GPGPreferSymmetric = 1
""}}}

""vim-markdown {{{
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_folding_style_pythonic = 1
""}}}

""asciidoctor {{{
let g:asciidoctor_folding = 1
let g:asciidoctor_fold_options = 1
let g:asciidoctor_fenced_languages = ['sh', 'css']
let g:asciidoctor_extensions = ['asciidoctor-tufte', 'asciidoctor-bibtex']
let g:asciidoctor_autocompile = 0

function! s:ToggleAsciidoctorAutocompile()
  augroup asciidoctor
    autocmd!
    if g:asciidoctor_autocompile == 0
      autocmd BufWritePost *.adoc :execute "silent normal! mq" ':Asciidoctor2HTML' "\r`q"
    endif
  augroup END
  if g:asciidoctor_autocompile == 0
    let g:asciidoctor_autocompile = 1
    echo "asciidoctor: Compiler started in continuous mode"
  else
    let g:asciidoctor_autocompile = 0
    echo "asciidoctor: Compiler stopped"
  endif
endfunction
""}}}

"}}}

"Key Mappings {{{

"".vimrc {{{
"""Open .vimrc in a horizantal split$
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

""Moving laterally when concealed {{{
" https://stackoverflow.com/questions/12397103/the-conceal-feature-in-vim-still-makes-me-move-over-all-the-characters
" https://github.com/albfan/ag.vim/commit/bdccf94877401035377aafdcf45cd44b46a50fb5
function! s:ForwardSkipConceal(count)
  let cnt=a:count
  let mvcnt=0
  let c=col('.')
  let l=line('.')
  let lc=col('$')
  let line=getline('.')
  while cnt
    if c>=lc
      let mvcnt+=cnt
      break
    endif
    if stridx(&concealcursor, 'n')==-1
      let isconcealed=0
    else
      let [isconcealed, cchar, group]=synconcealed(l, c)
    endif
    if isconcealed
      let cnt-=strchars(cchar)
      let oldc=c
      let c+=1
      while c<lc && synconcealed(l, c)[0]
        let c+=1
      endwhile
      let mvcnt+=strchars(line[oldc-1:c-3])
    else
      let cnt-=1
      let mvcnt+=1
      let c+=len(matchstr(line[c-1:], '.'))
    endif
  endwhile
  "exec "normal ".mvcnt."l"
  return ":\<C-u>\e".mvcnt."l"
endfunction

function! s:BackwardSkipConceal(count)
  let cnt=a:count
  let mvcnt=0
  let c=col('.')
  let l=line('.')
  let lc=1
  let line=getline('.')
  while cnt
    if c<=lc
      let mvcnt+=cnt
      break
    endif
    if stridx(&concealcursor, 'n')==-1
      let isconcealed=0
    else
      let [isconcealed, cchar, group]=synconcealed(l, c)
    endif
    if isconcealed
      let cnt-=strchars(cchar)
      let oldc=c
      let c-=1
      while c>lc && synconcealed(l, c)[0]
        let c-=1
      endwhile
      let mvcnt+=strchars(line[c+1:oldc-1])
    else
      let cnt-=1
      let mvcnt+=1
      let c+=len(matchstr(line[c-1:], '.'))
    endif
  endwhile
  "exec "normal ".mvcnt."h"
  return ":\<C-u>\e".mvcnt."h"
endfunction

function! s:ToggleConceal()
  if &conceallevel==0
    set conceallevel=2 conceallevel?
  else
    set conceallevel=0 conceallevel?
  endif
endfunction

set conceallevel=2
set concealcursor=nc
nnoremap <expr> <silent> <buffer> l <SID>ForwardSkipConceal(v:count1)
nnoremap <expr> <silent> <buffer> h <SID>BackwardSkipConceal(v:count1)
nnoremap <expr> <leader>h <SID>ToggleConceal()
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
  function! s:XTermPasteBegin(ret)
      set pastetoggle=<Esc>[201~
      set paste
      return a:ret
  endfunction
  map <expr> <Esc>[200~ <SID>XTermPasteBegin("i")
  imap <expr> <Esc>[200~ <SID>XTermPasteBegin("")
  vmap <expr> <Esc>[200~ <SID>XTermPasteBegin("c")
  cmap <Esc>[200~ <nop>
  cmap <Esc>[201~ <nop>
endif
""}}}

""Clipboard Toogle{{{
function! s:ToggleClipboard()
  if &clipboard == 'unnamed'
    set clipboard& clipboard?
  else
    set clipboard=unnamed clipboard?
  endif
endfunction
noremap <expr> <F5> <SID>ToggleClipboard()
""}}}

""Line Transposition {{{
nnoremap <s-down> :set fdm=manual<cr>:m .+1<cr>:set fdm=marker<cr>
nnoremap <s-up> :set fdm=manual<cr>:m .-2<cr>:set fdm=marker<cr>
vnoremap <s-down> <esc>:set fdm=manual<cr>'<V'>:m '>+1<cr>:set fdm=marker<cr>gv
vnoremap <s-up> <esc>:set fdm=manual<cr>'<V'>:m '<-2<cr>:set fdm=marker<cr>gv
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
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
inoremap <expr> <tab> pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<C-p>" : "\<s-tab>"
" Set completeopt to have a better completion experience
set completeopt=menuone,noselect
" Avoid showing message extra message when using completion
set shortmess+=c
""}}}

"}}}

" FileType Specific {{{
augroup vimrctweaks
  autocmd!

""Create directory if not exist {{{
  " https://travisjeffery.com/b/2011/11/saving-files-in-nonexistent-directories-with-vim/
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir)
          \ && (
          \     a:force
          \     || input("'" . a:dir . "' does not exist. Create? [y/N]") =~? '^y\%[es]$'
          \    )
        call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction
""}}}


""Configuration files {{{
  autocmd BufNewFile,BufRead *.*rc setlocal foldmethod=marker
  autocmd BufNewFile,BufRead *rc setlocal foldmethod=marker
""}}}

""rmd {{{
  " adds vim-markdown as a filetype plugin in order to allow
  " for syntax highlighing and folding.
  autocmd FileType rmd runtime ftplugin/markdown.vim
  autocmd FileType rmd runtime after/ftplugin/markdown.vim
""}}}

""julia {{{
  autocmd BufNewFile,BufRead *.jl set filetype=julia
  " to get the syntax highlighing working in markdown, you need to add a
  " syntax for Julia which does not come default with NeoVim
  " https://github.com/JuliaEditorSupport/julia-vim/tree/master/syntax
  autocmd BufNewFile,BufRead *.jmd set filetype=jmd.markdown
""}}}

""latex {{{
  autocmd BufWipeout *.tex execute ":!cd " . expand("<afile>:h") . "; latexmk -c " . expand("<afile>:t")
""}}}

""asciidoctor {{{
  autocmd Filetype asciidoctor nnoremap <leader>ll :call <SID>ToggleAsciidoctorAutocompile()<cr>
  autocmd Filetype asciidoctor nnoremap <leader>lv :silent AsciidoctorOpenHTML<cr>
"" }}}

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
