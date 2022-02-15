-- basic settings {{{

---basic {{{
vim.opt.encoding = 'utf-8'
vim.opt.lazyredraw = true
vim.cmd [[
  syntax enable
]]
---}}}

---leaders {{{
vim.g.mapleader = ';'
vim.g.maplocalleader = '\\'
--}}}

---mouse {{{
if vim.fn.has('mouse') then
  vim.opt.mouse= 'a'
end
---}}}

---autocompletion {{{
vim.opt.wildmenu = true -- autocomplete feature when cycling through TAB
vim.opt.wildmode = 'longest:full,full'
vim.opt.wildignorecase = true
vim.opt.completeopt = 'menu,menuone,noselect'
---}}}

---line ruler {{{
vim.opt.number = true
vim.opt.numberwidth = 4
--}}}

---white Space {{{
vim.opt.wrap = true
vim.opt.shiftround = true
local indent = 2
vim.opt.shiftwidth = indent
vim.opt.softtabstop = indent
vim.opt.expandtab = true
vim.opt.backspace = 'indent,eol,start'
vim.opt.list = true
--vim.opt.listchars = 'tab:>\\trail:.extends:>precedes:>nbsp:%'
--}}}

---folding {{{
vim.opt.foldlevelstart = 0
vim.cmd [[
  highlight FoldColumn ctermbg=darkgray guibg=darkgray
  highlight Folded ctermbg=darkgray guibg=darkgray
]]
--}}}

---searching {{{
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
---}}}

---buffers {{{
vim.opt.switchbuf = 'useopen'
vim.opt.autowriteall = true
vim.opt.autoread = true
vim.cmd [[
  autocmd FocusGained,CursorHold * if getcmdwintype() == '' | checktime | endif
]]
---}}}

---backup and swap files {{{
vim.opt.backupdir = vim.env.HOME .. '/.local/share/nvim/swap' -- backup files
vim.opt.directory = vim.env.HOME .. '/.local/share/nvim/swap' -- swap files
---}}}

---tags {{{
vim.opt.tags='.git/tags,tags,./tags'
---}}}

---sign Column {{{
vim.cmd [[
  highlight SignColumn ctermbg=NONE guibg=NONE
]]
---}}}

---status line {{{
vim.opt.laststatus = 2
---}}}

---auto save {{{
vim.cmd [[
  augroup auto_save
    autocmd!
    au CursorHold,InsertLeave * silent! wall
  augroup END
]]
---}}}

---newtrw{{{
vim.cmd [[
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
]]
---}}}

---filetype plugins {{{
vim.cmd [[
  filetype plugin indent on
]]
---}}}

---providers {{{
-- python
vim.g['loaded_python_provider'] = 0
vim.g['python3_host_prog'] = vim.env.HOME .. "/.pyenv/versions/vim3/bin/python"

-- ruby
vim.g['loaded_ruby_provider'] = 0

--perl
vim.g['loaded_perl_provider'] = 0
---}}}

---theme hack {{{
-- ensures that the theme is alive from the start, not sure why
vim.cmd [[
  au ColorScheme dracula highlight Normal ctermfg=253 ctermbg='NONE'
]]
---}}}

---terminal {{{
vim.api.nvim_set_keymap('t', '<c-h>', '<C-\\><C-N><C-w>h', { noremap = true })
vim.api.nvim_set_keymap('t', '<c-j>', '<C-\\><C-N><C-w>j', { noremap = true })
vim.api.nvim_set_keymap('t', '<c-k>', '<C-\\><C-N><C-w>k', { noremap = true })
vim.api.nvim_set_keymap('t', '<c-l>', '<C-\\><C-N><C-w>l', { noremap = true })
vim.cmd [[
  au TermOpen * set nonumber
]]
---}}}
--}}}

--plugins {{{
require'packer'.startup {function (use)

  ---packer {{{
  -- package management
  use { 'wbthomason/packer.nvim' }
  ---}}}

  ---plenary {{{
  use { 'nvim-lua/plenary.nvim' }
  ---}}}

  ---lualine/tmuxline {{{
  -- lean & mean status/tabline for vim that's light as air
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function ()
      require'lualine'.setup()
    end
  }
  ---}}}

  ---tmuxline {{{
  -- simple tmux statusline generator
  -- use {
  --   'edkolev/tmuxline.vim'
  --   config = function ()
  --   vim.cmd [[
  --     let g:airline#extensions#tmuxline#enabled = 1
  --     let g:airline#extensions#tmuxline#enabled = 1
  --     let g:tmuxline_preset = {
  --           \'a'    : '#S',
  --           \'win'  : ['#I', '#W'],
  --           \'cwin' : ['#I', '#W', '#F'],
  --           \'y'    : ['%R', '%a', '%Y'],
  --           \'z'    : '#H'}
  --   ]]
  --   end
  -- }
  ---}}}

  ---tabline {{{
  use {
    'kdheepak/tabline.nvim',
    requires = {
      { 'hoob3rt/lualine.nvim' },
      {'kyazdani42/nvim-web-devicons', opt = true},
    },
    config = function ()
      require'tabline'.setup{}
      vim.opt.sessionoptions:append('tabpages')
      vim.api.nvim_set_keymap('n', '<leader>1', ':TablineBufferNext<cr>', {})
      vim.api.nvim_set_keymap('n', '<leader>2', ':TablineBufferPrevious<cr>', {})
    end
  }
  ---}}}

  ---tree {{{
  --  file management from within Vim
  --[[ use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      vim.api.nvim_set_keymap('', '<f8>', ':NvimTreeToggle<cr>', { noremap = true })
      vim.g['nvim_tree_disable_window_picker'] = 1
      require'nvim-tree'.setup {}
    end
  } ]]

  use {
    'luukvbaal/nnn.nvim',
    config = function()
      local builtin = require("nnn").builtin
      require("nnn").setup {
        explorer = {
          cmd = "nnn -G",
        },
        auto_open = {
          empty = true,
        },
        mappings = {
          { "<C-x>", builtin.open_in_split },     -- open file(s) in split
          { "<C-w>", builtin.cd_to_path },        -- cd to file directory
        },
      }
      vim.api.nvim_set_keymap("", "<f8>", "<cmd>NnnExplorer %:p:h<cr>", { noremap = true })
      vim.api.nvim_set_keymap("t", "<f8>", "<cmd>NnnExplorer %:p:h<cr>", { noremap = true })
    end
  }
  ---}}}

  ---kommentary {{{
  -- easily add comments in source code
  use {
    'b3nj5m1n/kommentary',
    config = function()
      vim.g.kommentary_create_default_mappings = false
      vim.api.nvim_set_keymap("n", "<leader>cc", "<plug>kommentary_line_default", {})
      vim.api.nvim_set_keymap("n", "<leader>c", "<plug>kommentary_motion_default", {})
      vim.api.nvim_set_keymap("x", "<leader>c", "<plug>kommentary_visual_default", {})
    end
  }
  ---}}}

  ---navigators {{{
    ---kitty-navigator
    use {
      'knubie/vim-kitty-navigator',
      config = function()
        if vim.env.TERM ~= 'xterm-kitty' then
          vim.g['kitty_navigator_no_mappings'] = 1
        end
      end,
      run = 'cp ./*.py ~/.config/kitty/'
    }

    -- tmux-navigator
    -- seamless navigation between tmux panes and vim splits
    use {
      'christoomey/vim-tmux-navigator',
      config = function()
        if not string.match(vim.env.TERM, "tmux-") then
          vim.g['tmux_navigator_no_mappings'] = 1
          vim.g ['tmux_navigator_disable_when_zoomed'] = 1
        end
      end
    }
  ---}}}

  ---slime {{{
  -- multiplexer integration
  use {
    'jpalardy/vim-slime',
    config = function()
      if vim.env.TERM == 'xterm-kitty' then
        vim.g.slime_target = "kitty"
      else
        vim.g.slime_target = "tmux"
      end

      vim.g.slime_no_mappings = 1

      vim.api.nvim_set_keymap('', '[slime]', '', { noremap = true })
      vim.api.nvim_set_keymap('', '<leader>s', '[slime]', {})
      vim.api.nvim_set_keymap('' , '[slime]l', ':<c-u>call slime#send_lines(v:count1)<cr>', {})
      vim.api.nvim_set_keymap('v', '[slime]l', ':<c-u>call slime#send_op(visualmode(), 1)<cr>', {})
      vim.api.nvim_set_keymap('', '[slime]v', ':<c-u>call slime#config()<cr>', {})
      vim.api.nvim_set_keymap('' , '[slime]b', ':<c-u>call slime#send_range(line(1), line("$"))<cr>', {})
      vim.cmd [[
        augroup slime_augroup:
          autocmd!

          autocmd FileType python noremap <buffer> <silent> [slime]f
            \ :execute ":call slime#send(\"%run -i " . @% . "\r\")" <cr>
          autocmd FileType matlab noremap <buffer> <silent> [slime]f
            \ :execute ":call slime#send(\"run '" . @% . "'\r\")" <cr>
          autocmd FileType sql noremap <buffer> <silent> [slime]f
            \ :execute ":call slime#send('\\i " . @% . "\r')" <cr>
          autocmd FileType r noremap <buffer> <silent> [slime]f
            \ :execute ":call slime#send(\"source('" . @% . "', echo=TRUE)\r\")" <cr>
          autocmd FileType ruby noremap <buffer> <silent> [slime]f
            \ :execute ":call slime#send(\"load '" . @% . "'\r\")" <cr>
          autocmd FileType julia noremap <buffer> <silent> [slime]f
            \ :execute ":call slime#send('include(\"" . @% . "\");\r')" <cr>
          autocmd FileType lua noremap <buffer> <silent> [slime]f
            \ :execute ":call slime#send('dofile(\"" . @% . "\");\r')" <cr>

          autocmd FileType rmd,r noremap <buffer> <silent> [slime]w
            \ :execute ":call slime#send(\"rmarkdown::render('" . @% . "', output_format='all', quiet=TRUE)\r\")" <cr>
          autocmd FileType julia noremap <buffer> <silent> [slime]w
            \ :execute ":call slime#send('weave(\"" . @% . "\"; doctype=\"md2html\", out_path=:pwd, mod=Main)\r')" <cr>

          autocmd FileType markdown noremap <buffer> <silent> [slime]c
            \ :execute ":call slime#send_cell()" <cr>
          autocmd FileType markdown let b:slime_cell_delimiter = "```"

          autocmd FileType org noremap <buffer> <silent> [slime]c
            \ :execute ":call slime#send_cell()" <cr>
          autocmd FileType org let b:slime_cell_delimiter = "#+"

        augroup END
      ]]
    end
  }
  ---}}}

  ---indentLine {{{
  -- displays thin vertical lines at each indentation level for code indented with spaces
  use {
    'Yggdroot/indentLine',
    config = function()
      vim.g['indentLine_concealcursor'] = 'nc'
      vim.g['indentLine_conceallevel'] = 2
    end
  }
  ---}}}

  ---surround {{{
  -- surround text with pairs of elements
  use { 'tpope/vim-surround' }
  ---}}}

  ---matchit {{{
  -- extended % matching for HTML, Latex and many other languages
  use { 'vim-scripts/matchit.zip' }
  ---}}}

  ---rename {{{
  -- rename files in vim
  use { 'danro/rename.vim' }
  ---}}}

  ---vista {{{
  -- easy tags navigation
  use {
    'liuchengxu/vista.vim',
    config = function()
      -- need to make it toggle
      vim.api.nvim_set_keymap('n', '<f9>', ':Vista nvim_lsp<cr>', { noremap = true })
    end
  }
  ---}}}

  ---pencil {{{
  -- rethinking Vim as a tool for writing
  use {
    'gzagatti/vim-pencil',
    config = function ()
      vim.g['pencil#conceallevel'] = 2
      vim.g['pencil#concealcursor'] = 'nc'
      vim.cmd [[
        augroup pencil
          autocmd!
          autocmd FileType tex call pencil#init({'wrap': 'soft'})
        augroup END
      ]]
    end
  }
  ---}}}

  ---goyo{{{
  -- distraction free-writing in Vim
  use {
    'junegunn/goyo.vim',
    config = function ()
      vim.cmd [[
        function! s:GoyoEnter()
          silent !tmux set -w status off
          silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
          nnoremap <f8> :NvimTreeToggle<cr>:Goyo x<cr>
          autocmd VimResized * exe "normal \<c-w>="
          set noshowmode
          set noshowcmd
        endfunction


        function! s:GoyoLeave()
          silent !tmux set -w status on
          silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
          nnoremap <f8> :NvimTreeToggle<cr>
          set showmode
          set showcmd
        endfunction

        autocmd! User GoyoEnter nested call <SID>GoyoEnter()
        autocmd! User GoyoLeave nested call <SID>GoyoLeave()
      ]]
    end
  }
  ---}}}

  ---telescope {{{
  -- find, filter, preview, pick
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-telescope/telescope-file-browser.nvim' },
   config = function ()
      require'telescope'.setup {}
      require'telescope'.load_extension 'file_browser'
      vim.api.nvim_set_keymap('n', '[telescope]', '', { noremap = true })
      vim.api.nvim_set_keymap('n', '<space>', '[telescope]', {})
      vim.api.nvim_set_keymap('n', '[telescope]/', '<cmd>Telescope file_browser theme=get_ivy<cr>', { noremap = true })
      vim.api.nvim_set_keymap('n', '[telescope]f', '<cmd>Telescope live_grep theme=get_ivy<cr>', { noremap = true })
      vim.api.nvim_set_keymap('n', '[telescope]y', '<cmd>Telescope registers theme=get_ivy<cr>', { noremap = true })
      vim.api.nvim_set_keymap('n', '[telescope]b', '<cmd>Telescope buffers theme=get_ivy<cr>', { noremap = true })
      vim.api.nvim_set_keymap('n', '[telescope]l', '<cmd>Telescope loclist theme=get_ivy<cr>', { noremap = false })
      vim.api.nvim_set_keymap('n', '[telescope]q', '<cmd>Telescope quickfix theme=get_ivy<cr>', { noremap = true })
    end
  }
  ---}}}

  ---lsp config {{{
  -- neovim built-in language server
    use {
      'neovim/nvim-lspconfig',
      config = function ()
        local lspconfig = require'lspconfig'

        -- on_attach is only called after the language server
        -- attaches to the buffer
        local on_attach = function(client, bufnr)

          print("Attaching ", client.name, " LSP in buffer ", bufnr, "...")

          local function buf_set_keymap(...)
            vim.api.nvim_buf_set_keymap(bufnr, ...)
          end

          -- Mappings.
          local opts = { noremap=true, silent=true }

          -- documentation help
          buf_set_keymap('n', '<leader>gD',
            '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
          buf_set_keymap('n', '<leader>gd',
            '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
          buf_set_keymap('n', '<leader>gK',
            '<cmd>lua vim.lsp.buf.hover()<cr>', opts)

          -- variable management
          buf_set_keymap('n', '<leader>gn',
            '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
          buf_set_keymap('n', '<leader>gr',
            '<cmd>lua vim.lsp.buf.references()<cr>', opts)

          -- diagnostic
          buf_set_keymap('n', '[telescope]l',
            '<cmd>Telescope diagnostics theme=get_ivy<cr>', opts)

          local diagnostic_hidden = {}

          function diagnostic_toggle(toggle_bufnr, revert)
            toggle_bufnr = vim.api.nvim_buf_get_number(toggle_bufnr)
            print("Toggle diagnostics", toggle_bufnr, diagnostic_hidden[toggle_bufnr])
            if (diagnostic_hidden[toggle_bufnr] and not revert) or
              (not diagnostic_hidden[toggle_bufnr] and revert) then
              vim.diagnostic.enable(toggle_bufnr, nil)
              diagnostic_hidden[toggle_bufnr] = false
            else
              vim.diagnostic.disable(toggle_bufnr, nil)
              diagnostic_hidden[toggle_bufnr] = true
            end
          end

          buf_set_keymap('n', '<leader>gl',
            '<cmd>lua diagnostic_toggle(0)<cr>', opts)

          -- formatting
          buf_set_keymap('n', '<leader>gf',
            '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)

          -- language specific
          if(client.name == 'texlab') then
            buf_set_keymap('n', '<c-c><c-c>',
              '<cmd>echo \'Building file.\'<cr><cmd>TexlabBuild<cr>', opts)
          end
        end

        -- list of servers:
        -- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
        -- to check status: :lua vim.cmd('split'..vim.lsp.get_log_path())
        local autostart = false
        lspconfig.html.setup { on_attach = on_attach, autostart = autostart }
        lspconfig.julials.setup { on_attach = on_attach, autostart = autostart }
        lspconfig.pyright.setup { on_attach = on_attach, autostart = autostart }
        lspconfig.texlab.setup { on_attach = on_attach, autostart = autostart }
        lspconfig.jsonls.setup { on_attach = on_attach, autostart = autostart }
        lspconfig.sumneko_lua.setup {
          on_attach = on_attach,
          autostart = autostart,
          settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim' },
                disable = { "lowercase-global" },
              },
            },
          },
        }
        lspconfig.solargraph.setup {
          on_attach = on_attach,
          autostart = autostart,
          settings = {
            solargraph = {
              diagnostic = true,
              useBundler = true
            },
          },
        }
        lspconfig.stylelint_lsp.setup {
          on_attach = on_attach,
          autostart = autostart,
          settings = {
              stylelintplus = {
                autoFixOnSave = true,
                autoFixOnFormat = true
            },
          },
        }
      end
    }
  ---}}}

  ---orgmode {{{
  -- orgmode clone written in Lua
    use {
      'nvim-orgmode/orgmode',
      requires = { 'nvim-treesitter/nvim-treesitter' },
      config = function ()
        local treesitter_parser_config = require'nvim-treesitter.parsers'.get_parser_configs()
        treesitter_parser_config.org = {
          install_info = {
            url = 'https://github.com/milisims/tree-sitter-org',
            revision = 'main',
            files = {'src/parser.c', 'src/scanner.cc'},
          },
          filetype = 'org',
        }
        require('orgmode').setup {
          mappings = {
            org = {
              org_do_promote = '<h',
              org_do_demote = '>h',
            },
          },
          org_agenda_files = { vim.env.HOME .. '/dev/org/**/*' },
          org_default_notes_file = vim.env.HOME .. '/dev/org/inbox.org',
          org_todo_keywords = { 'TODO(t)', '|', 'POSTPONED(p)', 'CANCELLED(c)', 'DONE(d)' }
        }
      end,
    }
    use {
      'akinsho/org-bullets.nvim',
      requires = { 'nvim-orgmode/orgmode' },
      config = function ()
        require("org-bullets").setup {
            symbols = { "◉", "○", "✸", "✿" }
        }
      end
    }
  ---}}}

  ---cmp {{{
  -- auto-completion for nvim written in Lua
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-vsnip',
      'kdheepak/cmp-latex-symbols',
      'hrsh7th/cmp-nvim-lua',
      'ray-x/cmp-treesitter',
    },
    config = function ()

      local cmp = require('cmp')

      -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
      local has_words_before = function ()
        -- table.unpack is not defined, so we cannot fix the warning.
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local feedkey = function (key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
              feedkey("<Plug>(vsnip-expand-or-jump)", "")
            elseif has_words_before() then
              cmp.complete()
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
            end,
            { "i", "s" }
          ),
          ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
              feedkey("<Plug>(vsnip-jump-prev)", "")
            end
            end,
            { "i", "s" }
          ),
          ['<CR>'] = cmp.mapping.confirm { select = true },
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
          { name = 'latex_symbols' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'orgmode' },
          { name = 'nvim_lua' },
          { name = 'treesitter' },
          { name = 'neorg' },
        },
      }

      local capabilities = require'cmp_nvim_lsp'.update_capabilities(
        vim.lsp.protocol.make_client_capabilities())

      for _, v in pairs(require'lspconfig'.available_servers()) do
        require'lspconfig'[v].setup {
          capabilities = capabilities,
        }
      end
    end
  }
  ---}}}

  ---gnupg {{{
  -- easy gpg handling
  use {
    'jamessan/vim-gnupg',
    config = function () vim.g['GPGPreferSymmetric'] = 1 end
  }
  ---}}}

  ---emmet {{{
  -- improves HTML and CSS workflow
  use { 'mattn/emmet-vim' }
  ---}}}

  ---vim-markdown {{{
  -- markdown vim mode
  use {
    'plasticboy/vim-markdown',
    config = function ()
      vim.g['vim_markdown_math'] = 1
      vim.g['vim_markdown_frontmatter'] = 1
      vim.g['vim_markdown_folding_style_pythonic'] = 1
    end
  }
  ---}}}

  --asciidoctor {{{
  -- asciidoctor support
  use {
    'habamax/vim-asciidoctor',
    config =  function ()

      vim.g['asciidoctor_folding'] = 1
      vim.g['asciidoctor_fold_options'] = 1
      vim.g['asciidoctor_fenced_languages'] = { 'sh', 'css' }
      vim.g['asciidoctor_extensions'] = { 'asciidoctor-tufte', 'asciidoctor-bibtex' }
      vim.g['asciidoctor_autocompile'] = 0

      vim.cmd [[
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
      ]]
    end
  }
  ---}}}

  ---language-tool {{{
  -- LanguageTool grammar checker
    use { 'vigoux/LanguageTool.nvim' }
  ---}}}

  ---sniprun {{{
  -- run lines/blocs of code (independently of the rest of the file)
  use {
    'michaelb/sniprun',
    run = "bash ./install.sh 1",
    config = function ()
      require'sniprun'.setup {
        repl_enable = {'Python3_jupyter', 'Julia_jupyter'},
        interpreter_options = {
          Python3_original = {
            interpreter = 'python',
          },
          Julia_original = {
            interpreter = 'julia',
          },
        },
        snipruncolors = {
          SniprunVirtualTextOk = {bg="#66eeff",fg="#000000",ctermbg="61",cterfg="black"},
        }
      }
    end
  }
  ---}}}

  ---project {{{
  -- perior project management solution for neovim
    use {
      'ahmedkhalf/project.nvim',
      config = function ()
        require'project_nvim'.setup {
          manual_mode = false,
          silent_chdir = false,
        }
        local ok, telescope = pcall(require, 'telescope')
        if ok then
          telescope.load_extension('projects')
          vim.api.nvim_set_keymap('n', '[telescope]p', ':Telescope projects theme=get_ivy<cr>', {noremap = true})
        end
      end
    }
  ---}}}

  ---luadev {{{
  -- REPL/debug console for nvim lua
    use {
      'bfredl/nvim-luadev',
      config = function ()
          vim.api.nvim_set_keymap('n', '<C-x><C-e>', '<plug>(Luadev-RunLine)', {})
          vim.api.nvim_set_keymap('v', '<C-x><C-e>', '<plug>(Luadev-Run)', {})
          ---map <leader>lb :SlimuxREPLSendBuffer<cr>
          ---map <leader>lr :SlimuxShellLast<cr>"
      end
    }
  ---}}}

  ---minimap {{{
  -- a dotted minimap of the file
    use {
      'wfxr/minimap.vim',
      config = function ()
        vim.g ['minimap_auto_start'] = 0
        vim.g ['minimap_auto_start_win_enter'] = 0
        vim.api.nvim_set_keymap('n', '<f10>', ':MinimapToggle<cr>', { noremap = true })
      end
    }
  ---}}}

  ---syntax-attr {{{
  -- show syntax highlighing attributes under cursor
  use { 'inkarkat/SyntaxAttr.vim' }
  ---}}}

  ---treesiter {{{
  -- an incremental parsing system for programming tools
    use {
      'nvim-treesitter/nvim-treesitter',
      config = function ()
        require'nvim-treesitter.install'.update()
        require'nvim-treesitter.configs'.setup {
          ensure_installed = 'maintained', -- one of 'all', 'maintained', or a list of languages
          ignore_install = { }, -- List of parsers to ignore installing
          highlight = {
            enable = true,  -- false will disable the whole extension
            -- disable = { 'org' },  -- list of language that will be disabled
            additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
          },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = 'gnn',
              node_incremental = 'grn',
              scope_incremental = 'grc',
              node_decremental = 'grm',
            },
          },
          indent = {
            enable = true
          },
        }
        vim.opt.foldmethod = 'expr'
        vim.foldexpr = require'nvim-treesitter.fold'.get_fold_indic('%d')
      end
    }
  -- debugging and learning about treesitter
    use {
      'nvim-treesitter/playground',
      requires = { 'nvim-treesitter/nvim-treesitter', opt = true }
    }
  ---}}}

  ---theme: dracula {{{
  use {
    'dracula/vim',
    config = function ()
      vim.cmd [[
        colorscheme dracula
      ]]
    end
  }
  ---}}}

  --neorg {{{
  use {
    'nvim-neorg/neorg',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neorg/neorg-telescope',
    },
    config = function()
      local treesitter_parser_config = require'nvim-treesitter.parsers'.get_parser_configs()
      treesitter_parser_config.norg_meta = {
        install_info = {
          url = 'https://github.com/nvim-neorg/tree-sitter-norg-meta',
          files = { 'src/parser.c' },
          branch = 'main'
        },
      }
      treesitter_parser_config.norg_table = {
        install_info = {
          url = 'https://github.com/nvim-neorg/tree-sitter-norg-table',
          files = { 'src/parser.c' },
          branch = 'main'
        },
      }
      require('neorg').setup {
        -- Tell Neorg what modules to load
        load = {
          ['core.defaults'] = {}, -- Load all the default modules
          ['core.norg.concealer'] = {}, -- Allows for use of icons
          ['core.norg.dirman'] = { -- Manage your directories with Neorg
            config = {
              workspaces = {
                my_workspace = '~/dev/neorg'
              }
            }
          },
          ['core.norg.completion'] = {
            config = {
              engine = 'nvim-cmp'
            }
          },
          ['core.integrations.telescope'] = {},
        },
      }
    end,
  }
  --}}}
  end,
  {
    auto_clean = false,
  }
}

-- turn it on for automatic sync and compilation, slows down startup
-- otherwise, just call `:PackerSync' to synchronize it all
--require('packer').sync()

--}}}

--key mappings {{{

---.vimrc {{{
--open .vimrc in a horizantal split$
vim.api.nvim_set_keymap('n', '<leader><f4>', ':split $MYVIMRC<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader><f5>', ':luafile $MYVIMRC<cr>:PackerSync<cr>', { noremap = true })
---}}}

---map j and k such that is based on display lines, not physical ones {{{
vim.api.nvim_set_keymap('', 'j', 'gj', { noremap = true })
vim.api.nvim_set_keymap('', 'k', 'gk', { noremap = true })
if (vim.g['kitty_navigator_no_mappings'] == 1) and (vim.g['tmux_navigator_no_mappings'] == 1) then
  vim.api.nvim_set_keymap('', '<c-h>', '<cmd>wincmd h<cr>', { noremap = true })
  vim.api.nvim_set_keymap('', '<c-j>', '<cmd>wincmd j<cr>', { noremap = true })
  vim.api.nvim_set_keymap('', '<c-k>', '<cmd>wincmd k<cr>', { noremap = true })
  vim.api.nvim_set_keymap('', '<c-l>', '<cmd>wincmd l<cr>', { noremap = true })
end
---}}}

---moving laterally when concealed {{{
-- https://stackoverflow.com/questions/12397103/the-conceal-feature-in-vim-still-makes-me-move-over-all-the-characters
-- https://github.com/albfan/ag.vim/commit/bdccf94877401035377aafdcf45cd44b46a50fb5
vim.cmd [[
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

  nnoremap <expr> <silent> <buffer> l <SID>ForwardSkipConceal(v:count1)
  nnoremap <expr> <silent> <buffer> h <SID>BackwardSkipConceal(v:count1)
  nnoremap <expr> <leader>h <SID>ToggleConceal()
]]

vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nc'
---}}}

---copy/paste mode toggle and shortcuts {{{
-- vim.api.nvim_set_keymap('n', '<f4>', ':set invpaste paste?<cr>', {})
-- vim.api.nvim_set_keymap('i', '<f4>', '<c-o>:set invpaste paste?<cr>', {})
if vim.fn.has('mac') == 1 then
  vim.api.nvim_set_keymap('', '<leader>p', '"*p', {})
  vim.api.nvim_set_keymap('', '<leader>y', '"*y', {})
elseif vim.fn.has('unix') == 1 then
  vim.api.nvim_set_keymap('', '<leader>p', '"+p', {})
  vim.api.nvim_set_keymap('', '<leader>y', '"+y', {})
end
---}}}

---clipboard toogle{{{
--[[ vim.cmd [[
  function! ToggleClipboard()
    if &clipboard == 'unnamed'
      set clipboard& clipboard?
    else
      set clipboard=unnamed clipboard?
    endif
  endfunction
--]]
vim.api.nvim_set_keymap('', '<f5>', 'ToggleClipboard()', { expr = true })
---}}}

---line transposition {{{
vim.api.nvim_set_keymap('n', '<s-down>', ':set fdm=manual<cr>:m .+1<cr>:set fdm=marker<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<s-up>', ':set fdm=manual<cr>:m .-2<cr>:set fdm=marker<cr>', { noremap = true })
vim.api.nvim_set_keymap( 'v', '<s-down>', '<esc>:set fdm=manual<cr>\'<V\'>:m \'>+1<cr>:set fdm=marker<cr>gv',
  { noremap = true })
vim.api.nvim_set_keymap( 'v', '<s-up>', '<esc>:set fdm=manual<cr>\'<V\'>:m \'<-2<cr>:set fdm=marker<cr>gv',
  { noremap = true })
---}}}

---select last inserted text {{{
vim.api.nvim_set_keymap('n', 'gV', '`[v`]', { noremap = true })
---}}}

---write with capital W{{{
vim.cmd [[
  command! W w
]]
---}}}

---delete trailling whitespace {{{
vim.api.nvim_set_keymap('n', '<leader>dt', ':execute "silent normal! mq" \':%s/\\s\\+$//ge\' "\\r`q"<cr>',
  { silent = true })
---}}}

---starts very magic regex {{{
vim.api.nvim_set_keymap('n', '/', '/\\v', { noremap = true })
vim.api.nvim_set_keymap('n', '?', '?\\v', { noremap = true })
---}}}

--}}}

-- autocmd {{{
vim.cmd [[
  augroup vimrctweaks
    autocmd!

    "create directory if not exist
    " https://travisjeffery.com/b/2011/11/saving-files-in-nonexistent-directories-with-vim/
    function! s:auto_mkdir(dir, force)
      if !isdirectory(a:dir)
            \ && (
            \     a:force
            \     || input("'" . a:dir . "' does not exist. Create? [y/N]") =~? '^y\%[es]$'
            \    )
          call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
      endif
    endfunction
    autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)

    "configuration files
    autocmd BufNewFile,BufRead *.*rc,*rc,init.lua setlocal foldmethod=marker

    "rmd
    " adds vim-markdown as a filetype plugin in order to allow
    " for syntax highlighing and folding.
    autocmd FileType rmd runtime ftplugin/markdown.vim
    autocmd FileType rmd runtime after/ftplugin/markdown.vim

    "julia
    autocmd BufNewFile,BufRead *.jl set filetype=julia
    " to get the syntax highlighing working in markdown, you need to add a
    " syntax for Julia which does not come default with NeoVim
    " https://github.com/JuliaEditorSupport/julia-vim/tree/master/syntax
    autocmd BufNewFile,BufRead *.jmd set filetype=jmd.markdown

    "latex
    autocmd BufWipeout *.tex execute ":!cd " . expand("<afile>:h") . "; latexmk -c " . expand("<afile>:t")

    "asciidoctor
    autocmd Filetype asciidoctor nnoremap <leader>ll :call ToggleAsciidoctorAutocompile()<cr>
    autocmd Filetype asciidoctor nnoremap <leader>lv :silent AsciidoctorOpenHTML<cr>

    "elisp
    autocmd BufNewFile,BufRead *.elisp set filetype=elisp

  augroup END
]]
---}}}
